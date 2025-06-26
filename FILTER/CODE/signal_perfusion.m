function P_SQI = signal_perfusion(y,x)
%%y为滤波过后的信号，x为原始的信号
x_mean = mean(x); 
x_abs=abs(x_mean);           %统计平均值的绝对值
y_max=max(y);
y_min=min(y);
%%灌注指数
P_SQI = ((y_max-y_min)/x_abs)*100;

end