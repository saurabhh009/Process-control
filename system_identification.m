% Task 1: To identify first order transfer function model using regression techniques
clear all
clc
% Task 1: To identify first order transfer function model using regression technique

Up_Bound = [1000 5000]; % This vector defines upper bounds on x (x corresponds to Process Gain and Time constant)

Lo_Bound = [-500 400]; % This vector defines lower bounds on x

x_initial_guess = [1 400]; % This vector defines initial guess solution (some meaningful arbitrary value)

options = optimset('Display','iter','TolX',10^-10,'TolFun',10^-10);

[optimal_x,fval,exitflag] = fmincon(@optimfunc, x_initial_guess, [], [], [], [],Lo_Bound,Up_Bound,[],options);

optimal_x % displays the optimal values of x after regression

fprintf('Process Gain, Kp: %f\n\n', optimal_x(1));
fprintf('Time Constant, tou: %f\n\n', optimal_x(2));

save system_parameters
