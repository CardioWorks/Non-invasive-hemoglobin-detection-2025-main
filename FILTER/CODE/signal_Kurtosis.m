function K_SQI = signal_Kurtosis(x)

N = length(x);
x_mean = mean(x);
x_delt = std(x);

sum = 0;
for i=1:N
    sum = sum + (x(i)-(x_mean/x_delt))^4;
end

K_SQI = sum/N;

end