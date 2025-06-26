function [Result] = Sample_Average_Output(subject_feature,Result)
%%  id——list
id_list = data_train(:,1);
[~, ins, ~] = unique(id_list);

for i = 1:length(ins)
    if i == length(ins) %Divide dataset by ID
       id_data = T_train(ins(i):end,:);
    else
       id_data = T_train(ins(i):ins(i+1)-1,:);
    end 
end
end