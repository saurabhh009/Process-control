function [fun_val] = optimfunc(xo)

    load result_stepchange_Q.mat % This loads the step response data

    M = 0.5347; % Change in the manipulated input (Q) (Final-Initial)

    T_Plant_Data = T_nonLinear_profile_M1(501:900,1); % simulated temperature data

    t_data = Time_profile(501:900,1); % time data

    T_ss = T_Plant_Data(1,1);

    % step response model in time domain
    T_model_response = T_ss + xo(1)*M*(1-exp(-(t_data-500)./xo(2)));

    err = T_Plant_Data - T_model_response;

    fun_val = sum(err.^2);

end

