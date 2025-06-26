function [Result,T_train,T_test]= OUTPUT_averaging(data_train,data_test,T_train,T_test,Result)
%%   Average label
   [T_train] = Data_aver(data_train,T_train) ;
   [T_test] = Data_aver(data_test,T_test) ;
   M = length(T_train);N = length(T_test);
%%   Output average
%    Xgboost
   [Result.xgboost.T_sim1] = Data_aver(data_train,Result.xgboost.T_sim1) ;
   [Result.xgboost.T_sim2] = Data_aver(data_test,Result.xgboost.T_sim2) ;
   T_sim1 = Result.xgboost.T_sim1;T_sim2 = Result.xgboost.T_sim2;
   error1 = sqrt(sum((T_sim1 - T_train).^2) ./ M);
   error2 = sqrt(sum((T_sim2 - T_test ).^2) ./ N);
   R1 = 1 - norm(T_train - T_sim1)^2 / norm(T_train - mean(T_train))^2;
   R2 = 1 - norm(T_test -  T_sim2)^2 / norm(T_test -  mean(T_test ))^2;
   mae1 = sum(abs(T_sim1 - T_train)) ./ M ;
   mae2 = sum(abs(T_sim2 - T_test )) ./ N ;
   Result.xgboost.index = [error1 error2 R1 R2 mae1 mae2];
   clear T_sim1 T_sim2 error1 error2 R1 R2 mae1 mae2 mbe1 mbe2
%    SVM
   [Result.SVM.T_sim1] = Data_aver(data_train,Result.SVM.T_sim1) ;
   [Result.SVM.T_sim2] = Data_aver(data_test,Result.SVM.T_sim2) ;
   T_sim1 = Result.SVM.T_sim1;T_sim2 = Result.SVM.T_sim2;
   error1 = sqrt(sum((T_sim1 - T_train).^2) ./ M);
   error2 = sqrt(sum((T_sim2 - T_test ).^2) ./ N);
   R1 = 1 - norm(T_train - T_sim1)^2 / norm(T_train - mean(T_train))^2;
   R2 = 1 - norm(T_test -  T_sim2)^2 / norm(T_test -  mean(T_test ))^2;
   mae1 = sum(abs(T_sim1 - T_train)) ./ M ;
   mae2 = sum(abs(T_sim2 - T_test )) ./ N ;
   Result.SVM.index = [error1 error2 R1 R2 mae1 mae2];
   clear T_sim1 T_sim2 error1 error2 R1 R2 mae1 mae2 mbe1 mbe2
%Random_forest
   [Result.Random_forest.T_sim1] = Data_aver(data_train,Result.Random_forest.T_sim1) ;
   [Result.Random_forest.T_sim2] = Data_aver(data_test,Result.Random_forest.T_sim2) ;
   T_sim1 = Result.Random_forest.T_sim1;T_sim2 = Result.Random_forest.T_sim2;
   error1 = sqrt(sum((T_sim1 - T_train).^2) ./ M);
   error2 = sqrt(sum((T_sim2 - T_test ).^2) ./ N);
   R1 = 1 - norm(T_train - T_sim1)^2 / norm(T_train - mean(T_train))^2;
   R2 = 1 - norm(T_test -  T_sim2)^2 / norm(T_test -  mean(T_test ))^2;
   mae1 = sum(abs(T_sim1 - T_train)) ./ M ;
   mae2 = sum(abs(T_sim2 - T_test )) ./ N ;
   Result.Random_forest.index = [error1 error2 R1 R2 mae1 mae2];
   clear T_sim1 T_sim2 error1 error2 R1 R2 mae1 mae2 mbe1 mbe2
%Regression_logic
   [Result.Regression_logic.T_sim1] = Data_aver(data_train,Result.Regression_logic.T_sim1) ;
   [Result.Regression_logic.T_sim2] = Data_aver(data_test,Result.Regression_logic.T_sim2) ;
   T_sim1 = Result.Regression_logic.T_sim1;T_sim2 = Result.Regression_logic.T_sim2;
   error1 = sqrt(sum((T_sim1 - T_train).^2) ./ M);
   error2 = sqrt(sum((T_sim2 - T_test ).^2) ./ N);
   R1 = 1 - norm(T_train - T_sim1)^2 / norm(T_train - mean(T_train))^2;
   R2 = 1 - norm(T_test -  T_sim2)^2 / norm(T_test -  mean(T_test ))^2;
   mae1 = sum(abs(T_sim1 - T_train)) ./ M ;
   mae2 = sum(abs(T_sim2 - T_test )) ./ N ;
   Result.Regression_logic.index = [error1 error2 R1 R2 mae1 mae2];
   clear T_sim1 T_sim2 error1 error2 R1 R2 mae1 mae2 mbe1 mbe2
end