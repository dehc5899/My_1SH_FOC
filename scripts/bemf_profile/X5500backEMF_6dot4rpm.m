%% 117X5500 (BDn) have 74 turns
%% 1. Define Parameters and Data
% New Dataset

pole_pairs = 3;
N=pole_pairs;

theta = linspace(0, (2*pi/N), 1024);
    
% Your provided coefficients (truncated for the example)
Kcn = Motor.Kcn_BEMFcoeff;
Ksn = Motor.Ksn_BEMFcoeff;
% Initialize BEMF vector
BEMF = zeros(size(theta));
    
% Sum the harmonics
% IMPORTANT: Use (n * N * theta) to map the nth harmonic 
% to the mechanical rotation of the rotor
for n = 1:length(Kcn)
  BEMF = BEMF + Kcn(n)*cos(n * N * theta) + Ksn(n)*sin(n * N * theta);
end
    
% Round to 5 decimal places
BEMF = round(BEMF, 5);



% Create 120 samples from 0 to 120 degrees
theta_mech = linspace(0, 120, 1024);
% Interpolate BEMF on new theta scale
BEMF_shape = interp1(theta_mech, BEMF, theta_mech, 'spline');
% Plotting to verify

%% 6. Plot the results to verify
figure;
plot(theta_mech, BEMF_shape, 'b--', 'LineWidth', 1.5, 'DisplayName', 'Phase-Shifted to 0V (Rising)');
%plot(theta_mech, BEMF_shape, 'g-.', 'LineWidth', 2, 'DisplayName', 'Shifted Back-EMF in mechanical degree');
% xlim([-10 370]);
grid on;
xlabel('Angle (Degrees)');
ylabel('Back-EMF (V)');
title('BDn(X5500)backEMF 6.4rpm Phase-A Back-EMF Profile Alignment');
legend('Location', 'best');