clc;
clear all;
%addpath('bemf_profile');
%............Select the PRODUCT............%
Option.Product        = 4; % 1 = BDnano 2740, 2 = XX, 3 = BDnanoLite1, 4= BDnanaoLite 3000 (0 = BDnano 2740 with Trapedoidal BEMF)

if     Option.Product == 1
    disp('Product = BD nano 2740')
elseif Option.Product == 3
    disp('Product = BD nano EV1 3000') 
elseif Option.Product == 4
    disp('Product = BD nano EV 3000') 
elseif Option.Product == 0
    disp('Product = BD nano TRAPEZIODAL BEMF (same average as option 1)')  
end
%----------------------------------------------------------------------------
Tstop=3;


p = ss_params();
motorParameters; % Executes motorParameter.m
disp('motor Parameters have been loaded.');


% -----------------------------
% Torque based on Experiment
% -----------------------------
tc.gas_condition.experimentdata = 1;
% To use real data, uncomment below and ensure files are in your path:
data = readtable("BDN45F - Measured Cylinder Pressures.xlsx", 'Sheet','-10_55_2300rpm');
x_breakpoints = data{2:end, 1} + 180;
y_table       = data{2:end, 4};
z_table       = data{2:end, 2}; 
if tc.gas_condition.experimentdata == 1
    tc.Load.angle_vec  = x_breakpoints';
    tc.Load.torque_vec = y_table'; 
    tc.Load.pressure_vec = z_table';    % Internal cylinder pressure in bar
end
[angleDeg, torqueNm] = ss_load_torque_data(tc.Load.angle_vec, tc.Load.torque_vec);
figure();
plot(angleDeg, torqueNm);


%---------------------------
fe        = 50;                 % electrical frequency of the test current, Hz
Ipk       = 8;                  % peak phase current, A
m         = 0.5;               % modulation index (0..~1), sets duty separation
loadAngle = deg2rad(20);        % current-vs-voltage phase lag (like a real RL load)
we = 2*pi*fe;


