function [vpg,apg,third,fourth] = multi_derivative(data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        multi_derivative.m
% Function Name:Preprocess the signal window
% Last update date:2017-11-11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PPG�͵��������в�ͬ��Ƶ����Ϣ
%Ӧ���ò�ͬ�Ĺ��˹���.
[a,b] = butter(2,10/100,'low');

%% 2--PPG�źŴ�������˲�������;
first_deri = ppg_derivative(data);
[a,b] = butter(2,10/100,'low');
vpg = filtfilt(a,b,first_deri);   

second_deri = ppg_derivative(vpg);  
apg = filtfilt(a,b,second_deri);

third_deri = ppg_derivative(apg);
third = filtfilt(a,b,third_deri);

fouth_deri = ppg_derivative(third);
fourth = filtfilt(a,b,fouth_deri);

% apg = ppg_derivative(vpg);  
% 
% third = ppg_derivative(apg);
% 
% fourth = ppg_derivative(third);

end


