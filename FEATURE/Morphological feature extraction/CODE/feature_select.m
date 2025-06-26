function feature_select
    %[data,charac]=xlsread('D:\硕士研究生项目\�?红蛋白项目\小论文撰写资料大合集\MATLAB-孟源代码\HemPredict\data.xlsx');
    train_data = subject_feature(:,1:end);%70*40
    train_val = subject_feature(:,end);%70*1     
    [train_st_data,data_mean,data_st] = zscore(train_data);
    train_st_val = zscore(train_val);
    co_matrix = train_st_data'*train_st_data;
    [U,S,V] = svd(co_matrix);
    [coeff,score,latent] = pca(train_st_data);%
    for i=1:size(score)
        rate_con(i) = sum(score(i,:))/sum(sum(score));
    end
    wa = zeros(1,size(train_st_data,2));%40�?
    figure
    for i=1:40
        [ranked,weights] = relieff(train_data,train_val,i);
       weights = weights;
        for ii=1:size(weights,2)
           wa(ii) = wa(ii) + weights(ii); 
        end
        plot(weights,'b');
        hold on;
    end
    set(gca,'XTickMode','manual','XTick',[1:41]);
    name =  {'F3','F4','F5','F6','F7','F8','F9','F10','F11','F12','F13','F14','F15','F16','F17','F18','F19','F20','F21','F22','F23','F24','F25','F26','F27','F28','F29','F30','F31','F32','F32','F33','F34','F35','F36','F37','F38','F39','F40','F41','F42'};
    set(gca,'xticklabel',name);
    set(gca,'FontSize',15);
    rotateticklabel(gca, 45);%
    %%xlabel('Predictor rank');
    ylabel('Predictor importance weight');
    hold off;
    
    wa = wa./ (size(train_st_data,1)-10);
    figure
    bar(wa);
    set(gca,'XTickMode','manual','XTick',[1:41]);
    name={'F3','F4','F5','F6','F7','F8','F9','F10','F11','F12','F13','F14','F15','F16','F17','F18','F19','F20','F21','F22','F23','F24','F25','F26','F27','F28','F29','F30','F31','F32','F32','F33','F34','F35','F36','F37','F38','F39','F40','F41','F42'};
    set(gca,'xticklabel',name);
    set(gca,'FontSize',15);
    rotateticklabel(gca, 45);%��������ĺ������������?45��
    ylabel('Predictor importance weight');
    %input_data = train_data(:,ranked(1:41));
    
    %beta = bp2(input_data,train_val);
end