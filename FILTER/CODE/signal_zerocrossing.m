function Z_SQI = signal_zerocrossing(y)
%%y为滤波过后的信号
sum=0;
N = length(y);
for i=1:300
    if y(i)<0
        sum=sum+1;
    else
        sum=sum+0;
    end
end
%%过零率指数
Z_SQI = sum/N;

end