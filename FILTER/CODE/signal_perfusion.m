function P_SQI = signal_perfusion(y,x)
%%yΪ�˲�������źţ�xΪԭʼ���ź�
x_mean = mean(x); 
x_abs=abs(x_mean);           %ͳ��ƽ��ֵ�ľ���ֵ
y_max=max(y);
y_min=min(y);
%%��עָ��
P_SQI = ((y_max-y_min)/x_abs)*100;

end