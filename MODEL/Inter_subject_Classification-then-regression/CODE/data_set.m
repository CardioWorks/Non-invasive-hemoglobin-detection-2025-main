function [P_train,P_test ,T_train,T_test,M,N] = data_set(subject_feature,feature_column,Feature_select,correlation_index,id_list,ds_type,num_size)

    switch ds_type
        case 1
            [P_train,P_test ,T_train,T_test] = whole_divide(Feature_select,num_size);
        case 2
            [P_train,P_test ,T_train,T_test] = id_divide(Feature_select,id_list,num_size);
        case 3
            [P_train,P_test ,T_train,T_test] = mul_divide(subject_feature,feature_column,correlation_index,id_list,num_size);
    end
M = length(P_train);
N = length(P_test);
end