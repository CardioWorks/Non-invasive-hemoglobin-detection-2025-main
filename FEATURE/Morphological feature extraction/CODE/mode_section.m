function [select_beat] = mode_section(subject_feature,num_feature)
%%
h = histogram(subject_feature(:,num_feature));
h_value = h.Values;
h_BinEdges = h.BinEdges;
[~,p] = max(h_value);
k = size(subject_feature);
count = 0;
for j=1:k(1)
    if subject_feature(j,num_feature) <= h_BinEdges(p+1) && subject_feature(j,num_feature) >= h_BinEdges(p)
        count = count+1;
        select_beat(1,count) = j;
        select_beat(2,count) = subject_feature(j,num_feature);
    end
end
%%
end

