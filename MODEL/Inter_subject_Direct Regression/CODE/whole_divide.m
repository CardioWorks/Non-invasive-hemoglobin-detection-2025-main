function [P_train,P_test ,T_train,T_test] = whole_divide(Feature_select,num_size)
%%
num_samples = size(Feature_select, 1);% ��������
Feature_select = Feature_select(randperm(num_samples), :); % �������ݼ�����ϣ������ʱ��ע�͸��У�
num_train_s = round(num_size * num_samples); % ѵ������������
f_ = size(Feature_select, 2);
%%
P_train = Feature_select(1: num_train_s, 2: f_)';
T_train = Feature_select(1: num_train_s, 1)';%��һ������ʵֵ

P_test = Feature_select(num_train_s + 1: end, 2: f_)';
T_test = Feature_select(num_train_s + 1: end, 1)';

end