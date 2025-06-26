function [T_sim1,T_sim2,error1,error2] = svm_class_model(P_train,P_test ,T_train,T_test,M,N)
%%  Data normalization
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  Transpose to fit the model
p_train = p_train'; p_test = p_test';
t_train = t_train'; t_test = t_test';

%%  Model creation
c = 1;      % penalty factor
g = 0.5;    % Radial basis function parameters
cmd = [' -t 2',' -c ',num2str(c),' -g ',num2str(g),' -s 3 -p 0.01'];
model = svm_train(t_train, p_train, cmd);

%%  simulation prediction
[t_sim1, error1] = svmpredict(t_train, p_train, model);
[t_sim2, error2] = svmpredict(t_test , p_test , model);

%%  Data denormalization
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);

%%  Data normalization
[T_sim1] = Outcome_norms(T_train,T_sim1);
[T_sim2] = Outcome_norms(T_test,T_sim2);

%%  RMSE
error1 = sum((T_train == T_sim1)) / M * 100;
error2 = sum((T_test == T_sim2)) / N * 100;

figure
cm = confusionchart(T_train, T_sim1);
cm.Title = 'Confusion Matrix for Train Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';

figure
cm = confusionchart(T_test, T_sim2);
cm.Title = 'Confusion Matrix for Test Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';

disp(['accuracy of training set:', num2str(error1)])
disp(['accuracy of test set:', num2str(error2)])
end