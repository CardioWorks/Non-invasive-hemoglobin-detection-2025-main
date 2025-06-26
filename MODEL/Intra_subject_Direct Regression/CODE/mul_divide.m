function [P_train,P_test ,T_train,T_test] = mul_divide(subject_feature,feature_column,correlation_index,id_list,num_size)

[~, ins, ~] = unique(id_list);
val_list = subject_feature(ins,2);
num_column = length(feature_column);
%%
    for i = 1:length(ins)
        if i == length(ins) %�����ݼ���id�ֿ�
            single_feature = subject_feature(ins(i):end,:);
        else
            single_feature = subject_feature(ins(i):ins(i+1)-1,:);
        end         
        
        k = size(single_feature);
        for beat = 1:k(1)
             for l=1:num_column
        [feature_score(beat,l)] = Feature_column_score(single_feature,correlation_index(l)/sum(correlation_index),feature_column(l),beat);
        %correlation_index=correlation_index(l)/sum(correlation_index(l:10));Feature_column=Feature_column(l);
             end
        end
        beat_score = sum(feature_score,2);
          %%
        num_170 = length(find(val_list>=170));%�������beat�������
        num_160 = length(find(val_list>=160))-length(find(val_list>=170));
        num_150 = length(find(val_list>=150))-length(find(val_list>=160));
        num_140 = length(find(val_list>=140))-length(find(val_list>=150));
        num_130 = length(find(val_list>=130))-length(find(val_list>=140));
        num_120 = length(find(val_list>=120))-length(find(val_list>=130));
        num_110 = length(find(val_list>=110));
        mul_170 = round(100/num_170);mul_160 = round(100/num_160);mul_150 = round(100/num_150);mul_140 = round(100/num_140);mul_130 = round(100/num_130);mul_120 = round(100/num_120);mul_110 = round(100/num_110);
       
        val_interval = [110 120 130 140 150 160 170 180];
        mul_interval = [mul_110 mul_120 mul_130 mul_140 mul_150 mul_160 mul_170];
        val = single_feature(1,2);%Ѫ�쵰����ʵֵ
        val_interval = sort([val_interval val]);
        ind = find(val_interval==val);
        if length(ind) ~= 1
            if ind(end) == length(val_interval)
                ind = ind(1);
            else
                ind = ind(end);
            end
        end
        num = mul_interval(ind-1);
          %%
          if num >= k(1)
            feature = single_feature(:,[2 feature_column]);
          else
            [optimum_beat] = find_num_max(beat_score,num);
            feature = single_feature(optimum_beat,[2 feature_column]);
          end       
        clear single_feature beat_score feature_score
        if i == 1
            feature_mul_beat = feature;
        else
            feature_mul_beat = vertcat(feature_mul_beat,feature);
        end
        
    end
    %%
    num_samples = size(feature_mul_beat, 1);
    feature_mul_beat = feature_mul_beat(randperm(num_samples), :);
    num_train_s = round(num_size * num_samples);
    
    P_train = feature_mul_beat(1: num_train_s, 2: end)';
    T_train = feature_mul_beat(1: num_train_s, 1)';

    P_test = feature_mul_beat(num_train_s + 1: end, 2:end)';
    T_test = feature_mul_beat(num_train_s + 1: end, 1)';

end