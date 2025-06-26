function [feature_score] = Feature_column_score(subject_feature,correlation_index,Feature_column,beat)
%%
num_feature=Feature_column;
nbins = 10;
h = histogram(subject_feature(:,num_feature),nbins,'Normalization','probability');
h_BinEdges = sort([h.BinEdges subject_feature(beat,num_feature)]);
ind = find(h_BinEdges==subject_feature(beat,num_feature));
if length(ind) ~= 1
    if ind(end) == length(h_BinEdges)
        ind = ind(1);
    else
        ind = ind(end);
    end
end
h_value = h.Values(ind-1);
feature_score = correlation_index*h_value;
end

