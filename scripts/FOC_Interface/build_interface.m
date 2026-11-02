% build_interface.m - Simulink buses that mirror foc_shared.h (interface version 2).
% Untested: run it once, then check the generated FOC_Core.h against foc_model_port.h.
% Element ORDER and TYPES must match foc_shared.h. Keep FOC_INTERFACE_VERSION in sync.
IFVER = 2;

in  = {'AD_SP1','uint16'; 'AD_SP2','uint16'; 'Vbus','uint16'; 'HW_Fault','uint16'; ...
       'SpeedSetpoint','int16'; 'StartStopCmd','uint8'; 'FaultClear','uint8'};
out = {'DutyA_h1','uint16'; 'DutyB_h1','uint16'; 'DutyC_h1','uint16'; ...
       'DutyA_h2','uint16'; 'DutyB_h2','uint16'; 'DutyC_h2','uint16'; ...
       'SP1','uint16'; 'SP2','uint16'; 'Ctrl_Fault','uint16'; ...
       'PWMEnable','uint8'; 'ModelState','uint8'};
dg  = {'Id','int16'; 'Iq','int16'; 'SpeedEst','int16'; 'AngleEst','uint16'; ...
       'InterfaceVersion','uint16'; 'ModelVersion','uint16'};

FOC_Inputs_t    = makeBus(in);
FOC_Outputs_t   = makeBus(out);
FOC_ModelDiag_t = makeBus(dg);
% In the model, drive mdiag.InterfaceVersion with the constant IFVER.
% Save the three buses in the data dictionary, for example FOC_Core.sldd.

m = 'FOC_Core';   % model name used by foc_model_port.h
% set_param(m, 'SystemTargetFile','ert.tlc', 'Solver','FixedStepDiscrete', 'FixedStep','80e-6', ...
%              'PurelyIntegerCode','on', 'CodeInterfacePackaging','Reusable function');
% Root Inport  "In"   : Bus: FOC_Inputs_t
% Root Outport "Out"  : Bus: FOC_Outputs_t
% Root Outport "Diag" : Bus: FOC_ModelDiag_t

function bus = makeBus(spec)
    for k = 1:size(spec,1)
        el(k,1) = Simulink.BusElement;           %#ok<AGROW>
        el(k).Name     = spec{k,1};
        el(k).DataType = spec{k,2};
    end
    bus = Simulink.Bus;
    bus.Elements   = el;
    bus.HeaderFile = 'foc_shared.h';   % use the firmware header ...
    bus.DataScope  = 'Imported';       % ... do not generate the typedef
end