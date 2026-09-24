function p = ss_params()
%SS_PARAMS Constants mirrored from this project's single-shunt firmware.
%
% Sources (this repo):
%   Inc/drive_parameters.h            - PWM_FREQUENCY, REGULATION_EXECUTION_RATE, ADC_SAMPLING_CYCLES
%   Inc/power_stage_parameters.h      - RSHUNT, AMPLIFICATION_GAIN, TNOISE_NS, TRISE_NS
%   Inc/parameters_conversion_g4xx.h  - ADV_TIM_CLK_MHz, ADC_CLK_MHz, ADC_SAR_CYCLES, ADC_TRIG_CONV_LATENCY_CYCLES
%   Inc/parameters_conversion.h       - PWM_PERIOD_CYCLES, TMIN, TBEFORE(=TSample), REP_COUNTER, CURRENT_CONV_FACTOR
%   Src/mc_parameters.c               - R1_ParamsM1 (ties the above into the R1 driver)
%   Src/main.c                        - ADC_RESOLUTION_12B + ADC_DATAALIGN_LEFT (=> 16-bit-wide raw codes)
%
% All timing is kept in TIM1 clock ticks (170 MHz), exactly like the C
% handler (PWMC_R1_Handle_t), so this can be dropped straight into a
% discrete Simulink model without unit confusion.

%% Clocks
p.AdvTimClk_Hz = 170e6;   % ADV_TIM_CLK_MHz
p.AdcClk_Hz    = 42e6;    % ADC_CLK_MHz

%% PWM / execution rate
p.PwmFreq_Hz         = 12500;                                 % old=16000-PWM_FREQUENCY
p.RegulationExecRate = 1;                                     % REGULATION_EXECUTION_RATE
p.IsrFreq_Hz         = p.PwmFreq_Hz / p.RegulationExecRate;   % ISR_FREQUENCY_HZ
p.Ts                 = 1 / p.IsrFreq_Hz;                       % <-- execution period of the whole
                                                                %     duty-calc + current-reconstruction
                                                                %     chain: 62.5 us (16 kHz)

p.PwmPeriodCycles = bitand(floor(p.AdvTimClk_Hz / p.PwmFreq_Hz), uint32(hex2dec('FFFE'))); % PWM_PERIOD_CYCLES
p.HalfPwmPeriod   = double(p.PwmPeriodCycles) / 2;             % Half_PWMPeriod (ARR, timer ticks)

p.RepetitionCounter = p.RegulationExecRate * 2 - 1;            % REP_COUNTER

%% ADC / current-loop timing (timer ticks @ AdvTimClk)
p.AdcSamplingCycles     = 6.5;   % ADC_SAMPLING_CYCLES = 6 + SAMPLING_CYCLE_CORRECTION(0.5)
p.AdcTrigConvLatencyCyc = 3.5;   % ADC_TRIG_CONV_LATENCY_CYCLES
p.AdcSarCycles          = 12.5;  % ADC_SAR_CYCLES

p.TSample  = floor((p.AdcTrigConvLatencyCyc + p.AdcSamplingCycles) * p.AdvTimClk_Hz / p.AdcClk_Hz) + 1; % TBEFORE
p.hTADConv = floor((p.AdcSarCycles + p.AdcTrigConvLatencyCyc) * p.AdvTimClk_Hz / p.AdcClk_Hz);           % hTADConv

p.DeadTime_ns = 1000;   %old=750 SW_DEADTIME_NS
p.TNoise_ns   = 1200;  % TNOISE_NS (= MAX_TNTR_NS)
p.TRise_ns    = 61;    % TRISE_NS

p.TDead  = floor(p.DeadTime_ns * p.AdvTimClk_Hz / 1e9);          % TDEAD
p.TAfter = p.TDead + floor(p.TNoise_ns * p.AdvTimClk_Hz / 1e9);  % TAFTER
p.TMin   = p.TAfter + p.TSample;                                  % TMIN: minimum ON-time window
                                                                    % needed around a commutation edge to
                                                                    % trigger + finish an ADC injected
                                                                    % conversion cleanly (~2.19 us @ 170 MHz)

%% Current-sense analog chain
p.Rshunt = 0.0375;   % 0.005 ohm      (RSHUNT)
p.Gain   = 2.933;    % 7.33 V/V      (AMPLIFICATION_GAIN)
p.Vref   = 3.3;      % volts    (ADC_REFERENCE_VOLTAGE)

% ADC is 12-bit (ADC_RESOLUTION_12B) but main.c configures
% ADC_DATAALIGN_LEFT, i.e. the 12-bit result sits in the top bits of a
% 16-bit register -> raw codes span 0..65535 in steps of 16.
p.AdcFullScaleCounts = 65536;

p.CurrentConvFactor    = p.AdcFullScaleCounts * p.Rshunt * p.Gain / p.Vref; % CURRENT_CONV_FACTOR [digit/A]
p.CurrentConvFactorInv = 1 / p.CurrentConvFactor;                            % CURRENT_CONV_FACTOR_INV [A/digit]
p.MaxReadableCurrent_A = p.Vref / (2 * p.Rshunt * p.Gain);                   % M1_MAX_READABLE_CURRENT

% Calibrated at startup by R1_CurrentReadingCalibration() (averages
% NB_CONVERSIONS injected samples with zero motor current); model it as
% ideal mid-scale here.
p.Offset = p.AdcFullScaleCounts / 2;

%% Current-loop PI gains (Src/mc_config.c, Inc/drive_parameters.h)
% PI_Controller() (MCSDK_v6.4.2-Full/.../Src/pid_regulator.c) operates on
% currents as raw ADC-digit values and outputs a raw int16 voltage where
% +-32767 = +- max achievable phase voltage (the same per-unit scale as
% "m" in ss_svpwm_minmax.m). Convert Id/Iq from Amps to digits via
% p.CurrentConvFactor before calling ss_pi_controller.m, and divide its
% output by p.VoltageFullScale to get back to per-unit voltage.
p.VoltageFullScale = 32767; % INT16_MAX

p.IQ_Kp = 134; p.IQ_Ki = 1070; p.IQ_KpDiv = 512; p.IQ_KiDiv = 16384;   % PID_TORQUE_KP/KI_DEFAULT, TF_KPDIV/KIDIV
p.ID_Kp = 134; p.ID_Ki = 1070; p.ID_KpDiv = 512; p.ID_KiDiv = 16384;   % PID_FLUX_KP/KI_DEFAULT, TF_KPDIV/KIDIV

p.PI_OutUpper = 32767;  p.PI_OutLower = -32767;                         % hUpperOutputLimit/hLowerOutputLimit
p.PI_IntegUpper = 32767 * 16384; p.PI_IntegLower = -32767 * 16384;      % wUpperIntegralLimit/wLowerIntegralLimit (same for Id and Iq, both use TF_KIDIV)

%% Motor/stator electrical parameters (Inc/pmsm_motor_parameters.h,
%% Inc/power_stage_parameters.h) - for ss_stator_model.m, a bench-test
%% stand-in for the real motor (see that file's header for scope/caveats)
p.MotorRS = 0.30;      % 0.15 ohm     (RS)
p.MotorLS = 160e-6;  %  0.329e-3 henries (LS)
p.Vbus    = 12;        % 32 volts   (NOMINAL_BUS_VOLTAGE_V)
% p.VphaseMax = p.Vbus / sqrt(3); % max fundamental per-unit=1 phase voltage
%                                 % in the linear SVM range - the same
%                                 % per-unit scale "m"/Va/Vb/Vc/Valpha/Vbeta
%                                 % already use throughout this build

% TWO DIFFERENT voltage scales - do not mix them up:
%  VphasePerUnit : volts per 1.0 of Va/Vb/Vc entering ss_svpwm_minmax. That block
%                  computes dX = 0.5 + 0.5*(Vx+v0), so Vx = 1.0 gives a phase
%                  voltage amplitude of 0.5*Vbus. Confirmed independently by the
%                  measured voltage-ceiling speed of 4260 rpm, which needs 6.0 V
%                  (Vbus/sqrt(3) = 6.93 V would predict 5030 rpm). THIS is the
%                  per-unit -> volts factor for the observer and for the current
%                  PI, whose +-32767 output means +-1.0 pu.
%  VphaseMaxLinear : the linear-modulation CEILING, reached at 1.1547 pu
%                  (= 2/sqrt(3)). Use only when you mean "how much voltage can
%                  this bus deliver", never as a per-unit conversion.
p.VphasePerUnit   = p.Vbus / 2;         % 6.000 V
p.VphaseMaxLinear = p.Vbus / sqrt(3);   % 6.928 V
p.VphaseMax       = p.VphaseMaxLinear;  % legacy name, kept so nothing breaks


p.MotorPolePairs = 3;  % POLE_PAIR_NUM
p.ThetaOffset_rad = -pi/2;


%% Startup align/ramp (Inc/drive_parameters.h PHASE1..5_DURATION /
%% _FINAL_SPEED_UNIT / _FINAL_CURRENT_A, TRANSITION_DURATION)
p.Startup_T   = [0.100 0.250 0.251 0.252 0.253];   % cumulative breakpoints, if inertia of rotor changes or the rotor start angle changes then make alignment time to 0.200
p.Startup_RPM = [0 0 2500 2510 2520 2530];          % mechanical rpm at 0,T1..T5
p.Startup_Id_A = 10;      % PHASE1_FINAL_CURRENT_A - align, pure d
p.Startup_Iq_A = 4;      % PHASE2..5_FINAL_CURRENT_A - ramp, pure q
p.Startup_TransitionDuration = 0.025;

%------Test Parameters------
p.Idref_A=0;
p.Iqref_A=2;    % negative Iq can turn the motor in negative direction
p.LoadTorqueMag = 0.02;   % N*m braking magnitude, always opposes rotation
%% Measured back-EMF reference speed (ss_bemf_data.m, ss_bemf_lookup.m)
% Profile measured at 1000 RPM mechanical = 1000/60*POLE_PAIR_NUM Hz
% electrical (works out to exactly 50 Hz - the same fe used as this
% build's test electrical frequency throughout).
% NOTE: the theta_elec_deg/BEMF_shape_V lookup TABLE itself is
% deliberately NOT stored in this struct (unlike everything else here) -
% call [thetaDeg,bemfV] = ss_bemf_data() once (e.g. in the model's
% InitFcn) and feed it to ss_bemf_lookup.m via two separate Constant
% blocks instead. Bundling a 301-element vector into "p" risks needing to
% regenerate whatever Simulink Bus object your model already has defined
% for "p" as a MATLAB Function block port.
p.BemfRefRPM = 1000;
p.BemfRefWe = 2*pi * (p.BemfRefRPM/60) * p.MotorPolePairs;

%% IaEst/IbEst/IcEst estimator filter (Inc/parameters_conversion.h,
%% LPF_FILT_CONST) - for ss_calc_phase_currents_est.m
p.LPF_FILT_CONST = 16383;            % (int16_t)(32767*0.5), truncated
p.LPFAlpha = p.LPF_FILT_CONST / 32768; % simplified equivalent of
                                        % PWMC_LowPassFilter's Q15
                                        % accumulator recursion (~0.5)

%% PWM carrier (fast-rate) generation - ss_pwm_carrier_step.m,
%% ss_pwm_gate_step.m. NOT a real hardware rate (the real timer runs at
%% p.AdvTimClk_Hz=170MHz - far too fine for a practical Simulink discrete
%% step count); Nfast is just fine enough to resolve clean edges and a
%% meaningful dead-time gap. Everything else in this build stays at
%% p.Ts - only a dedicated fast subsystem (fed the slow-rate CCR_up/
%% CCR_down through a Rate Transition block) runs at p.FastTs.
p.PwmCarrierSamplesPerPeriod = 80;                       % old 80, Nfast, samples per full up-down period
p.FastTs = p.Ts / p.PwmCarrierSamplesPerPeriod;            % fast subsystem's sample time, seconds
p.TicksPerFastStep = (2*p.HalfPwmPeriod) / p.PwmCarrierSamplesPerPeriod; % timer ticks per fast step
p.DeadTimeFastSteps = round(p.TDead / p.TicksPerFastStep); % dead-time expressed in fast steps

p.AdcTrigAlignSteps = 3;   % fast steps of pipeline delay between the gate
                           % vector and Vamp_out (Delay6elements at the root)
%% Speed loop (Src/speed_torq_ctrl.c STC_CalcTorqueReference, Src/mc_config.c
%% PIDSpeedHandle_M1, Inc/drive_parameters.h) - reuses ss_pi_controller.m
%% as-is, just with these gains, at its own (slower) rate.
p.IqMax_A = 15;  % IQMAX_A - speed PI's output clamp, in Amps

p.SpeedLoopFreq_Hz = 2083;                                    % SPEED_LOOP_FREQUENCY_HZ
p.SpeedExecRate = round(p.PwmFreq_Hz / p.SpeedLoopFreq_Hz);   % current-loop periods per speed-loop tick
p.SpeedTs = p.Ts * p.SpeedExecRate;                           % speed loop's own sample time, seconds

p.Speed_Kp = 2426; p.Speed_Ki = 476; p.Speed_KpDiv = 16; p.Speed_KiDiv = 1024; % PID_SPEED_KP/KI_DEFAULT, SP_KPDIV/KIDIV

% SPEED_UNIT = U_01HZ = mechanical speed in units of 0.1 Hz; 1 unit =
% U_RPM/SPEED_UNIT = 60/10 = 6 RPM (SPEED_UNIT_2_RPM). Converts wmech
% [rad/s mechanical] directly to SPEED_UNIT for the speed-loop error.
p.SpeedUnitsPerRadS = (60/(2*pi)) / 6;

p.Speed_OutUpper = p.IqMax_A * p.CurrentConvFactor;   p.Speed_OutLower = -p.Speed_OutUpper;      % hUpperOutputLimit = IQMAX (digits)
p.Speed_IntegUpper = p.Speed_OutUpper * p.Speed_KiDiv; p.Speed_IntegLower = -p.Speed_IntegUpper; % wUpperIntegralLimit = IQMAX*SP_KIDIV


p.SpeedRef_SlewUp_RPMps   = 20000;   % must exceed p.Startup_RPM(3)/(T2-T1)
p.SpeedRef_SlewDown_RPMps = 3000;    % post-handover approach to the target

%% STO-PLL sensorless observer (Src/sto_pll_speed_pos_fdbk.c, Src/mc_config.c
%% STO_PLL_M1, Inc/drive_parameters.h) - Stage 1: Luenberger current/back-EMF
%% observer only, for ss_sto_observer_step.m. (Stage 2, the PLL angle/speed
%% tracker built on top of this, is not implemented yet.)
%
% G1 (current-correction gain) is carried over from the firmware AS-IS:
% GAIN1=-24227 is itself scaled by F1=16384 (Ialfa_est's internal fixed-
% point scale factor), and that scale factor exactly cancels in the ratio
% GAIN1/F1 - it's a plain dimensionless proportional gain (current-error
% in, current-correction out, same units both sides), so it transfers
% directly into this floating-point/SI-unit port with no rescaling needed.
p.STO_G1 = -24227/16384; % GAIN1/F1

% G2 (back-EMF-correction gain) is NOT carried over bit-for-bit: firmware's
% GAIN2=19705 (scaled by F2=1024, Bemf_est's internal factor) lives inside
% the firmware's own ADC-digit/voltage-digit fixed-point scaling chain
% (MAX_CURRENT/MAX_VOLTAGE/MAX_BEMF_VOLTAGE) - unwinding that exactly would
% just reproduce ONE particular tuning choice among many valid ones, not
% add fidelity. Instead: discrete pole-placement (a standard, principled
% design method for this exact observer structure - current-error and
% back-EMF-error dynamics, decoupled from the alpha/beta rotation coupling
% for gain SELECTION only; the runtime equations in ss_sto_observer_step.m
% keep the full rotation coupling).
%
% Discrete current-error coefficient once G1 is fixed:
%   eI_next = a*eI - (Ts/L)*eE,  a = 1 - Ts*R/L + G1
% Target: real, equal eigenvalues splitting the (G1-fixed) trace evenly ->
% critically-damped, fast convergence (<1% residual within ~5-6*Ts), well
% inside the ~2.2ms electrical / ~18ms mechanical time constants.
a_ei = 1 - p.Ts*p.MotorRS/p.MotorLS + p.STO_G1;
b_ei = -p.Ts/p.MotorLS;
targetEig_sto = (a_ei + 1) / 2;
p.STO_G2 = (a_ei - targetEig_sto^2) / b_ei; % V/A

%% STO-PLL Stage 2: PLL loop filter (ss_pll_step.m). Firmware's own
%% PLL_KP_GAIN=449/PLL_KI_GAIN=20 (PLL_KPDIV=16384/PLL_KIDIV=65535) operate
%% on the phase-detector error in the firmware's internal Q15 "Bemf-digit"
%% scale, producing an output directly in "Dpp" (angle-increment-per-PLL-
%% step) units - unwinding that scaling chain (ADC-domain Bemf scale <->
%% our SI volts, and Dpp <-> rad/s) isn't a clean 1:1 mapping the way
%% STO_G1 was, so - same reasoning as STO_G2 above - these gains are
%% re-designed directly from the phase-detector's own physical structure
%% rather than reverse-engineered bit-for-bit.
%
% Phase detector: error = Bemf_beta_est*cos(theta_est) -
% Bemf_alpha_est*sin(theta_est) = |Bemf|*sin(theta_true-theta_est) for
% small angle error - i.e. a proportional-to-sin phase detector with gain
% |Bemf| [V/rad], exactly like a classical PLL with a multiplying phase
% detector. Design as a standard second-order PLL (loop filter = PI, plant
% = pure integrator from we_est to theta_est): closed-loop characteristic
% polynomial s^2 + Kd*Kp_c*s + Kd*Ki_c, matched to s^2 + 2*zeta*wn*s + wn^2.
% Kd (the phase detector gain) is evaluated at this motor's measured
% back-EMF peak (theta_elec_deg/BEMF_shape_V's own amplitude, ss_bemf_data.m)
% at the reference speed the profile was measured at - the same fixed-gain-
% at-a-nominal-operating-point approach the firmware itself uses (its own
% Kp/Ki are speed-independent constants too).
%
% wn/zeta chosen so the PLL is comfortably slower than the Stage-1
% observer's own convergence (~5-6*Ts, i.e. >1kHz-ish) but faster than the
% speed loop and mechanical dynamics it ultimately feeds - standard nested-
% loop bandwidth separation. Also needs to stay well BELOW the actual
% electrical frequency it tracks (fe=we/2pi, NOT the mechanical RPM) -
% first tried 100 Hz, but that's almost exactly fe at 2300 RPM
% (2300/60*3=115 Hz): with the PLL's own bandwidth sitting on top of the
% fundamental, it chased real-world current-reconstruction/PWM ripple
% instead of filtering it out (visible as a beating phaseErr and a much
% noisier we_est than the smooth true we in the full-model scope test).
% Then tried 15 Hz (7-8x separation from fe) - clean steady-state, but
% plot_sto_pll_handoff.m showed it doesn't fully converge within the
% firmware's own (faithful, not-to-be-changed) T1-T5 align/ramp timing:
% ~13 deg angle error still present at T5. 30 Hz is the compromise: ~3 deg
% error at T5, converges to <0.1 deg by the end of the 25ms
% TRANSITION_DURATION blend, and still keeps ~4x separation from fe (a
% real margin, unlike the 100Hz case which had almost none) - TUNABLE, but
% this is the current balance point between "fast enough to lock on within
% the real align/ramp window" and "slow enough to reject real-world
% current-reconstruction/PWM ripple."
p.PLL_BemfPeak_V = 6.568; % max(BEMF_shape_V) from ss_bemf_data.m, at p.BemfRefWe
pll_zeta = 0.707;
pll_wn   = 2*pi*30; % rad/s, ~30 Hz PLL bandwidth

p.PLL_Kp = 2*pll_zeta*pll_wn / p.PLL_BemfPeak_V;      % rad/s per V - applied directly (KpDiv=1, no firmware-style integer split needed in float)
p.PLL_Ki = (pll_wn^2 / p.PLL_BemfPeak_V) * p.Ts;       % rad/s per V per sample (Ts folded in - ss_pi_controller.m's accumulator has no explicit Ts of its own, matching the firmware's own convention)
p.PLL_KpDiv = 1; p.PLL_KiDiv = 1;

p.PLL_WeMax = 1.2 * (2*pi*(4500/60)*p.MotorPolePairs); % rad/s - 20% margin over the ~4500 RPM mechanical max noted elsewhere in this build
p.PLL_OutUpper = p.PLL_WeMax;    p.PLL_OutLower = -p.PLL_WeMax;
p.PLL_IntegUpper = p.PLL_OutUpper * p.PLL_KiDiv; p.PLL_IntegLower = -p.PLL_IntegUpper;

%% Switchover trigger (ss_startup_trigger.m) - real firmware constants
%% (Inc/drive_parameters.h): SPEED_BAND_LOWER_LIMIT=15,
%% SPEED_BAND_UPPER_LIMIT=17 (percent - STO_PLL_IsObserverConverged
%% requires the estimated speed within this band of the forced speed),
%% NB_CONSECUTIVE_TESTS=2 (consecutive in-band calls required before
%% declaring convergence). Symmetric +-15% (the more conservative of the
%% two) used here rather than the exact asymmetric 15/17% band, since this
%% build doesn't otherwise distinguish upper/lower speed-error direction.
p.ConvergenceBand_Frac = 0.15;      % SPEED_BAND_LOWER_LIMIT/100
p.ConvergenceConsecutiveSamples = 2; % NB_CONSECUTIVE_TESTS

%% ---- Simulation timing mode ---------------------------------------------
% Everything above is the exact firmware tick arithmetic. The real MCU resolves
% sample points to 1/170 MHz = 5.9 ns; this model can only resolve
% p.TicksPerFastStep = 170 ticks = 1 us, so TSample (41) and hTADConv (64) are
% FRACTIONS of a simulation step. That is what makes the emulation fragile -
% not the algorithm.
%
% 'sim' rounds the ADC / dead-time constants to whole fast steps so every
% sample point lands exactly on a carrier grid step with >= 2 steps of margin
% on each side. R1_CalcDutyCycles, R1_GetPhaseCurrents, the sector table and
% the aShiftval logic are all UNTOUCHED - only the resolution they work at.
% Set 'hw' to restore firmware values (needs PwmCarrierSamplesPerPeriod >= 340).
timingRelaxed = true;        % local on purpose - NOT a field of p

if timingRelaxed
    st = p.TicksPerFastStep;          % 170 ticks = 1 fast step = 1 us

    p.TSample  = 2*st;                % was 41   -> trig1 sits 2 steps before the mid edge
    p.hTADConv = 2*st;                % was 64
    p.TDead    = 1*st;                % was 170  - already exactly 1 step
    p.TAfter   = 2*st;                % was 374  -> trig2 sits 2 steps after the mid edge
    p.TMin     = p.TAfter + p.TSample;        % 680 ticks = 4 fast steps

    p.DeadTimeFastSteps = round(p.TDead / p.TicksPerFastStep);      % = 1

    % keep the ns figures readable and consistent
    p.DeadTime_ns = p.TDead / p.AdvTimClk_Hz * 1e9;                 % 1000 ns
    p.TNoise_ns   = (p.TAfter - p.TDead) / p.AdvTimClk_Hz * 1e9;    % 1000 ns
end
p.TimingRelaxed = double(timingRelaxed);      % numeric flag is safe inside p
end
