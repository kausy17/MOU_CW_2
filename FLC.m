% Step 1: Create a new Mamdani FIS
AAL_FLC = mamfis('Name','AmbientAssistedLivingFIS');

% Step 2: Add 8 Inputs with Ranges and Linguistic Terms

% 1. Temperature [0, 40]
AAL_FLC = addInput(AAL_FLC, [0 40], 'Name', 'Temperature');
AAL_FLC = addMF(AAL_FLC, 'Temperature', 'trapmf', [0 0 5 10], 'Name', 'VeryCold');
AAL_FLC = addMF(AAL_FLC, 'Temperature', 'trimf', [5 10 20], 'Name', 'Cold');
AAL_FLC = addMF(AAL_FLC, 'Temperature', 'trimf', [15 22 28], 'Name', 'Comfortable');
AAL_FLC = addMF(AAL_FLC, 'Temperature', 'trimf', [25 30 35], 'Name', 'Warm');
AAL_FLC = addMF(AAL_FLC, 'Temperature', 'trapmf', [30 35 40 40], 'Name', 'Hot');

% 2. Humidity [0, 100]
AAL_FLC = addInput(AAL_FLC, [0 100], 'Name', 'Humidity');
AAL_FLC = addMF(AAL_FLC, 'Humidity', 'trapmf', [0 0 15 30], 'Name', 'Dry');
AAL_FLC = addMF(AAL_FLC, 'Humidity', 'trimf', [25 45 60], 'Name', 'Comfortable');
AAL_FLC = addMF(AAL_FLC, 'Humidity', 'trimf', [55 70 85], 'Name', 'Humid');
AAL_FLC = addMF(AAL_FLC, 'Humidity', 'trapmf', [80 90 100 100], 'Name', 'VeryHumid');

% 3. CO2 [400, 2000]
AAL_FLC = addInput(AAL_FLC, [400 2000], 'Name', 'CO2');
AAL_FLC = addMF(AAL_FLC, 'CO2', 'trapmf', [400 400 600 800], 'Name', 'Fresh');
AAL_FLC = addMF(AAL_FLC, 'CO2', 'trimf', [700 1000 1300], 'Name', 'Moderate');
AAL_FLC = addMF(AAL_FLC, 'CO2', 'trapmf', [1200 1500 2000 2000], 'Name', 'Stuffy');

% 4. Presence [0, 1]
AAL_FLC = addInput(AAL_FLC, [0 1], 'Name', 'Presence');
AAL_FLC = addMF(AAL_FLC, 'Presence', 'trapmf', [0 0 0.2 0.4], 'Name', 'Absent');
AAL_FLC = addMF(AAL_FLC, 'Presence', 'trapmf', [0.6 0.8 1 1], 'Name', 'Present');

% 5. TimeOfDay [0, 24]
AAL_FLC = addInput(AAL_FLC, [0 24], 'Name', 'TimeOfDay');
AAL_FLC = addMF(AAL_FLC, 'TimeOfDay', 'trapmf', [0 0 3 6], 'Name', 'Night');
AAL_FLC = addMF(AAL_FLC, 'TimeOfDay', 'trimf', [5 8 11], 'Name', 'Morning');
AAL_FLC = addMF(AAL_FLC, 'TimeOfDay', 'trimf', [10 14 17], 'Name', 'Afternoon');
AAL_FLC = addMF(AAL_FLC, 'TimeOfDay', 'trapmf', [16 19 24 24], 'Name', 'Evening');

% 6. LightLevel [0, 1000]
AAL_FLC = addInput(AAL_FLC, [0 1000], 'Name', 'LightLevel');
AAL_FLC = addMF(AAL_FLC, 'LightLevel', 'trapmf', [0 0 100 200], 'Name', 'Dark');
AAL_FLC = addMF(AAL_FLC, 'LightLevel', 'trimf', [150 300 450], 'Name', 'Dim');
AAL_FLC = addMF(AAL_FLC, 'LightLevel', 'trimf', [400 600 800], 'Name', 'Moderate');
AAL_FLC = addMF(AAL_FLC, 'LightLevel', 'trapmf', [750 850 1000 1000], 'Name', 'Bright');

% 7. NoiseLevel [30, 100]
AAL_FLC = addInput(AAL_FLC, [30 100], 'Name', 'NoiseLevel');
AAL_FLC = addMF(AAL_FLC, 'NoiseLevel', 'trapmf', [30 30 40 50], 'Name', 'Quiet');
AAL_FLC = addMF(AAL_FLC, 'NoiseLevel', 'trimf', [45 60 75], 'Name', 'Moderate');
AAL_FLC = addMF(AAL_FLC, 'NoiseLevel', 'trimf', [70 80 90], 'Name', 'Noisy');
AAL_FLC = addMF(AAL_FLC, 'NoiseLevel', 'trapmf', [85 95 100 100], 'Name', 'VeryNoisy');

% 8. ActivityLevel [0, 10]
AAL_FLC = addInput(AAL_FLC, [0 10], 'Name', 'ActivityLevel');
AAL_FLC = addMF(AAL_FLC, 'ActivityLevel', 'trapmf', [0 0 1 2], 'Name', 'Inactive');
AAL_FLC = addMF(AAL_FLC, 'ActivityLevel', 'trimf', [1.5 3 4.5], 'Name', 'Low');
AAL_FLC = addMF(AAL_FLC, 'ActivityLevel', 'trimf', [4 5.5 7], 'Name', 'Moderate');
AAL_FLC = addMF(AAL_FLC, 'ActivityLevel', 'trimf', [6.5 8 9.5], 'Name', 'Active');
AAL_FLC = addMF(AAL_FLC, 'ActivityLevel', 'trapmf', [9 9.5 10 10], 'Name', 'VeryActive');

%% 1. Heater [0, 10]
AAL_FLC = addOutput(AAL_FLC, [0 10], 'Name', 'Heater');
AAL_FLC = addMF(AAL_FLC, 'Heater', 'trapmf', [0 0 1 2], 'Name', 'Off');
AAL_FLC = addMF(AAL_FLC, 'Heater', 'trimf', [1.5 3 4.5], 'Name', 'Low');
AAL_FLC = addMF(AAL_FLC, 'Heater', 'trimf', [4 5.5 7], 'Name', 'Medium');
AAL_FLC = addMF(AAL_FLC, 'Heater', 'trimf', [6.5 8 9], 'Name', 'High');
AAL_FLC = addMF(AAL_FLC, 'Heater', 'trapmf', [8.5 9.5 10 10], 'Name', 'Max');

%% 2. Fan [0, 5]
AAL_FLC = addOutput(AAL_FLC, [0 5], 'Name', 'Fan');
AAL_FLC = addMF(AAL_FLC, 'Fan', 'trapmf', [0 0 0.5 1], 'Name', 'Off');
AAL_FLC = addMF(AAL_FLC, 'Fan', 'trimf', [0.8 1.5 2.2], 'Name', 'Low');
AAL_FLC = addMF(AAL_FLC, 'Fan', 'trimf', [2 3 4], 'Name', 'Medium');
AAL_FLC = addMF(AAL_FLC, 'Fan', 'trapmf', [3.5 4.2 5 5], 'Name', 'High');

%% 3. Blinds [0, 100]
AAL_FLC = addOutput(AAL_FLC, [0 100], 'Name', 'Blinds');
AAL_FLC = addMF(AAL_FLC, 'Blinds', 'trapmf', [0 0 10 20], 'Name', 'Closed');
AAL_FLC = addMF(AAL_FLC, 'Blinds', 'trimf', [15 30 45], 'Name', 'SlightlyOpen');
AAL_FLC = addMF(AAL_FLC, 'Blinds', 'trimf', [40 50 60], 'Name', 'HalfOpen');
AAL_FLC = addMF(AAL_FLC, 'Blinds', 'trimf', [55 70 85], 'Name', 'MostlyOpen');
AAL_FLC = addMF(AAL_FLC, 'Blinds', 'trapmf', [80 90 100 100], 'Name', 'FullyOpen');

%% 4. Window [0, 100]
AAL_FLC = addOutput(AAL_FLC, [0 100], 'Name', 'Window');
AAL_FLC = addMF(AAL_FLC, 'Window', 'trapmf', [0 0 10 20], 'Name', 'Closed');
AAL_FLC = addMF(AAL_FLC, 'Window', 'trimf', [15 30 45], 'Name', 'SlightlyOpen');
AAL_FLC = addMF(AAL_FLC, 'Window', 'trimf', [40 50 60], 'Name', 'HalfOpen');
AAL_FLC = addMF(AAL_FLC, 'Window', 'trapmf', [70 90 100 100], 'Name', 'FullyOpen');

%% 5. LightsIntensity [0, 100]
AAL_FLC = addOutput(AAL_FLC, [0 100], 'Name', 'LightsIntensity');
AAL_FLC = addMF(AAL_FLC, 'LightsIntensity', 'trapmf', [0 0 5 10], 'Name', 'Off');
AAL_FLC = addMF(AAL_FLC, 'LightsIntensity', 'trimf', [8 20 32], 'Name', 'Dim');
AAL_FLC = addMF(AAL_FLC, 'LightsIntensity', 'trimf', [30 50 70], 'Name', 'Moderate');
AAL_FLC = addMF(AAL_FLC, 'LightsIntensity', 'trapmf', [65 80 100 100], 'Name', 'Bright');

%% 6. Volume [0, 10]
AAL_FLC = addOutput(AAL_FLC, [0 10], 'Name', 'Volume');
AAL_FLC = addMF(AAL_FLC, 'Volume', 'trapmf', [0 0 1 2], 'Name', 'Mute');
AAL_FLC = addMF(AAL_FLC, 'Volume', 'trimf', [1.5 3 4.5], 'Name', 'Low');
AAL_FLC = addMF(AAL_FLC, 'Volume', 'trimf', [4 5.5 7], 'Name', 'Medium');
AAL_FLC = addMF(AAL_FLC, 'Volume', 'trapmf', [6.5 8.5 10 10], 'Name', 'Loud');

%%
ruleList = [

% Temp Humid CO2 Pres TOD Light Noise Act | Heater Fan Blinds Win Light Vol | Weight Conn

% Basic Rules
 2     0     0   2    0     0     0     0     3      1     0     0    0     0     1      1;
 3     2     0   0    0     0     0     0     1      1     0     0    0     0     1      1;
 0     0     3   0    0     0     0     0     0      4     0     3    0     0     1      1;
 0     0     0   1    1     0     0     0     0      0     0     0    1     1     1      1;
 0     0     0   2    4     0     0     0     0      0     0     0    2     3     1      1;
 0     0     0   0    0     0     3     1     0      0     0     0    0     2     1      1;
 0     0     0   0    0     2     0     4     0      0     0     0    4     0     1      1;
 0     0     1   0    0     0     0     0     0      0     0     1    0     0     1      1;
 0     4     0   0    0     0     0     0     0      3     0     2    0     0     1      1;
 0     0     0   0    0     0     4     5     0      4     0     0    0     1     1      1;

% Complex Rules for Surface Plots
 5     4     3   0    0     0     0     0     0      4     0     4    0     0     1      1;
 0     0     0   2    2     1     0     0     0      0     5     0    3     0     1      1;
 0     0     0   0    3     0     2     3     0      2     0     0    0     3     1      1;
 0     0     0   1    3     4     0     0     0      0     3     0    1     0     1      1;
 4     0     2   0    0     0     0     5     0      3     0     0    0     0     1      1;
 0     0     0   2    4     0     4     0     0      0     3     0    0     2     1      1;
 1     0     0   2    1     0     0     0     5      0     0     1    0     2     1      1;
 0     1     0   0    0     2     0     2     0      1     0     0    4     0     1      1;

];

AAL_FLC = addRule(AAL_FLC, ruleList);

%%
writeFIS(AAL_FLC)
%%
fuzzyLogicDesigner('AmbientAssistedLivingFIS.fis')

%% --- SCREENSHOTS FOR INPUT MEMBERSHIP FUNCTIONS ---
inputNames = {'Temperature', 'Humidity', 'CO2', 'Presence', ...
              'TimeOfDay', 'LightLevel', 'NoiseLevel', 'ActivityLevel'};

for i = 1:length(inputNames)
    figure;
    plotmf(AAL_FLC, 'input', i);
    title([inputNames{i} ' Membership Functions']);
    saveas(gcf, ['MF_' inputNames{i} '.png']);
end

%% --- SCREENSHOTS FOR OUTPUT MEMBERSHIP FUNCTIONS ---
outputNames = {'Heater', 'Fan', 'Blinds', 'Window', 'LightsIntensity', 'Volume'};

for i = 1:length(outputNames)
    figure;
    plotmf(AAL_FLC, 'output', i);
    title([outputNames{i} ' Membership Functions']);
    saveas(gcf, ['MF_' outputNames{i} '.png']);
end

%%
% Create a folder to store surface plots
outputFolder = 'Surface_Plots';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Plot 1: Temperature vs ActivityLevel → Heater
figure('Visible','off');
gensurf(AAL_FLC, [1 8], 1);  % input indices: Temp=1, Act=8; output=1 (Heater)
title('Heater Surface: Temperature vs ActivityLevel');
saveas(gcf, fullfile(outputFolder, 'Surface_Temp_Activity_Heater.png'));
close;

% Plot 2: Humidity vs CO2 → FanSpeed
figure('Visible','off');
gensurf(AAL_FLC, [2 3], 2);  % input indices: Hum=2, CO2=3; output=2 (FanSpeed)
title('FanSpeed Surface: Humidity vs CO2');
saveas(gcf, fullfile(outputFolder, 'Surface_Humidity_CO2_FanSpeed.png'));
close;

% Plot 3: LightLevel vs Presence → LightsIntensity
figure('Visible','off');
gensurf(AAL_FLC, [6 4], 5);  % LightLevel=6, Presence=4, Lights=5
title('LightsIntensity Surface: LightLevel vs Presence');
saveas(gcf, fullfile(outputFolder, 'Surface_Light_Presence_Lights.png'));
close;

% Plot 4: NoiseLevel vs ActivityLevel → TVVolume
figure('Visible','off');
gensurf(AAL_FLC, [7 8], 6);  % Noise=7, Activity=8 → TVVolume=6
title('TVVolume Surface: NoiseLevel vs ActivityLevel');
saveas(gcf, fullfile(outputFolder, 'Surface_Noise_Activity_TVVolume.png'));
close;


%%
inputVals = [35, 85, 1800, 1, 19, 100, 90, 5];  % [Temp, Humid, CO2, Pres, TOD, Light, Noise, Activity]
output = evalfis(AAL_FLC, inputVals)
