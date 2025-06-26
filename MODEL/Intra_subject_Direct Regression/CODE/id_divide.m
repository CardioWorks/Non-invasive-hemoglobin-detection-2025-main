function [test_DATA,train_DATA ]=id_divide(subject_feature,num_size)

id_list = subject_feature(:,1);
id_list = unique(id_list);
%%
    for i = 1:length(id_list)
        id_data = subject_feature(ismember(subject_feature(:, 1), id_list(i)), :);%��ȡÿ����������

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
    end

end