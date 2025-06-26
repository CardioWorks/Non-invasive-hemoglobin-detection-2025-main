function [FDF]= fre_feature_calculation(ppg,num_onset,num_offset)
%%
% ppg = wave_1.ppg;
% num_onset = PPG_P.Loc_1(beat);
% num_offset = PPG_P.Loc_1(beat+2);
data = ppg(num_onset:num_offset);
L = length(ppg(num_onset:num_offset));
fs = 200;

%%
ch1_fft = fft(data);
ch1_p2 = abs(ch1_fft/L);
ch1_p1 = ch1_p2(1:ceil(L/2)+1);
ch1_p1(2:end-1) = 2*ch1_p1(2:end-1);
f = fs*(0:ceil(L/2))/L;
% plot(f(2:end),ch1_p1(2:end))

%频域幅值平均值
FDF.AF_AM = mean(ch1_p1);
%重心频率
FDF.AF_CF = sum(f.*ch1_p1)/sum(ch1_p1);
%均方频率
FDF.AF_MSF = sum((f.*f).*ch1_p1)/sum(ch1_p1);
%方差频率
FDF.AF_RMSF = sqrt(sum((f.*f).*ch1_p1)/sum(ch1_p1));
%频率方差
FDF.AF_FVAR = sum(((f-FDF.AF_CF).^2).*ch1_p1)/sum(ch1_p1);

%%
%功率谱图
temp_power = ch1_p1.*ch1_p1;
%plot(f,temp_power)


%平均频率
FDF.PS_MNF = sum(f.*temp_power)/sum(temp_power);
%中值频率
TP = sum(temp_power);
TP_half_1 = 0;
TP_half_r = 0;
for i = 1:L/2-1
    TP_half_1 = TP_half_1 +temp_power(i);
    TP_half_r = TP_half_r +temp_power(i+1);
    if TP_half_1 == TP/2
        FDF.PS_MDF = f(i);
        break;
    elseif TP_half_1 < TP/2 && TP_half_r >TP/2
        FDF.PS_MDF =(f(i)+f(i+1))/2;
        break;
    else
        continue
    end    
end
    if TP_half_1 == TP/2
        FDF.PS_MDF = f(i);
    else
        FDF.PS_MDF =(f(i)+f(i+1))/2;
    end
%总功率
FDF.PS_TP = sum(temp_power);
%平均功率
FDF.PS_MNP = mean(temp_power);
%最大功率值所对应的频率
[~,loc] = max(temp_power(2:end));
FDF.PS_MPF = f(loc+1);

%%
[pks,locs] = findpeaks(ch1_p1(2:end));

%f_base
if length(locs) >= 1
    f_base = pks(1);
%|S_base|
    S_base = f(locs(1)+1);
else
    f_base = 0;
    S_base = 0;
end

%f_1nd
if length(locs) >= 2
    f_1nd = pks(2);
%|S_1nd|
    S_1nd = f(locs(2)+1);
else
    f_1nd = 0;
    S_1nd = 0;
end

%f_2nd
if length(locs) >= 3
    f_2nd = pks(3);
%|S_2nd|
    S_2nd = f(locs(3)+1);
else
    f_2nd = 0;
    S_2nd = 0;
end

%f_3nd 
if length(locs) >= 4
    f_3nd = pks(4);
%|S_3nd|
    S_3nd = f(locs(4)+1);
else
    f_3nd = 0;
    S_3nd = 0;
end
%%
FDF.f_base = f_base;
FDF.S_base = S_base;
FDF.f_1nd = f_1nd;
FDF.S_1nd = S_1nd;
FDF.f_2nd = f_2nd;
FDF.S_2nd = S_2nd;
FDF.f_3nd = f_3nd;
FDF.S_3nd = S_3nd;

end