function [data_test,data_train] = data_set(subject_feature,ds_type,num_size)

    switch ds_type
        case 1
            [data_test,data_train] = whole_divide(subject_feature,num_size);
        case 2
            [data_test,data_train] = id_divide(subject_feature,num_size);
    end
end