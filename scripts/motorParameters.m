

%%......motor parameters............%%
% ......motor is selscted from the product..........%




%% Motor
if Option.Product == 0
    BDnano.Motor.Info                         =   'BDnano Trapezoidal';
    BDnano.Motor.BEMF_AngleOffset             = -60*pi/180;
    BDnano.Motor.Expect_AngleDiffToSetPos     =         25;
    BDnano.Motor.F_FrictionCoeff              =     0.0001;
    BDnano.Motor.iab0_InitialStatorCurrents   =      [0 0];
    BDnano.Motor.Imax_peak                    =          7;
    BDnano.Motor.InductanceMatrix             = [0.00325 0.0016 0.0016;0.0016 0.00325 0.0016;0.0016 0.0016 0.00325];
    BDnano.Motor.J_Inertia                    =  1.761e-05;
    BDnano.Motor.Kcn_BEMFcoeff                = [-0.04994           0   5.359e-05           0   0.0019879           0   0.0010241           0 -1.7863e-05           0  -0.0004087];
    BDnano.Motor.Ke                           =      10.15;
    BDnano.Motor.Ksn_BEMFcoeff                = [-0.02874           0    0.012804           0  -0.0011663           0  0.00057798           0  -0.0014226           0   0.0002444];
    BDnano.Motor.L_SelfInductanceConst        =    0.00325;
    BDnano.Motor.L_StatorInductanceConst      =   -0.00165;
    BDnano.Motor.InductanceMatrix             = [BDnano.Motor.L_SelfInductanceConst -BDnano.Motor.L_StatorInductanceConst -BDnano.Motor.L_StatorInductanceConst;-BDnano.Motor.L_StatorInductanceConst BDnano.Motor.L_SelfInductanceConst -BDnano.Motor.L_StatorInductanceConst;-BDnano.Motor.L_StatorInductanceConst -BDnano.Motor.L_StatorInductanceConst BDnano.Motor.L_SelfInductanceConst];
    BDnano.Motor.Lcn_StatorInductanceCoeff    =          0;
    BDnano.Motor.LOAD_DIRECTION               =          1;
    BDnano.Motor.Lsn_StatorInductanceCoeff    =          0;
    BDnano.Motor.M_MutualInductanceConst      =     0.0016;% minus already considered in plecs model,
    BDnano.Motor.nMax_MaximalSpeedrpm         =       4500;
    BDnano.Motor.nMin_MinimalSpeedrpm         =       2300;
    BDnano.Motor.nNom_NominalSpeedrpm         =       2500;
    BDnano.Motor.PP_NumberOfPolePairs         =          3;
    BDnano.Motor.R_StatorResistance           =    1.53075;
    BDnano.Motor.RotatingDirection            =          1;
    BDnano.Motor.Tcn_CoggingTorqueCoeff       =          0;
    BDnano.Motor.thm0_InitialRotorAngle       =    round(rand(1)*360)*pi/180;
    BDnano.Motor.SkipAlignmentInitAngle       =                  -219.5*pi/180;
    BDnano.Motor.Tsn_CoggingTorqueCoeff       =          0;
    BDnano.Motor.UDC_LinkVoltage              =         50;
    BDnano.Motor.wm0_InitialRotorSpeed        =       0.01;
    Motor = BDnano.Motor;


elseif Option.Product == 1
    BDnano.Motor.Info                         =   'BDnano';
    BDnano.Motor.BEMF_AngleOffset             = -60*pi/180;
    BDnano.Motor.Expect_AngleDiffToSetPos     =         25;
    BDnano.Motor.F_FrictionCoeff              =     0.0001;
    BDnano.Motor.iab0_InitialStatorCurrents   =      [0 0];
    BDnano.Motor.Imax_peak                    =          7;
    BDnano.Motor.LOAD_DIRECTION               =          1;

    BDnano.Motor.J_Inertia                    =  1.761e-05;% New 1.512e-05, we think its little less
    BDnano.Motor.Ls                           =  0.002;% previously BDnano.Motor.L_SelfInductanceConst in matlab
    BDnano.Motor.Lm                           =  0.00064; %previously 0 in matlab 
    BDnano.Motor.Ms                           =  0.00077; %previously BDnano.Motor.M_MutualInductanceConst


    BDnano.Motor.nMax_MaximalSpeedrpm         =       4500;
    BDnano.Motor.nMin_MinimalSpeedrpm         =       2300;
    BDnano.Motor.nNom_NominalSpeedrpm         =       2500;
    BDnano.Motor.PP_NumberOfPolePairs         =          3;
    BDnano.Motor.R_StatorResistance           =    1.53075;
    BDnano.Motor.RotatingDirection            =          1;
    BDnano.Motor.Tcn_CoggingTorqueCoeff       =          0;
    BDnano.Motor.Tsn_CoggingTorqueCoeff       =          0;
    BDnano.Motor.thm0_InitialRotorAngle       =    2*pi/3;%round(rand(1)*360)*pi/180;
    BDnano.Motor.SkipAlignmentInitAngle       =                  -220*pi/180;

    BDnano.Motor.UDC_LinkVoltage              =         50;
    BDnano.Motor.wm0_InitialRotorSpeed        =       0.01;

    BDnano.Motor.Kcn_BEMFcoeff                = [-0.0539 0 0 0 0.00154 0 0.002882 0 0 0 -0.0004026 0 8.228e-05 0 0 0 6.303e-05 0 -0.0001474 0 0 0 -6.677e-05 0 8.228e-05 0 0 0 -8.129e-05 0 -3.498e-06 0 0 0 0.0001694 0 -9.174e-05 0 0 0 -0.0001232 0 0.0001727 0 0 0 1.353e-05 0 -0.0001793 0 0 0 6.523e-05 0 0.0001188 0 0 0 -6.831e-05 0 -4.686e-05 0 0 0 1.661e-05 0 5.874e-06 0 0 0 4.807e-05 0 -2.288e-06 0 0 0 -5.313e-05 0 3.047e-05 0 0 0 2.915e-05 0 -6.017e-05 0 0 0 1.551e-05 0 6.413e-05 0 0 0 -4.763e-05 0 -3.696e-05 0 0 0 5.665e-05 0 6.336e-06 0 0 0 -4.686e-05 0 1.133e-05 0 0 0 1.133e-05 0 -5.148e-05 0 0 0 1.166e-05 0 -1.364e-05 0 0 0 3.531e-05 0 2.574e-05 0 0 0 -1.133e-06 0 -1.617e-05 0 0 0 1.441e-05 0 4.378e-06 0 0 0 -2.42e-05 0 1.54e-05 0 0 0 2.508e-05 0];
    BDnano.Motor.Ksn_BEMFcoeff                = [-0.03113 0 -0.0003685 0 -0.0008679 0 0.001705 0 -0.000121 0 0.0002728 0 9.042e-05 0 4.07e-05 0 -6.248e-05 0 -7.733e-05 0 1.364e-06 0 2.794e-05 0 2.827e-05 0 -9.163e-06 0 6.853e-05 0 1.221e-06 0 6.259e-06 0 -9.416e-05 0 -4.158e-05 0 0 0 5.214e-05 0 8.69e-05 0 -6.897e-06 0 2.849e-06 0 -0.00010153 0 9.636e-06 0 -3.047e-05 0 7.15e-05 0 -7.92e-06 0 3.663e-05 0 -2.387e-05 0 3.146e-06 0 -7.062e-06 0 1.144e-06 0 1.155e-06 0 -2.376e-05 0 3.63e-06 0 -2.354e-06 0 3.113e-05 0 2.156e-05 0 0 0 -1.463e-05 0 -3.861e-05 0 2.772e-06 0 -1.023e-05 0 4.07e-05 0 -4.059e-06 0 2.948e-05 0 -2.123e-05 0 3.597e-06 0 -3.256e-05 0 5.918e-06 0 -1.485e-06 0 2.728e-05 0 6.919e-06 0 0 0 -8.8e-06 0 -3.201e-05 0 0 0 3.278e-06 0 -5.467e-06 0 0 0 -2.167e-05 0 1.408e-05 0 -2.024e-06 0 0 0 -8.305e-06 0 2.189e-06 0 -4.807e-06 0 2.354e-06 0 -1.617e-06 0 1.0505e-05 0 9.559e-06 0 0 0 -1.353e-05 0];
    BDnano.Motor.Ke                           =      10.15;
    BDnano.Motor.L_SelfInductanceConst        =    0.00325;
    BDnano.Motor.L_StatorInductanceConst      =   -0.00165;
    BDnano.Motor.M_MutualInductanceConst      =     -0.00165;% minus already considered in plecs model,
    BDnano.Motor.bemfMeasSpeed                =       6.4;%1000 BEMF profile measurement speed, BEMF profile is at the end
    
    Motor = BDnano.Motor;
    % X5500backEMF_1000rpm;                                 %  get bemf profile data
    X5500backEMF_6dot4rpm;                                  %  get Jans bemf profile data-change bemfMeasSpeed=6.4
    clear BDnano;

elseif Option.Product == 3
    BDnano.Motor.Info                         =   'BDnanoEV1';
    BDnano.Motor.BEMF_AngleOffset             = -180*pi/180; % 180 is the offset
    BDnano.Motor.Expect_AngleDiffToSetPos     =         25;
    BDnano.Motor.F_FrictionCoeff              =     0.0001;
    BDnano.Motor.iab0_InitialStatorCurrents   =      [0 0];
    BDnano.Motor.Imax_peak                    =         15;
    BDnano.Motor.LOAD_DIRECTION               =          1;

    BDnano.Motor.J_Inertia                    =  1.512e-05;% old was1.761e-05,New 1.512e-05, we think its little less
    BDnano.Motor.Ls                           =  118e-6;%  Self inductance 
    BDnano.Motor.Lm                           =  24e-6; %  Fluctuation in self-L and mutual-L of the stator with rotor angle.
    BDnano.Motor.Ms                           =  45e-6; %  Mutual inductance 


    BDnano.Motor.nMax_MaximalSpeedrpm         =       4500;% max speed requirement is 4500
    BDnano.Motor.nMin_MinimalSpeedrpm         =       2300;
    BDnano.Motor.nNom_NominalSpeedrpm         =       2500;
    BDnano.Motor.PP_NumberOfPolePairs         =          3;
    BDnano.Motor.R_StatorResistance           =        0.17;% @SDU measurement Ph-Ph R is 0.36ohm
    BDnano.Motor.RotatingDirection            =          1;
    BDnano.Motor.Tcn_CoggingTorqueCoeff       =          0;
    BDnano.Motor.Tsn_CoggingTorqueCoeff       =          0;
    BDnano.Motor.thm0_InitialRotorAngle       =    2*pi/3;%round(rand(1)*360)*pi/180;
    BDnano.Motor.SkipAlignmentInitAngle       =                  -220*pi/180;

    BDnano.Motor.UDC_LinkVoltage              =         12;
    BDnano.Motor.wm0_InitialRotorSpeed        =       0.01;
    BDnano.Motor.bemfMeasSpeed                =       2000;% BEMF profile measurement speed, BEMF profile is at the end
    
    X8701backEMF_2000rpm;                                  %  get bemf profile data
    Motor = BDnano.Motor; clear BDnanoEV1;    

elseif Option.Product == 4
    BDnano.Motor.Info                         =   'BDnanoEV';
    BDnano.Motor.BEMF_AngleOffset             = -180*pi/180; % 180 is the offset
    BDnano.Motor.Expect_AngleDiffToSetPos     =         25;
    BDnano.Motor.F_FrictionCoeff              =     0.0001;
    BDnano.Motor.iab0_InitialStatorCurrents   =      [0 0];
    BDnano.Motor.Imax_peak                    =         15;
    BDnano.Motor.LOAD_DIRECTION               =          1;

    BDnano.Motor.J_Inertia                    =  1.512e-05;% old was1.761e-05,New 1.512e-05, we think its little less
    BDnano.Motor.Ls                           =  160e-6;% 
    BDnano.Motor.Lm                           =  35e-6; % 
    BDnano.Motor.Ms                           =  64e-6; %


    BDnano.Motor.nMax_MaximalSpeedrpm         =       3000;
    BDnano.Motor.nMin_MinimalSpeedrpm         =       2300;
    BDnano.Motor.nNom_NominalSpeedrpm         =       2500;
    BDnano.Motor.PP_NumberOfPolePairs         =          3;
    BDnano.Motor.R_StatorResistance           =        0.30;% theotitical resistance 0.14ohm in datasheet but real ,measurement 0.3ohm
    BDnano.Motor.RotatingDirection            =          1;
    BDnano.Motor.Tcn_CoggingTorqueCoeff       =          0;
    BDnano.Motor.Tsn_CoggingTorqueCoeff       =          0;
    BDnano.Motor.thm0_InitialRotorAngle       =    2*pi/3;%round(rand(1)*360)*pi/180;
    BDnano.Motor.SkipAlignmentInitAngle       =                  -220*pi/180;

    BDnano.Motor.UDC_LinkVoltage              =         12;
    BDnano.Motor.wm0_InitialRotorSpeed        =       0.01;
    BDnano.Motor.bemfMeasSpeed                =       4000;% BEMF profile measurement speed, BEMF profile is at the end
    
    X5550backEMF_4000rpm;                                  %  get bemf profile data
    Motor = BDnano.Motor; clear BDnanoEV;    
end

% ..................Inverter parameters................%
%% Inverter
option.inverter=2;    % 1= inverter_ver1, 2=inverter_ver2


if ((Option.Product == 0) || (Option.Product == 1) )
    BD2740.Inverter.ADC_DetectD.KlowTHu            = 1;
    BD2740.Inverter.ADC_DetectD.KlowTHd            = 4;
    BD2740.Inverter.ADC_DetectD.KhighTHu           = 3;
    BD2740.Inverter.ADC_DetectD.KhighTHd           = 4;
    BD2740.Inverter.Cdc_DClinkCapacitor            = 4.7e-6;
    BD2740.Inverter.CurrentLimiter.PWMoff          = 1;
    BD2740.Inverter.DutyCycleDuringDemag_Array     = [3108 100;3167 99;3228 98;3289 97;3352 96;3415 95;3479 94;3543 93;3609 92;3675 91;3743 90;3811 89;3881 88;3951 87;4022 86;4095 85;4168 84;4243 83;4318 82;4395 81;4473 80;4552 79;4632 78;4713 77;4796 76;4880 75;4965 74;5052 73;5140 72;5229 71;5320 70];
    BD2740.Inverter.ID                             = '000000001';
    BD2740.Inverter.Imax                           = 7;
    BD2740.Inverter.Info                           = 'BDn2740';
    BD2740.Inverter.initUDC_LinkVoltage            = 28;
    BD2740.Inverter.Rd                             = 0.009;
    BD2740.Inverter.Revision                       = 'Rev0.0';
    BD2740.Inverter.Ron                            = 0.009;
    BD2740.Inverter.Source                         = '';
    BD2740.Inverter.SpeedControl.FastDemagOn       = 1;
    BD2740.Inverter.SpeedControl.Ki                = 50;  %50
    BD2740.Inverter.SpeedControl.Kp                = 0.5;%0.5
    BD2740.Inverter.SpeedControl.Ts                = 1e-6; %PI controller sample time
    BD2740.Inverter.SpeedControl.OpenLoopSpeed     = 3000;
    BD2740.Inverter.SpeedControl.SwitchFreq        = 5500;
    BD2740.Inverter.SW_lag_C_detection_time_delay  =   1e-06;
    BD2740.Inverter.SW_lag_C_setting_time_delay    =  50e-06;
    BD2740.Inverter.SW_lag_commutation_angle_delay =       0;
    BD2740.Inverter.SW_lag_D_detection_time_delay  = 100e-06;
    BD2740.Inverter.SW_lag_Z_detection_time_delay  =  50e-06;
    BD2740.Inverter.SwitchFreqCurrentLimiter       = 250000;
    BD2740.Inverter.UDC_LinkVoltage                = 50;%50
    BD2740.Inverter.UDC_LinkVoltage_Max            = 50;%50
    BD2740.Inverter.UDC_LinkVoltage_Min            = 9;
    BD2740.Inverter.Umin                           = 9.6;
    BD2740.Inverter.Vd                             = 0.8;
    BD2740.Inverter.Vf                             = 3.1;%0
    BD2740.Inverter.OffState_f                      = 1e-4;
    BD2740.Inverter.OffState_d                      = 1e-5;
    Inverter = BD2740.Inverter; clear BD2740;
elseif (Option.Product == 3 || Option.Product == 4)

    BD3000.Inverter.ADC_DetectD.KlowTHu            = 1;
    BD3000.Inverter.ADC_DetectD.KlowTHd            = 4;
    BD3000.Inverter.ADC_DetectD.KhighTHu           = 3;
    BD3000.Inverter.ADC_DetectD.KhighTHd           = 4;
    BD3000.Inverter.Cdc_DClinkCapacitor            = 4.7e-6;
    BD3000.Inverter.CurrentLimiter.PWMoff          = 1;
    BD3000.Inverter.DutyCycleDuringDemag_Array     = [3108 100;3167 99;3228 98;3289 97;3352 96;3415 95;3479 94;3543 93;3609 92;3675 91;3743 90;3811 89;3881 88;3951 87;4022 86;4095 85;4168 84;4243 83;4318 82;4395 81;4473 80;4552 79;4632 78;4713 77;4796 76;4880 75;4965 74;5052 73;5140 72;5229 71;5320 70];
    BD3000.Inverter.ID                             = '000000001';
    BD3000.Inverter.Imax                           = 15;
    BD3000.Inverter.Info                           = 'BDn3000';
    BD3000.Inverter.initUDC_LinkVoltage            = 12;
    BD3000.Inverter.Rd                             = 0.009;
    BD3000.Inverter.Revision                       = 'Rev0.0';
    BD3000.Inverter.Ron                            = 0.009;
    BD3000.Inverter.Source                         = '';
    BD3000.Inverter.SpeedControl.FastDemagOn       = 1;
    BD3000.Inverter.SpeedControl.Ki                = 10;  %50
    BD3000.Inverter.SpeedControl.Kp                = 0.3;%0.5
    BD3000.Inverter.SpeedControl.Ts                = 30e-3; %PI controller sample time
    BD3000.Inverter.SpeedControl.OpenLoopSpeed     = 3000;
    BD3000.Inverter.SpeedControl.SwitchFreq        = 6500;
    BD3000.Inverter.SW_lag_C_detection_time_delay  =   1e-06;
    BD3000.Inverter.SW_lag_C_setting_time_delay    =  50e-06;
    BD3000.Inverter.SW_lag_commutation_angle_delay =       0;
    BD3000.Inverter.SW_lag_D_detection_time_delay  = 100e-06;
    BD3000.Inverter.SW_lag_Z_detection_time_delay  =  50e-06;
    BD3000.Inverter.SwitchFreqCurrentLimiter       = 250000;
    BD3000.Inverter.UDC_LinkVoltage                = 12;%50
    BD3000.Inverter.UDC_LinkVoltage_Max            = 12;%50
    BD3000.Inverter.UDC_LinkVoltage_Min            = 9;
    BD3000.Inverter.Umin                           = 9.6;
    BD3000.Inverter.Vd                             = 0.8;
    BD3000.Inverter.Vf                             = 3.1;%0
    BD3000.Inverter.OffState_f                      = 1e-4;
    BD3000.Inverter.OffState_d                      = 1e-5;
    Inverter = BD3000.Inverter; clear BD3000;

end
%.............Plot  Back EMF.........................%

%% BEMF Filter 
% (hardware is not switched in the model, therefore both parameter set needs to be loaded
if (Option.Product == 0) || (Option.Product == 1)    
    BD2740.bemf_filter.R406.value  = 100e3;
    BD2740.bemf_filter.R414.value  = 100e3;
    BD2740.bemf_filter.R424.value  = 100e3;
    BD2740.bemf_filter.R407.value  = 5.6e3;
    BD2740.bemf_filter.R415.value  = 5.6e3;
    BD2740.bemf_filter.R425.value  = 5.6e3;
    
    BD2740.bemf_filter.C405.value  = 3.3e-9;
    BD2740.bemf_filter.C405.init_u =      0;
    BD2740.bemf_filter.C414.value  = 3.3e-9;
    BD2740.bemf_filter.C414.init_u =      0;
    BD2740.bemf_filter.C424.value  = 3.3e-9;
    BD2740.bemf_filter.C424.init_u =      0;
    
    BD2740.bemf_filter.R426.value  =  27e3;
    BD2740.bemf_filter.R427.value  =  27e3;
    BD2740.bemf_filter.R428.value  =  27e3;
    
elseif (Option.Product == 3 || Option.Product == 4)    
    BD3000.bemf_filter.R406.value  = 100e3;
    BD3000.bemf_filter.R407.value  = 10e3;
    BD3000.bemf_filter.R414.value  = 100e3;
    BD3000.bemf_filter.R415.value  = 10e3;
    BD3000.bemf_filter.R424.value  = 100e3;
    BD3000.bemf_filter.R425.value  = 10e3;
    
    BD3000.bemf_filter.C405.value  = 1e-9;
    BD3000.bemf_filter.C405.init_u =    0;
    BD3000.bemf_filter.C415.value  = 1e-9;
    BD3000.bemf_filter.C415.init_u =    0;
    BD3000.bemf_filter.C424.value  = 1e-9;
    BD3000.bemf_filter.C424.init_u =    0;
    
    BD3000.bemf_filter.R426.value  =  10e3;
    BD3000.bemf_filter.R427.value  =  10e3;
    BD3000.bemf_filter.R428.value  =  10e3;
end


