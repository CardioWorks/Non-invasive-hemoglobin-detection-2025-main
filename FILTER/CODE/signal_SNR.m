function N_SQI = signal_SNR(x,y)
%%xΪԭʼ�źţ�yΪ�˲�����źš�
y_abs=abs(y);
x_abs=abs(x);
x_delt = std(x_abs);
y_delt = std(y_abs);
N_SQI=(y_delt)^2/(x_delt)^2;

end