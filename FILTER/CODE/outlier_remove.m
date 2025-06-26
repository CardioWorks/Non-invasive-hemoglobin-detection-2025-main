function [remove_data] = outlier_remove(raw_data)
%%
    first_deri = ppg_derivative(raw_data);
    for i = length(first_deri):-1:1
        if abs(first_deri(i)) >= 10000
            raw_data(i-1:i+1) = [];
        end
    end
    remove_data = raw_data;
end