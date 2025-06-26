%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        area_calculate
% Last update date:2017-07-01
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function area_sum = area_calculate(base,num_start,num_end,data)
    area_sum = data(num_start)-base;   
    for i=num_start:num_end
        area_sum =area_sum+(data(i)-base);  
    end
end