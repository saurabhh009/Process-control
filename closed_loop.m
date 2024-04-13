clear all
clc
SetGraphics

load system_parameters.mat
load result_stepchange_Q.mat

Kp = optimal_x(1); % Process gain
Tau_P = optimal_x(2); % Time constant

Tau_cl = Tau_P/2;
Tau_D = 0;
Q_ss = 2.6736;

sample_t = 1;

T_initial2 = T_ss;

% Input for selection of servo (setpoint change) or regulatory problem (disturbance rejection)
Choice1 = input(' if choice is regulatory (enter 1), choice is servo problem (enter 2)');

% Input for selection of the controller
Choice2 = input('what is the choice of controller, if P (enter1), PI (enter other than number 1)');

y_sp(1,1) = T_initial2; % For initial time instant
Q(1)=2.6736;
T_initial2 = T_ss; % Initial temperature
q=q';
for i=1:2000
    Q_vector(i,1) = Q;
    [t, y1] = ode45(@CSTR_Function, [0 1], [CA_initial_M, T_initial2],[], Q);
    T_step_profile(i,1) = y1(end,2);
    CA_initial_M = y1(end, 1);
    T_initial2 = y1(end,2);
    Time_profile(i) = i;

       y_m = T_initial2;

    % Update initial conditions for the next iteration

    % Measurement of temperature at every 1 second
    % Controller settings calculations obtained through direct synthesis method
    K_c = (1/Kp)*(Tau_P/(Tau_cl+Tau_D)); % Proportional gain
    % K_c = K_c;
    Tau_I = Tau_P; % Integraltime constant

    if Choice1 == 1
        % Disturbance is introduced into the system
        if i<= 500
            CAi = 0.8; % Inlet flowrate at initial time instant (Disturbance variable constant)
            y_sp(i,1) = y_sp(1,1); % system is at initial setpoint (i.e. at steady state)
        else
            CAi = 1.5; % Inlet flowrate at initial time instant (Disturbance variable constant)
            y_sp(i,1) = y_sp(1,1); % system is at initial setpoint (i.e.at steady state)
        end
    else
        % User specified setpoint changes
        if i <= 100
            y_sp(i,1) = T_initial2; % system is at initial steady state
        elseif i> 100 && i <= 1000
            y_sp(i,1) = T_ss+ 0.02*T_ss; % positivesetpoint change of % from steady state value
        elseif i> 1000 && i <= 1500
            y_sp(i,1) = y_sp(1000,1)- 0.02* y_sp(1000,1); % positive setpoint change of % from steady state value
        elseif i> 1500 && i <= 2000
            y_sp(i,1) = y_sp(1500,1)+ 0.05*y_sp(1500,1); % positive setpoint change of % from steady state value
        end
    end
    Q(i) = y_sp(i,1);
        if Choice2 == 1
        % % % Input signal calculation through proportional controller
        error(i,1) = y_sp(i,1) - y_m;
        Q = Q_ss + K_c*error(i,1);
    else
        % Input signal calculation through discrete proportionalintegral controller
        error(i,1) = y_sp(i,1) - y_m;

        Q = Q_ss + K_c*( (error(i,1)) + (sample_t/Tau_I)*sum((error)));

    end
end

figure(3)
subplot(2,1,1), plot(Time_profile(:,1),T_step_profile(:,1),'b',Time_profile(:,1),y_sp(:,1),'r'), xlabel('Time'),
ylabel('Temperature'), legend('Controlled variable','Setpoint variable')

subplot(2,1,2), plot(Time_profile(:,1),Q_vector(:,1),'b'), xlabel('Time'), ylabel('Manipulated variable (Q)')

save result_closed_loop_Controller
