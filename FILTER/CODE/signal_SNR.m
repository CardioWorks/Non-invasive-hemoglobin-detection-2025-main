function N_SQI = signal_SNR(x,y)
%%x为原始信号，y为滤波后的信号。
y_abs=abs(y);
x_abs=abs(x);
x_delt = std(x_abs);
y_delt = std(y_abs);
N_SQI=(y_delt)^2/(x_delt)^2;

end