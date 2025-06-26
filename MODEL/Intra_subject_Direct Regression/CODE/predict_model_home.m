function [T_sim1,T_sim2] = predict_model_home(P_train,P_test ,T_train,T_test,M,N,pm_type)

switch pm_type
    case 1
        [T_sim1,T_sim2] = xgboost_model(P_train,P_test ,T_train,T_test,M,N);
    case 2
        [T_sim1,T_sim2] = SVM_model(P_train,P_test ,T_train,T_test,M,N);
    case 3
        [T_sim1,T_sim2] = Random_forest(P_train,P_test ,T_train,T_test,M,N);
end

end