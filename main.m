clear all
clc

global V CAi rho deltaH Cp Ti q

q = 2.6736; % in (ft3/min) heat input(Manipulated variable)
V = 133.6810; % (in ft3)
CAi = 0.8; % (in mol/𝑓𝑡3)
rho = 52; % (in lb/𝑓𝑡3)
deltaH = -500; % (in KJ/mol)
Cp = 0.8440; % in (KJ/lb.deg F) 
Ti = 609.67; % (in Rankine)

SetGraphics;

% (identify the parameters, manipulated inputs, disturbance variables, and controlled variables.)

% Assumptions :-
% 1. The system is well-mixed, and there are no spatial variations.
% 2. The reactor operates adiabatically, meaning no heat exchange with the surroundings.

% Parameters - V, rho, Cp, ΔH
% Controlled Variable - Temperature
% Manipulated Variable - Inlet Flow Rate (q)
% Disturbance Variable - CAi
% State Variable - CA

% ---------------------------------------------------------------------------------------------------------


% TASK 1: (Find the steady state of the non-linear system)

% Initialize arrays to store the profiles
CA_profile = zeros(500, 1);
T_profile = zeros(500, 1);
Time_profile = zeros(500, 1);

T_initial = 536.40;  % (Rankine) Initial guess(Room temp.)
CA_initial = 0.8;      % Initial guess of concentration

y0 = [CA_initial, T_initial]; % Initial Guess Vector
tSpan = [0 1]; % Time span

for i=1:2000
    [t, y] = ode45(@CSTR_Function, tSpan, y0, [], q);
    CA_profile(i) = y(end, 1);
    T_profile(i) = y(end, 2);
    Time_profile(i) = i;

    % Update initial conditions for the next iteration
    y0 = [CA_profile(i), T_profile(i)];
end

% Steady State Values
T_ss = T_profile(end);
fprintf('Steady State Temperature,T_ss: %f\n\n', T_ss);
CA_ss = CA_profile(end);
fprintf('Steady State Concentration, CA_ss: %f\n\n', CA_ss);

%Plot the Temperature & Concentration profiles
figure;
plot(Time_profile(:), T_profile(:), 'b')
xlabel('Time(min.)'),ylabel('Temperature (°R)');
title('Steady State: Temperature vs. Time');

figure;
plot(Time_profile(:), CA_profile(:), 'r')
xlabel('Time (min.)'),ylabel('Concentration (mol/ft3)');
title('Steady State: Concentration of A vs. Time');


% Noise Generation

for i=1:2000
    wk(i) = 0.1*randn;
end

% To obtain the step response for step change in the manipulated variable
T_initial_M = T_ss;
CA_initial_M = CA_ss;

M1 = 2.6736*0.20; % (10 % change in MV)
Manipulated_input = zeros(500, 1);

for i = 1:2000
    if i<500
        q(i) = 2.6736;
        Manipulated_input(i) = 2.6736;
    elseif i>=500 && i<=1200
        q(i) = 2.6736 + M1 + wk(i);
        Manipulated_input(i) = 2.6736 + M1 + wk(i);
    else
        q(i) = 2.6736 - 2*M1 + wk(i);
        Manipulated_input(i) = 2.6736 - 2*M1 + wk(i);
    end
end

for i=1:2000
    % Non-linear Model Response
    [t, y] = ode45(@CSTR_Function, tSpan, [CA_initial_M, T_initial_M], [], q(i));
    T_nonLinear_profile_M1(i,1) = y(end, 2);
    Time_profile(i) = i;
            
    CA_initial_M = y(end, 1);
    T_initial_M = y(end, 2);
end

figure;
plot(Time_profile(:),q(:),'b'), xlabel('Time'), ylabel('Manipulated variable (Q)')
title(['Step Change in Manipulated Input, M = ' num2str((M1/2.6736)*100) '%']);

figure;
plot(Time_profile(:), T_nonLinear_profile_M1, 'r'),xlabel('Time(min.)'),ylabel('Temperature (°R)');
title(['Non-Linear Model Response for Step Change of M = ' num2str((M1/2.6736)*100) '%']);

save result_stepchange_Q



        




