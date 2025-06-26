function [cross_value,cross_point] = find_intersection_point(num_star,data_above,data_below)
%num_star£ºÆðµã
%data_above:
%data_below:
i = num_star;
while data_above(i) >= data_below(i)
    i=i+1;
end
cross_point=i;
cross_value=data_above(i);
end

