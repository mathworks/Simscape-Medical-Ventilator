% This example may not represent an implementable design, and no validation
% has been done. The purpose of the example is to provide a starting point
% for designers working on ventilators showing how interfacing between the
% real-time controller and the system model can be done, how a real-time
% controller can be defined in Simulink® and Stateflow™ and how a full
% system model can be used to support the design process.

inhaleValveMax = Simulink.Parameter;
inhaleValveMax.Value = 0.4;
inhaleValveMax.CoderInfo.StorageClass = 'Auto';
inhaleValveMax.Description = 'Maximum inhale valve opening command';
inhaleValveMax.DataType = 'auto';
inhaleValveMax.Min = [];
inhaleValveMax.Max = [];
inhaleValveMax.DocUnits = '';

deltaFrac = Simulink.Parameter;
deltaFrac.Value = 0.05;
deltaFrac.CoderInfo.StorageClass = 'Auto';
deltaFrac.Description = 'Proportion of valve travel by which valve demand is modified every time a max or min pressure limit is exceeded';
deltaFrac.DataType = 'auto';
deltaFrac.Min = [];
deltaFrac.Max = [];
deltaFrac.DocUnits = '';

deltaDriftClosed = Simulink.Parameter;
deltaDriftClosed.Value = 0.1; 
deltaDriftClosed.CoderInfo.StorageClass = 'Auto';
deltaDriftClosed.Description = 'Proportion of valve travel by which minimum valve position drops each breathing cycle so as to drift minimum pressure down to the PEEP value';
deltaDriftClosed.DataType = 'auto';
deltaDriftClosed.Min = [];
deltaDriftClosed.Max = [];
deltaDriftClosed.DocUnits = '';      
                   
IEratioSetting = Simulink.Parameter;
IEratioSetting.Value = [0.75 0.75 0.5 0.33 0.25 0.25];
IEratioSetting.CoderInfo.StorageClass = 'Auto';
IEratioSetting.Description = '';
IEratioSetting.DataType = 'auto';
IEratioSetting.Min = [];
IEratioSetting.Max = [];
IEratioSetting.DocUnits = '';

dialVolts = Simulink.Parameter;
dialVolts.Value = [0.5 1 2 3 4 4.5];
dialVolts.CoderInfo.StorageClass = 'Auto';
dialVolts.Description = '';
dialVolts.DataType = 'auto';
dialVolts.Min = [];
dialVolts.Max = [];
dialVolts.DocUnits = '';

modeBPs = Simulink.Parameter;
modeBPs.Value = [1 2 3 4 5 6];
modeBPs.CoderInfo.StorageClass = 'Auto';
modeBPs.Description = '';
modeBPs.DataType = 'auto';
modeBPs.Min = [];
modeBPs.Max = [];
modeBPs.DocUnits = '';

pressureEng = Simulink.Parameter;
pressureEng.Value = [0 50];
pressureEng.CoderInfo.StorageClass = 'Auto';
pressureEng.Description = '';
pressureEng.DataType = 'auto';
pressureEng.Min = [];
pressureEng.Max = [];
pressureEng.DocUnits = '';

pressureDynamicRangeSetting = Simulink.Parameter;
pressureDynamicRangeSetting.Value = [8 8 11 12 13 13];
pressureDynamicRangeSetting.CoderInfo.StorageClass = 'Auto';
pressureDynamicRangeSetting.Description = 'Pressure swing between minimum and maximum values';
pressureDynamicRangeSetting.DataType = 'auto';
pressureDynamicRangeSetting.Min = [];
pressureDynamicRangeSetting.Max = [];
pressureDynamicRangeSetting.DocUnits = '';

pressureThresholdMinSetting = Simulink.Parameter;
pressureThresholdMinSetting.Value = [5 5 10 10 10 10];
pressureThresholdMinSetting.CoderInfo.StorageClass = 'Auto';
pressureThresholdMinSetting.Description = 'Minimum pressure (PEEP value)';
pressureThresholdMinSetting.DataType = 'auto';
pressureThresholdMinSetting.Min = [];
pressureThresholdMinSetting.Max = [];
pressureThresholdMinSetting.DocUnits = '';

pressureVolts = Simulink.Parameter;
pressureVolts.Value = [0.5 4.5];
pressureVolts.CoderInfo.StorageClass = 'Auto';
pressureVolts.Description = '';
pressureVolts.DataType = 'auto';
pressureVolts.Min = [];
pressureVolts.Max = [];
pressureVolts.DocUnits = '';

respRateSetting = Simulink.Parameter;
respRateSetting.Value = [18 18 17 16 15 15];
respRateSetting.CoderInfo.StorageClass = 'Auto';
respRateSetting.Description = '';
respRateSetting.DataType = 'auto';
respRateSetting.Min = [];
respRateSetting.Max = [];
respRateSetting.DocUnits = '';
