function [P_train,P_test ,T_train,T_test]=id_divide(Feature_select,id_list,num_size)
%%  按id划分训练集
[~, ins, ~] = unique(id_list);
%%
    for i = 1:length(ins)
        if i == length(ins) %将数据集按id分开
            id_data = Feature_select(ins(i):end,:);
        else
            id_data = Feature_select(ins(i):ins(i+1)-1,:);
        end        
        %%
        num_samples = size(id_data, 1);
        num_train_s = round(num_size * num_samples);
        %%
        train_data = id_data(1: num_train_s,:);
        test_data = id_data(num_train_s + 1: end, :);
        %%
        if i == 1
            train_DATA = train_data;
            test_DATA = test_data;
        else
            train_DATA = vertcat(train_DATA,train_data);
            test_DATA = vertcat(test_DATA,test_data);

        end
        clear train_data test_data id_data
    end
            train_DATA = train_DATA(randperm(size(train_DATA, 1)), :);% 打乱数据集（不希望打乱时，注释该行）
            test_DATA = test_DATA(randperm(size(test_DATA, 1)), :);
            
            P_train = train_DATA(:,2:end);
            T_train = train_DATA(:,1);
            
            P_test = test_DATA(:,2:end);
            T_test = test_DATA(:,1);
            
 P_train = P_train';T_train = T_train';P_test = P_test';T_test = T_test';

end