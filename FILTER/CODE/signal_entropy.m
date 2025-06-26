function E_SQI = signal_entropy(x)

N = length(x);
sum = 0;
for i=1:N
    sum = sum +(x(i)^2)*log(x(i)^2);
end

E_SQI = -sum;

end