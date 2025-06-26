function [data_test,data_train] = whole_divide(subject_feature,num_size)
%%
num_samples = size(subject_feature, 1);
subject_feature = subject_feature(randperm(num_samples), :); 
num_train_s = round(num_size * num_samples); 

data_train = subject_feature(1:num_train_s,:);
data_test = subject_feature(num_train_s+1:end,:);

end