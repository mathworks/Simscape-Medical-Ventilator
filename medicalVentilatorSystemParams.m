% This example may not represent an implementable design, and no validation
% has been done. The purpose of the example is to provide a starting point
% for designers working on ventilators showing how interfacing between the
% real-time controller and the system model can be done, how a real-time
% controller can be defined in Simulink® and Stateflow™ and how a full
% system model can be used to support the design process.

T_room = 20; % degC
RH_room = 0.1;
T_humidifier = 40; % degC
T_body = 37; % degC

L_tube = 1; % m
D_tube = 0.015; % m
L_trachea = 0.15; % m
D_trachea = 0.015; % m

FRC = 2; % L
E_respiratory = 16; % cmH2O/L
R_respiratory = 2; % cmH2O/(L/s)
P_muscle = 0; % cmH2O

% Conversion factors
cmH2O_to_Pa = 98.0665;
L_to_m3 = 1e-3;