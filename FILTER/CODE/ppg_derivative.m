function [derivative_data] = ppg_derivative(raw_data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ppg_derivative
% ppg_derivative.m
% Function Name:ppg_derivative
% Designed by Yongbo
% Last update date:2017-06-18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Forward Difference
derivative_data(1) = raw_data(2)-raw_data(1);
for n=2:1:length(raw_data)
derivative_data(n) = raw_data(n)-raw_data(n-1);
end

%% Central Difference
% derivative_data(1) = raw_data(2)-raw_data(1);
% for n=2:1:length(raw_data)-1
% derivative_data(n) = (raw_data(n+1)-raw_data(n-1))/2;
% end
% derivative_data(length(raw_data)) = derivative_data(length(raw_data)-1);

end