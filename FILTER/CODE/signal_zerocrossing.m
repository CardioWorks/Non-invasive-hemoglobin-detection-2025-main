function Z_SQI = signal_zerocrossing(y)
%%yΪ�˲�������ź�
sum=0;
N = length(y);
for i=1:300
    if y(i)<0
        sum=sum+1;
    else
        sum=sum+0;
    end
end
%%������ָ��
Z_SQI = sum/N;

end