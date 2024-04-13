clc
clear all

load system_parameters.mat

xo(1) = optimal_x(1); % Process Gain, Kp
xo(2) = optimal_x(2); % Time Constant, tou

load result_stepchange_Q.mat % This loads the step response data

% validation of the process model (with the trained data set1)

Q_in = Manipulated_input(501:900,1); % Change in the manipulated input (Q (Final-Initial)

T_Plant_Data1 = T_nonLinear_profile_M1(501:900,1); % simulated temperature data

t_data1 = Time_profile(501:900,1); % time data

T_ss1 = T_Plant_Data1(1,1); % Steady state of the system

% step response model in time domain
for i = 1:1:length(t_data1)
    T_model_response1(i,1) = T_ss1 + xo(1)*(0.5347)*(1-exp(-(t_data1(i)-501)./xo(2)));
end

figure;

plot(1:size(T_Plant_Data1), T_Plant_Data1,'b', 1:size(T_Plant_Data1), T_model_response1,'r'), legend('Non-Linear Response','Regression Model Response')
title(['Model Validation - Training Set'])



% validation of the process model (with the trained data set2)

Q_in = Manipulated_input(1201:1700,1); % Change in the manipulated input (Q (Final-Initial)

T_Plant_Data2 = T_nonLinear_profile_M1(1201:1700,1); % simulated temperature data

t_data2 = Time_profile(1201:1700,1); % time data

T_ss2 = T_Plant_Data2(1,1); % Steady state of the system

% step response model in time domain
for i = 1:1:length(t_data2)
    T_model_response2(i,1) = T_ss2 + xo(1)*(1.6042)*(1-exp(-(t_data2(i)-1201)./xo(2)));
end

figure;

plot(1:size(T_Plant_Data2), T_Plant_Data2,'b', 1:size(T_Plant_Data2), T_model_response2,'r'), legend('Non-Linear Response','Regression Model Response')
title(['Model Validation - Testing Set'])
