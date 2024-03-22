function plotCondensation(simlog)
% This plot shows the accumulation of condensed water in the expiratory
% tube, which should be drained periodically. The water comes from the
% humidifier and the patient's respiration.
% Get simulation results

t = simlog.Expiratory.Expiratory_Tube.W.series.time;
W = simlog.Expiratory.Expiratory_Tube.W.series.values('kg/s');

% Compute accumulation of condensate
M = cumtrapz(t, W);
rho = 998.2; % kg/m^3
V = M/rho*1e6; % mL

% Plot results
plot(t, V, 'LineWidth', 1)
grid on
xlabel('Time (s)')
ylabel('Volume of Water (mL)')
title('Condensate Accumulation in Expiratory Tube')

end
