%% 117X5550 (standard EV) have 21 turns
%% 1. Define Parameters and Data
% Legend: Phase 1
% Line Type: Red
% Point Type: DownTriangle
% Number of Points: 61
% DataType: MagneticDataSource

X_orig = [ ...
    -3, 3, 9, 15, 21, 27, 33, 39, 45, 51, 57, 63, 69, 75, 81, 87, 93, 99, 105, 111, ...
    117, 123, 129, 135, 141, 147, 153, 159, 165, 171, 177, 183, 189, 195, 201, 207, ...
    213, 219, 225, 231, 237, 243, 249, 255, 261, 267, 273, 279, 285, 291, 297, 303, ...
    309, 315, 321, 327, 333, 339, 345, 351, 357 ...
];

Y_orig = [ ...
    -3.77826162203366, -4.02687080737363, -4.39663335237907, -4.89810721191712, ...
    -5.33430022393819, -5.51230092472137, -5.51331215390258, -5.33770522920931, ...
    -4.91303508538556, -4.40247858922512, -4.02820036526023, -3.77243608324976, ...
    -3.56396961551804, -3.38774014452486, -3.16087217690274, -2.88713787308431, ...
    -2.59862703860046, -2.12794662174492, -1.46191134014182, -0.786618430263286, ...
    -0.233793418001758, 0.238219004853046,  0.787159978221274,  1.4511770118371, ...
    2.12684960325108,   2.59753837416936,  2.88696278654447,   3.16320761104991, ...
    3.392065967562,     3.5707169673597,   3.77826162203603,   4.02691217707625, ...
    4.39663466867998,   4.89810725172969,  5.33430022501398,   5.51230092474555, ...
    5.51331215390231,   5.3377052292093,   4.91303508538535,   4.40247858922407, ...
    4.02820036525764,   3.77243608325343,  3.56396961551478,   3.38774014452844, ...
    3.1608721769931,    2.88713787308465,  2.59862703860149,   2.12794662174519, ...
    1.46191134014302,   0.786618430261735, 0.233793418002413, -0.238219004853546, ...
    -0.787159978220774, -1.45117701183599, -2.12684960325216, -2.59753837417031, ...
    -2.88696278654442,  -3.16320761104772, -3.39206596756167, -3.57071696736344, ...
    -3.77826162203366 ...
];

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
% To prevent duplicates with 0 or 360 if they already exist:
if X_wrapped(1) == 0
    X_wrapped(1) = [];
    Y_wrapped(1) = [];
end
if X_wrapped(end) == 360
    X_wrapped(end) = [];
    Y_wrapped(end) = [];
end
% --- FORCING EXCLUSIVELY PERFECT 0V BOUNDARIES ---
X_wrapped = [0, X_wrapped, 360];
Y_wrapped = [0, Y_wrapped, 0];  
% -------------------------------------------------

%% 4. Sample onto final full-revolution electrical grid
% Keeping your original grid structure (step size 1.2 degrees)
theta_elec = 0 : 1.2 : 360;  
BEMF_shape = interp1(X_wrapped, Y_wrapped, theta_elec, 'spline');

%% 5. Convert Electrical Degrees to Mechanical Degrees
pole_pairs = 3; 
theta_mech = theta_elec / pole_pairs; 

%% 6. Plot the results to verify
figure;
plot(X_orig, Y_orig, 'r-', 'MarkerIndices', 1:5:length(X_orig), 'DisplayName', 'Original Waveform (Phase 1)'); hold on;
plot(theta_elec, BEMF_shape, 'b--', 'LineWidth', 1.5, 'DisplayName', 'Phase-Shifted to 0V (Rising)');
plot(theta_mech, BEMF_shape, 'g-.', 'LineWidth', 2, 'DisplayName', 'Shifted Back-EMF in mechanical degree');
xlim([-10 370]);
grid on;
xlabel('Angle (Degrees)');
ylabel('Back-EMF (V)');
title('BDnEV(X5550)backEMF 4000rpm Phase-A Back-EMF Profile Alignment');
legend('Location', 'best');