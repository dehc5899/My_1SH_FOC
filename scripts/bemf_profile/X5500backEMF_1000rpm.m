%% 117X5500 (BDn) have 74 turns
%% 1. Define Parameters and Data
% New Dataset
X_orig = [0 6 18 30 42 54 66 78 90 102 114 ...
          126 138 150 162 174 186 198 210 ...
          222 234 246 258 270 282 294 306 ...
          318 330 342 354];

Y_orig = [-5.148169541 -5.631918184 -6.298824528 -6.5673609 ...
          -6.293422315 -5.636094509 -5.143343781 -4.532637355 ...
          -3.214981788 -1.618393682 -0.424100461 0.425545415 ...
          1.623286849 3.195146544 4.529821672 5.148174554 ...
          5.631907743 6.298481397 6.568030577 6.293109652 ...
          5.636094662 5.143338465 4.532865861 3.214650878 ...
          1.618488198 0.424094483 -0.425527139 -1.623192485 ...
          -3.19544565 -4.529623159 -5.148169541];

% Force the original vectors into clean row vectors
% X_orig = X_orig(:)';
% Y_orig = Y_orig(:)';

%% 2. Pinpoint the rising zero-crossing
idx_all = find(Y_orig(1:end-1) <= 0 & Y_orig(2:end) > 0);
idx = idx_all(1);
x0 = X_orig(idx);     x1 = X_orig(idx+1);
y0 = Y_orig(idx);     y1 = Y_orig(idx+1);
x_zero = x0 - y0 * (x1 - x0) / (y1 - y0); 

%% 3. Periodic Phase Shift & Wrap Around
X_shifted = X_orig - x_zero;
X_wrapped = mod(X_shifted, 360);

% Sort the wrapped vectors chronologically
[X_wrapped, sortIdx] = sort(X_wrapped);
Y_wrapped = Y_orig(sortIdx);

% --- FIX: Remove duplicate sample points caused by modulo wrapping ---
[X_wrapped, uniqueIdx] = unique(X_wrapped, 'stable');
Y_wrapped = Y_wrapped(uniqueIdx);

% --- FORCING EXCLUSIVELY PERFECT 0V BOUNDARIES ---
if X_wrapped(1) == 0
    X_wrapped(1) = [];
    Y_wrapped(1) = [];
end
if X_wrapped(end) == 360
    X_wrapped(end) = [];
    Y_wrapped(end) = [];
end

X_wrapped = [0, X_wrapped, 360];
Y_wrapped = [0, Y_wrapped, 0];  
% -------------------------------------------------

%% 4. Sample onto final full-revolution electrical grid
theta_elec = 0 : 1.2 : 360;  
BEMF_shape = interp1(X_wrapped, Y_wrapped, theta_elec, 'linear');

%% 5. Convert Electrical Degrees to Mechanical Degrees
pole_pairs = 3; 
theta_mech = theta_elec / pole_pairs; 

%% 6. Plot the results to verify
figure;
plot(X_orig, Y_orig, 'r-', 'DisplayName', 'Original Waveform'); hold on;
plot(theta_elec, BEMF_shape, 'b--', 'LineWidth', 1.5, 'DisplayName', 'Phase-Shifted to 0V (Rising)');
plot(theta_mech, BEMF_shape, 'g-.', 'LineWidth', 2, 'DisplayName', 'Shifted Back-EMF in mechanical degree');
xlim([-10 370]);
grid on;
xlabel('Angle (Degrees)');
ylabel('Back-EMF (V)');
title('BDn(X5500)backEMF 1000rpm Phase-A Back-EMF Profile Alignment');
legend('Location', 'best');