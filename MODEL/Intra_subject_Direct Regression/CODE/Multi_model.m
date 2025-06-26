function [Result] = Multi_model(P_train,P_test ,T_train,T_test,M,N)

%% 1. Using 3 Models to regression
[T_sim1,T_sim2,error1,error2,R1,R2,mae1,mae2,mbe1,mbe2] = xgboost_model(P_train,P_test ,T_train,T_test,M,N);
Result.xgboost.T_sim1 = T_sim1;
Result.xgboost.T_sim2 = T_sim2;
Result.xgboost.index = [error1 error2 R1 R2 mae1 mae2 mbe1 mbe2];
clear T_sim1 T_sim2 error1 error2 R1 R2 mae1 mae2 mbe1 mbe2

[T_sim1,T_sim2,error1,error2,R1,R2,mae1,mae2,mbe1,mbe2] = SVM_model(P_train,P_test ,T_train,T_test,M,N);
Result.SVM.T_sim1 = T_sim1;
Result.SVM.T_sim2 = T_sim2;
Result.SVM.index = [error1 error2 R1 R2 mae1 mae2 mbe1 mbe2];
clear T_sim1 T_sim2 error1 error2 R1 R2 mae1 mae2 mbe1 mbe2

[T_sim1,T_sim2,error1,error2,R1,R2,mae1,mae2,mbe1,mbe2] = Random_forest(P_train,P_test ,T_train,T_test,M,N);
Result.Random_forest.T_sim1 = T_sim1;
Result.Random_forest.T_sim2 = T_sim2;
Result.Random_forest.index = [error1 error2 R1 R2 mae1 mae2 mbe1 mbe2];
clear T_sim1 T_sim2 error1 error2 R1 R2 mae1 mae2 mbe1 mbe2

[T_sim1,T_sim2,error1,error2,R1,R2,mae1,mae2,mbe1,mbe2] = Regression_logic(P_train,P_test ,T_train,T_test,M,N);
Result.Regression_logic.T_sim1 = T_sim1;
Result.Regression_logic.T_sim2 = T_sim2;
Result.Regression_logic.index = [error1 error2 R1 R2 mae1 mae2 mbe1 mbe2];
clear T_sim1 T_sim2 error1 error2 R1 R2 mae1 mae2 mbe1 mbe2
end