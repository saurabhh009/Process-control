function dy_dt = CSTR_Function(t, y, q)

    global V CAi rho deltaH Cp Ti 

    % Extract variables from the vector y
    CA = y(1);
    T = y(2);

    % Calculate the rate constant k(T)
    k = 2.4e15 * exp(-20000 / T); % (in 1/min)

    % Define the differential equations
    dCA_dt = (q/V) * (CAi - CA) - k * CA;
    dT_dt = (q/V) * (Ti - T) + (-deltaH * k * CA) / (rho * Cp); 

    % Return the derivatives
    dy_dt = [dCA_dt; dT_dt];
end
