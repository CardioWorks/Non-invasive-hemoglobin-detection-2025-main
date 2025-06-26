function [SQI] = sqi_home(type,data_raw,data_filter)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
switch type
    case 1
        SQI = signal_entropy(data_filter);
    case 2
        SQI = signal_Kurtosis(data_filter);
    case 3
        SQI = signal_perfusion(data_filter,data_raw);
    case 4
        SQI = signal_skewness(data_filter);
    case 5
        SQI = signal_SNR(data_raw,data_filter);
    case 6
        SQI = signal_zerocrossing(data_filter);
end
end