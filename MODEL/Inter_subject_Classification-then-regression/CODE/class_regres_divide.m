function [class_Train,regres_Train] = class_regres_divide(data_train,beats)
%%  
id_list = data_train(:,1);
id_list = unique(id_list);
%%  
for i = 1:length(id_list)
    single_sample_data = data_train(ismember(data_train(:, 1), id_list(i)), :);\
    beats = size(single_sample_data,1);
    if beats == 0
        single_sample_beats = single_sample_data;
        rng('shuffle'); 
        randomNumbers = randperm(size(single_sample_beats,1), ceil((size(single_sample_beats,1))/2));
    else
        single_sample_beats = beats_save(single_sample_data,beats);
        rng('shuffle'); 
        randomNumbers = randperm(beats, ceil(beats/2));
    end


    class_train = single_sample_beats(randomNumbers,:);
    single_sample_beats(randomNumbers,:) = [];
    regres_train = single_sample_beats;

    if i == 1
        class_Train = class_train;
        regres_Train = regres_train;
    else
        class_Train = [class_Train;class_train];
        regres_Train = [regres_Train;regres_train];
    end
end
end