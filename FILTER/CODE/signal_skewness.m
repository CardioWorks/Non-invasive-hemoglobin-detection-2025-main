function S_SQI = signal_skewness(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        signal_skewness.m
%Method: S_SQI-Skewness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Notes:
%x:the normalized data (-1---1)
%S_SQI: Skewness SQI value

%% 0--Get the normalized data (-1---1)
x;
%% 1--S_SQI Formula: In Elgendi's SQI Paper

N = length(x);
x_mean = mean(x);
x_delt = std(x);

sum = 0;
for i=1:N
    sum = sum + (x(i)-(x_mean/x_delt))^3;
end

S_SQI = sum/N;

end
