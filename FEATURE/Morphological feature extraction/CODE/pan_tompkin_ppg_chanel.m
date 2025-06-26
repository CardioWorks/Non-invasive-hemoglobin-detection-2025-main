function [PPG_P_peak,PPG_P_Loc] = pan_tompkin_ppg_chanel(channel_1,channel_2,channel_3,channel_4,ppg_data)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[~,PPG_R_Loc1,~] = pan_tompkin(channel_1,400,0);
[~,PPG_R_Loc2,~] = pan_tompkin(channel_2,400,0);
[~,PPG_R_Loc3,~] = pan_tompkin(channel_3,400,0);
[~,PPG_R_Loc4,~] = pan_tompkin(channel_4,400,0);
%%
std1=std(diff(PPG_R_Loc1));
std2=std(diff(PPG_R_Loc2));
std3=std(diff(PPG_R_Loc3));
std4=std(diff(PPG_R_Loc4));
%%
s=[std1,std2,std3,std4];
[~,i]=min(s);

%%
switch i
    case 1
        PPG_P_Loc=PPG_R_Loc1;
    case 2
        PPG_P_Loc=PPG_R_Loc2;
    case 3
        PPG_P_Loc=PPG_R_Loc3;
    case 4
        PPG_P_Loc=PPG_R_Loc4;
end

%plot(ppg_data,'DisplayName','ppg');
%text(PPG_P_Loc,ppg_data(PPG_P_Loc),'\leftarrow f')
%%
j=0;
h=0;
for i=1:1:length(PPG_P_Loc)-1
    while  ppg_data(PPG_P_Loc(i)+j+1)>= ppg_data(PPG_P_Loc(i))
        j=j+1; 
    end
    h=h+1;
    temp(h)=PPG_P_Loc(i)+j+1;
end

for i=1:1:length(PPG_P_Loc)-1
    PPG_P_Loc(i)=find_max(0,PPG_P_Loc(i),temp(i),ppg_data);
    PPG_P_peak(i)=ppg_data(PPG_P_Loc(i));
end
PPG_P_Loc(i+1)=find_max(0,PPG_P_Loc(i+1),length(ppg_data),ppg_data);
PPG_P_peak(i+1)=ppg_data(PPG_P_Loc(i+1));

end

