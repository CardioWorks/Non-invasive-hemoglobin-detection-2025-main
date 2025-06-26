function data_Test = Trimmean(data_Train,data_test,feature_column,type)
switch type 
    case 0
P_train = data_Train(:,feature_column+9);P_test =data_test(:,feature_column+9) ;T_train = data_Train(:,2) ;T_test = data_test(:,2);M = size(P_train,1);N = size(P_test,1);
[~,T_sim2] = xgboost_model(P_train',P_test' ,T_train',T_test',M,N);
data_Test = Optimization_algorithms(T_sim2,T_test,data_test,0.1,0);

    case 1
P_train = data_Train(:,[feature_column+9 411:end]);P_test =data_test(:,[feature_column+9 411:end]) ;T_train = data_Train(:,410) ;T_test = data_test(:,410);M = size(P_train,1);N = size(P_test,1);
[~,T_sim2,~,~] = SVM_model(P_train',P_test' ,T_train',T_test',M,N);
data_Test = Optimization_algorithms(T_sim2,T_test,data_test,0.1,1);
end
% data_Train = regres.data1_Train;data_test = regres.data1_Test;val1 = T_sim2;val2 = T_test;
end