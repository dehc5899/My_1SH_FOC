function [output, integralTerm_next] = ss_pi_controller(error, integralTerm_prev, ...
    Kp, Ki, KpDiv, KiDiv, OutUpper, OutLower, IntegUpper, IntegLower)
%SS_PI_CONTROLLER MATLAB port of PI_Controller()
% (MCSDK_v6.4.2-Full/MotorControl/MCSDK/MCLib/Any/Src/pid_regulator.c,
% ~lines 622-738). Used for both the Id and Iq current loops (same
% function, different gains - matches how the firmware reuses one
% PI_Controller() for pPIDId[M1] and pPIDIq[M1]).
%
% Structure: proportional term, integral term (accumulated then clamped
% to [IntegLower,IntegUpper] BEFORE being added to the proportional
% term), summed and clamped to [OutLower,OutUpper] - then, distinctively,
% whatever amount was clamped off ("discharge") is fed back and added to
% the stored integral term. That's back-calculation anti-windup: it stops
% the integrator winding up further while the output is saturated,
% without needing a separate windup-detection flag.
%
% NOT ported: the C code's wIntegral_sum_temp int32-overflow guards
% (lines ~654-689) - those exist to protect a 32-bit fixed-point
% accumulator from wrapping around, which isn't a concern in double-
% precision floating point. The control algorithm itself (this function)
% is unaffected by omitting them.
%
% integralTerm_prev/integralTerm_next : the PI's stored integral state
% (pHandle->wIntegralTerm) - feed back through a Unit Delay (Z^-1),
% initial condition 0, same pattern as IaEst/IbEst/IcEst and theta_prev
% elsewhere in this build.
%
% error : reference - measured, in the SAME units the gains were tuned
%         for - i.e. raw ADC-digit-equivalent current, NOT Amps (see
%         ss_params.m's "Current-loop PI gains" section for the Amps<->
%         digit and per-unit-voltage<->raw conversions to do at the call
%         site).
% Kp, Ki, KpDiv, KiDiv, OutUpper, OutLower, IntegUpper, IntegLower :
%         p.IQ_* / p.ID_* / p.PI_* from ss_params.m

propTerm = Kp * error;

if Ki == 0
    integralTerm = 0;
else
    integralSum = integralTerm_prev + Ki * error;
    if integralSum > IntegUpper
        integralTerm = IntegUpper;
    elseif integralSum < IntegLower
        integralTerm = IntegLower;
    else
        integralTerm = integralSum;
    end
end

output_raw = propTerm / KpDiv + integralTerm / KiDiv;

discharge = 0;
if output_raw > OutUpper
    discharge = OutUpper - output_raw;
    output = OutUpper;
elseif output_raw < OutLower
    discharge = OutLower - output_raw;
    output = OutLower;
else
    output = output_raw;
end

integralTerm_next = integralTerm + discharge * KiDiv;

end
