function [press,flow,v_lung] = convrtDatabase(out)

press = Simulink.SimulationData.Dataset(out.logsout{1}.Values);
flow = Simulink.SimulationData.Dataset(out.logsout{4}.Values);
v_lung = Simulink.SimulationData.Dataset(out.logsout{5}.Values);

save("Data\SysParameterSet","press","flow","v_lung");
end
