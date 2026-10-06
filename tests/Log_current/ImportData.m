clc;
clear;
close all;
% Define the subfolder path
% Gets directory of ImportData.m (Log_current)
scriptDir = fileparts(mfilename('fullpath')); 
% Points to the '200-360' subfolder inside 'Log_current'
folderPath = fullfile(scriptDir, '100-100');
% List of CSV files
files = {
    'C1Trace00000.csv'
    'C2Trace00000.csv'
    'C3Trace00000.csv'
};

numFiles = length(files);

% figure;
% hold on;

for k = 1:numFiles
    % Combine folder and filename correctly
    fullFileName = fullfile(folderPath, files{k});
    fprintf('Reading file: %s\n', fullFileName);
    fid = fopen(fullFileName,'r');

    % Skip header until waveform data
    line = '';
    while ischar(line)
        line = fgetl(fid);
        if contains(line,'Time,Ampl')
            break;
        end
    end

    % Read numeric data
    data = textscan(fid,'%f %f','Delimiter',',');
    fclose(fid);

    % Extract time and amplitude
    if k<=3
        time{k} = data{1};
        ampl{k} = data{2};
    else
        time{k} = data{1};
        ampl{k} = data{2}/100;
    end

    % Plot
    % plot(time{k}, ampl{k}, 'LineWidth',1, 'DisplayName', files{k});

end
%%....for simulink.....
% time_vector = cell2mat(time);
% time_shifted = time_vector - time_vector(1);
% ampl_vector = cell2mat(ampl);
% 
% sim_data = [time_shifted, ampl_vector];
% plot_data = [sim_data(:,1), sim_data(:,5)];

%%....end...........
figure
grid on
% subplot(2,1,1)
plot(time{1}, ampl{1}, 'LineWidth',1.2, 'DisplayName', files{1});hold on;
plot(time{2}, ampl{2}, 'LineWidth',1.2, 'DisplayName', files{2});
plot(time{3}, ampl{3}, 'LineWidth',1.2, 'DisplayName', files{3});
% plot(time{4}, ampl{4}, 'LineWidth',1.2,'Color', [0, 0, 1, 0.5],  'DisplayName', files{4});
xlabel('Time (s)')
ylabel('Amplitude (I)')
title(['Current Waveforms:           ',folderPath], 'Interpreter', 'none');
legend show
% subplot(2,1,2)
% figure
% grid on
% plot(time{4}, ampl{4}, 'LineWidth',1.2, 'DisplayName', files{4});
% xlabel('Time (s)')
% ylabel('Amplitude (V/100)')
% title(['Voltage Waveforms:           ',folderPath], 'Interpreter', 'none');
% legend show
% hold off


%% --- Current Plot ---
windowSize = 50; % Adjust this value to control smoothness

figure
grid on
hold on;
for i = 1:3
    % 1. Calculate smoothed data
    smoothed_ampl = smoothdata(ampl{i}, 'movmean', windowSize);


    % 2. Plot Raw Data (using a lighter color or transparency)
    % pRaw = plot(time{i}, ampl{i},'Color',[0.7 0.7 0.7 0.2], 'LineWidth', 0.5);
    % 3. Plot Smoothed Data (solid and thicker)
    plot(time{i}, smoothed_ampl, 'LineWidth', 1.5,'DisplayName', [files{i} ' (Smooth)']);
end
    iu_rms = rms(ampl{1});    % Built-in RMS function
    iu_peak = max(abs(ampl{1})); % Peak (Magnitude)
    iv_rms = rms(ampl{2});    % Built-in RMS function
    iv_peak = max(abs(ampl{2})); % Peak (Magnitude)
    iw_rms = rms(ampl{3});    % Built-in RMS function
    iw_peak = max(abs(ampl{3})); % Peak (Magnitude)
    stats_str_u = {sprintf('CurrentRMS C1: %.2f A', iu_rms), ...
             sprintf('CurrentPeak C1: %.2f A', iu_peak)};
    stats_str_v = {sprintf('CurrentRMS C2: %.2f A', iv_rms), ...
             sprintf('CurrentPeak C2: %.2f A', iv_peak)};
    stats_str_w = {sprintf('CurrentRMS C3: %.2f A', iw_rms), ...
             sprintf('CurrentPeak C3: %.2f A', iw_peak)};
    annotation('textbox', [0.78, 0.21, 0.2, 0.1], 'String', stats_str_u, 'FitBoxToText', 'on');
    annotation('textbox', [0.78, 0.15, 0.2, 0.1], 'String', stats_str_v, 'FitBoxToText', 'on');
    annotation('textbox', [0.78, 0.09, 0.2, 0.1], 'String', stats_str_w, 'FitBoxToText', 'on');
xlabel('Time (s)')
ax = figure(2).CurrentAxes;
ax.XTick = 0:0.007:0.6; % ticks every 7 ms instead of default
ylabel('Amplitude (I)')
title(['Current Waveforms : ', folderPath], 'Interpreter', 'none');
legend('show')
%% --- Voltage Plot ---
% figure
% grid on
% hold on
% smoothed_v = smoothdata(ampl{4}, 'movmean', windowSize);
% 
% v_rms = rms(ampl{4});
% v_peak = max(abs(ampl{4}));
% 
% % Plot Raw Voltage
% plot(time{4}, ampl{4}, 'Color', [0.7 0.7 0.7 0.2], 'DisplayName', 'Raw Voltage');
% % Plot Smooth Voltage
% plot(time{4}, smoothed_v, 'r', 'LineWidth', 1.5, 'DisplayName', 'Smoothed Voltage');
% % Add a text box for the Voltage stats
% stats_str = {sprintf('Voltage RMS: %.2f V', v_rms), ...
%              sprintf('Voltage Peak: %.2f V', v_peak)};
% annotation('textbox', [0.78, 0.09, 0.2, 0.1], 'String', stats_str, 'FitBoxToText', 'on', 'BackgroundColor', 'white');
% xlabel('Time (s)')
% ylabel('Amplitude (V/100)')
% title(['Voltage Waveforms(Raw vs Smooth): ', folderPath], 'Interpreter', 'none');
% legend show


%% --- Current & Voltage Plot ---
figure
grid on
hold on
    % 1. Calculate smoothed data
for i = 1:3
    % 1. Calculate smoothed data
    smoothed_ampl = smoothdata(ampl{i}, 'movmean', windowSize);

    % 2. Plot Raw Data (using a lighter color or transparency)
    plot(time{i}, ampl{i},'Color',[0.7 0.7 0.7 0.2], 'LineWidth', 0.5);
    % 3. Plot Smoothed Data (solid and thicker)
    plot(time{i}, smoothed_ampl, 'LineWidth', 1.5,'DisplayName', [files{i} ' (Smooth)']);
end
% Plot Smooth Voltage
% plot(time{4}, smoothed_v, 'r', 'LineWidth', 1.5, 'DisplayName', 'Smoothed Voltage');
% xlabel('Time (s)')
% ylabel('Amplitude (V/100)')
% title(['Zero Crossing: ', folderPath], 'Interpreter', 'none');
% legend show


%%----power calculation
% 1. Calculate instantaneous power

% smoothed_current = smoothdata(ampl{1}, 'movmean', windowSize);
% smoothed_voltage = smoothdata(ampl{4}, 'movmean', windowSize);
% P_instantaneous_u =(ampl{4}*100) .* ampl{1}; % V .* I; 
% % 2. Calculate average real power
% P_average_u = mean(P_instantaneous_u);
% P_average_line = ones(size(P_instantaneous_u)) * P_average_u;
% figure
% grid on;
% plot(time{4}, P_instantaneous_u,'b', 'DisplayName', 'Instantaneous Power');hold on;
% plot(time{4}, P_average_line, 'r--', 'LineWidth', 2, 'DisplayName', 'Mean Power'); % Red dashed line
% % plot(time{4}, P_average_u, 'r', 'LineWidth', 1.5, 'DisplayName', 'U-Average power');
% title('Instantaneous Power Consumption (W)');
% xlabel('Time (s)');
% ylabel('Power (W)');
% legend('show')
% hold off;