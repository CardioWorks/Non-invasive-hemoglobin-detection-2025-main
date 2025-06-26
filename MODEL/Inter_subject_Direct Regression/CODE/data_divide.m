function [data_test,data_train] = data_divide(subject_feature,num_size);
id_list = unique(subject_feature(:,1:2),'rows');
id_list = sortrows(id_list,2);

val_list = id_list(:,2);
[histogramCounts, ~] = histcounts(val_list); 
num_test = ceil(histogramCounts*(1-num_size));
%
for i = 1:length(histogramCounts) 
ins_test(i) = sum(histogramCounts(1:i));
end
 
for i = 1:length(ins_test)
    if i == 1
       a = randi([1,ins_test(i)], 1, num_test(i));
       Ins_test = a;
    else
       a = randi([ins_test(i-1)+1,ins_test(i)], 1, num_test(i));
       Ins_test = [Ins_test a];
    end
end
%
id_test = id_list(Ins_test,:);
val_list2 = id_test(:,2);

data_test = subject_feature(ismember(subject_feature(:, 1), id_test), :);
data_train = subject_feature(~ismember(subject_feature(:, 1), id_test), :);
end