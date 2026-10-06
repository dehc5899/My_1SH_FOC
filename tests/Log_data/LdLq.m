% 1. Get current script directory
scriptDir = fileparts(mfilename('fullpath'));

% 2. Specify CSV filename
filename = fullfile(scriptDir, 'IdIq.csv'); 

% 3. Read table skipping 9 header lines
opts = detectImportOptions(filename, 'NumHeaderLines', 9, 'FileType', 'text');
data = readtable(filename, opts);

% 4. Extract currents using raw table order (preserve sample sequence)
% Assumes Column 2 is Iq_ref and Column 3 is Id_ref
i_q_ref = data{:, 2};
i_d_ref = data{:, 3};

% 5. Create sample index array (1, 2, 3, ... N)
sample_number = (1:height(data))';

% 6. Plot Id and Iq against Sample Number
figure('Name', 'Id and Iq Reference Data', 'NumberTitle', 'off');
plot(sample_number, -i_q_ref, 'b-', 'LineWidth', 1.2, 'DisplayName', 'I_{Q\_REF}');
%hold on;
%plot(sample_number, i_d_ref, 'r-', 'LineWidth', 1.2, 'DisplayName', 'I_{D\_REF}');
hold off;

xlabel('Sample Number');
ylabel('Current (A)');
ylim([-16 16]); % Force Y-axis limits from -16 A to 16 A
title('FOC Reference Currents (I_d and I_q)');
legend('Location', 'best');
grid on;