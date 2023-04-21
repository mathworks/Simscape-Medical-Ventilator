function plotResults(modelName)
%PLOTRESULTS

if ~exist('modelName','var')
    modelName = 'medicalVentilatorSystemModel';
end

dialInputName = [modelName '/Pressure-targeted ventilation controller/Constant'];
dialInputValues = 1.01:4.01; % make slightly higher to avoid type conversion issues
lungParams = struct();
lungParams.E_respiratory = [18 17 16 15]; % decrease lung stiffness (==increase lung elasticity)
lungParams.FRC = [1.5 1.75 2 2.25]; % increase resting lung size

open_system(modelName);
for setPointIdx = 1:length(dialInputValues)
    thisDialInputValue = dialInputValues(setPointIdx);
    set_param(dialInputName,'Value',num2str(thisDialInputValue));
    assignin('base','FRC', lungParams.FRC(setPointIdx));
    assignin('base','E_respiratory', lungParams.E_respiratory(setPointIdx));
    sim(modelName,30);
    flowRate = getTimeSeries(logsout,'flowRate');
    pLung = getTimeSeries(logsout,'pProximal');
    pThreshMin = getTimeSeries(logsout,'pThreshMin');
    pThreshMax = getTimeSeries(logsout,'pThreshMax');
    vLung = getTimeSeries(logsout,'vLung');
    inValve = getTimeSeries(logsout,'inValveFrac');
    exValve = getTimeSeries(logsout,'exValve');
    targetDialSetting = getTimeSeries(logsout,'switch_pos');
    targetDialSetting = targetDialSetting.Data(end);
    targetRespiratoryRate = getTimeSeries(logsout,'respRate');
    targetRespiratoryRate = targetRespiratoryRate.Data(end);
    targetIeRatio = getTimeSeries(logsout,'ieRatio');
    targetIeRatio = targetIeRatio.Data(end);
    
    % Create figure
    figure('Position',[200,200,600,900]);
    % Plot and use flow rate to calcuate metrics
    subplot(4,1,1)
    plot(flowRate);
    grid('on');
    hold('on');
    xlabel('');
    ylabel('Flow (L/min)');
    
    subplot(4,1,2);
    plot(pLung);
    hold('on');
    grid('on');
    plot(pThreshMin);
    plot(pThreshMax);
    xlabel('');
    ylabel('Pressure (cm H2O)');
    
    subplot(4,1,3);
    plot(vLung);
    grid('on');
    title('');
    xlabel('');
    ylabel('Lung volume (L)');
    
    subplot(4,1,4);
    lineInhale = plot(inValve);
    grid('on');
    hold('on');
    lineExhale = plot(exValve);
    title('');
    ylabel('Valve demands (fraction)');
    xlabel('Time, s');

    % Calculate metrics - using valve demands demonstrates that the
    % controller is working as instructed, but may need to consider metrics
    % on other traces.
    steadyStateDuration = 5; % Seconds
    inhaleData = getPeaksAndTroughs(inValve,steadyStateDuration);
    exhaleData = getPeaksAndTroughs(exValve,min(inhaleData.PeakTime));
    metrics = getMetrics(inhaleData,exhaleData);
    
    % Plot
    plot(inhaleData.PeakTime,inhaleData.PeakValue,'o','Color',lineInhale.Color);
    plot(exhaleData.PeakTime,exhaleData.PeakValue,'o','Color',lineExhale.Color);
    
    % Label the figure
    subplot(4,1,1);
    titleline1 = ['Dial voltage setting: ' num2str(thisDialInputValue) ' (Breakpoint number:' num2str(targetDialSetting) ')'];
    titleline2 = ['Valve Respiratory Rate: ' num2str(metrics.respiratoryRate) ' (Target:' num2str(targetRespiratoryRate) ')'];
    titleline3 = ['Valve IE Ratio: ' num2str(metrics.ieRatio) ' (Target:' num2str(targetIeRatio) ')'];
    title(sprintf('%s\n%s\n%s',titleline1,titleline2,titleline3));
end
end

function timeseries = getTimeSeries(dataset,name)
% GETTIMESERIES
dataset = dataset.find('Name',name);
timeseries = dataset{1}.Values;
end

function output = getPeaksAndTroughs(timeseries,steadyStateDuration)

thesholdMagnitude = (max(timeseries.Data)+min(timeseries.Data))/2;

[peakValue,peakIdx] = findPeaks(timeseries.Data);
peakTime = timeseries.Time(peakIdx);
% Signals might be more noisy, use suitable threshold
peakIdx = peakValue>thesholdMagnitude;
peakTime = peakTime(peakIdx);
peakValue = peakValue(peakIdx);
% Find peaks after steady-state
peakValue = peakValue(peakTime>steadyStateDuration);
peakTime = peakTime(peakTime>steadyStateDuration);
% Find troughs
[~,troughIdx] = findPeaks(-timeseries.Data);
troughTime = timeseries.Time(troughIdx);
troughValue = timeseries.Data(troughIdx);
% Now down select to those immediately before peaks
% Get min immediately preceeding
troughBelowTime = nan(size(peakTime));
troughBelowValue = nan(size(peakTime));
for peakIdx = 1:length(peakTime)
    thisPeakAboveTime = peakTime(peakIdx);
    idx = find(troughTime<thisPeakAboveTime,1,'last');
    if ~isempty(idx)
        troughBelowTime(peakIdx,1) = troughTime(idx);
        troughBelowValue(peakIdx,1) = troughValue(idx);
    end
end
% Remove any nans
troughTime = troughBelowTime(~isnan(troughBelowTime));
troughValue = troughBelowValue(~isnan(troughBelowTime));
% Remove any peaks that occur outside of troughs
peakIdx = peakTime>min(troughTime) & peakTime<max(troughTime);
peakTime = peakTime(peakIdx);
peakValue = peakValue(peakIdx);
% Create metrics structure
output.PeakTime = peakTime;
output.PeakValue = peakValue;
output.TroughTime = troughTime;
output.TroughValue = troughValue;
end

function metrics = getMetrics(inhaleData,exhaleData)
% Calculate Respiratory Rate and IERatio
respiratoryPeriod = diff(inhaleData.PeakTime);
respiratoryRate = 60/mean(respiratoryPeriod);
minLength = min(length(inhaleData.PeakTime),length(exhaleData.PeakTime));
inhaleDuration = exhaleData.PeakTime(1:minLength)-inhaleData.PeakTime(1:minLength);
ieRatio = mean(inhaleDuration(1:length(respiratoryPeriod))./respiratoryPeriod);
metrics.respiratoryRate = respiratoryRate;
metrics.ieRatio = ieRatio;
end

function [peaks, peakIdx] = findPeaks( data )
% FINDPEAKS

% Subsequent concatenation code supports only column vectors. If data is a
% row vector, MATLAB will automatically convert it to a column vector.
arguments
    data (:,1) double
end

% Find only first peak value in order to handle repeated peak values
beforePeakIdx = data(1:end-2)<data(2:end-1);
afterPeakIdx = data(2:end-1)>=data(3:end);
% Pad the logical array to index into data
peakIdx = [false; beforePeakIdx; false] & [false; afterPeakIdx; false];
% Return just the required values
peaks = data( peakIdx );
end