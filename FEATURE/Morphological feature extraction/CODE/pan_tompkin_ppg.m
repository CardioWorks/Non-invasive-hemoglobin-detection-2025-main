function [PPG_R_peak,PPG_R_Loc]=pan_tompkin_ppg(ppg_data)
%输入ppg_data：ppg数据
%输出PPG_R_Loc：ppg波峰点
%    PPG_R_peak：ppg波峰值
%%调试
%plot(ppg_data,'DisplayName','ppg');
%text(ECG_R.Loc,ppg_data(ECG_R.Loc),'\leftarrow f')
%%
[ECG_R.peak,ECG_R.Loc,~] = pan_tompkin(ppg_data,200,0);
j=0;
h=0;
for i=1:1:length(ECG_R.Loc)-1
    while  ppg_data(ECG_R.Loc(i)+j+1)>= ppg_data(ECG_R.Loc(i))
        j=j+1; 
    end
    h=h+1;
    temp(h)=ECG_R.Loc(i)+j+1;
end

for i=1:1:length(ECG_R.Loc)-1
    PPG_R_Loc(i)=find_max(0,ECG_R.Loc(i),temp(i),ppg_data);
    PPG_R_peak(i)=ppg_data(PPG_R_Loc(i));
end
PPG_R_Loc(i+1)=find_max(0,ECG_R.Loc(i+1),length(ppg_data),ppg_data);
PPG_R_peak(i+1)=ppg_data(PPG_R_Loc(i+1));
end

