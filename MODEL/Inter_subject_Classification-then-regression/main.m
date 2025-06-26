
warning off           
close all              
clear                   
clc                   


%% build work path
path.data = '.\DATA\';
path.output = '.\OUTPUT\';
addpath (genpath('.\CODE\'))

%%  Import dataset
% subject_feature contains [1: di, 2: HGB, 3-9: physiological parameters, 10-409: four-channel morphological features, 410: classification labels, 411-422: complex network features].
load(strcat(path.data,'subject_feature.mat'))

%%  Divide dataset
%  The dataset is divided into an 80% training set (in the training set, some beats are used to train the classifier, and some beats are used to train the regressor) and a 20% test set.
num_size = 0.8;
beats = 30;

[data_Test,data_train] = data_divide(subject_feature,num_size); % Divide the dataset into intervals with a width of 10.
[class_Train,regres_Train] = class_regres_divide(data_train,beats); % Divide the training set into a classification training set and a regression training set.

%%  Classifer
% Feature correlation ranking
fs_type = 5; %fs_type：1-pearson 2-relieff 3-fscchi2 4-fsrftest 5-fsmrmr 6-spearman
[RANKED,WEIGHT] = feature_selection_home(subject_feature(:,10:409),subject_feature(:,410),fs_type);

n = 10; % n = 10 n = 15 n = 20 n = 25 n = 30
feature_column = RANKED(1:n);
correlation_index = WEIGHT(1:n);

class.P_train = class_Train(:,[feature_column+9 411:end]);class.P_test =data_Test(:,[feature_column+9 411:end]) ;class.T_train = class_Train(:,410) ;class.T_test = data_Test(:,410);M = size(class.P_train,1);N = size(class.P_test,1);
[class.T_sim1,class.T_sim2,class.error1,class.error2] = SVM_model(class.P_train,class.P_test,class.T_train,class.T_test,M,N);
P_train=class.P_train;P_test=class.P_test;T_train=class.T_train;T_test=class.T_test;
%%  Divide the training set and test set according to the classification results.
[regres.data1_Train,regres.data2_Train,regres.data3_Train] = Input_Classification(regres_Train(:,410),regres_Train);
[regres.data1_Test,regres.data2_Test,regres.data3_Test] = Input_Classification(class.T_sim2,data_Test);

%%  Regressor
% Feature correlation ranking
for fs_type = 1:6 %fs_type：1-pearson 2-relieff 3-fscchi2 4-fsrftest 5-fsmrmr 6-spearman
[RANKED,WEIGHT] = feature_selection_home(subject_feature(:,10:409),subject_feature(:,2),fs_type);

for n = 10:5:30 % n = 10 n = 15 n = 20 n = 25 n = 30
feature_column = RANKED(1:n);
correlation_index = WEIGHT(1:n);

% Three Xgboost models form a comprehensive regressor
[T_train,T_test,T_sim1,T_sim2,error1,R1,mae1,error2,R2,mae2] = integrated_regressor(regres.data1_Train,regres.data1_Test,regres.data2_Train,regres.data2_Test,regres.data3_Train,regres.data3_Test,feature_column);

close all

%%  Save data
switch fs_type
    case 1
        switch n
            case 5
                output_name = 'pearson_5features.csv';
            case 10
                output_name = 'pearson_10features.csv';
            case 15
                output_name = 'pearson_15features.csv';
            case 20
                output_name = 'pearson_20features.csv';
            case 25
                output_name = 'pearson_25features.csv';
            case 30
                output_name = 'pearson_30features.csv';
        end
    case 2
        switch n
            case 5
                output_name = 'relieff_5features.csv';
            case 10
                output_name = 'relieff_10features.csv';
            case 15
                output_name = 'relieff_15features.csv';
            case 20
                output_name = 'relieff_20features.csv';
            case 25
                output_name = 'relieff_25features.csv';
            case 30
                output_name = 'relieff_30features.csv';
        end
    case 3
        switch n
            case 5
                output_name = 'ChiSquare_5features.csv';
            case 10
                output_name = 'ChiSquare_10features.csv';
            case 15
                output_name = 'ChiSquare_15features.csv';
            case 20
                output_name = 'ChiSquare_20features.csv';
            case 25
                output_name = 'ChiSquare_25features.csv';
            case 30
                output_name = 'ChiSquare_30features.csv';
        end
    case 4
        switch n
            case 5
                output_name = 'fsrftest_5features.csv';
            case 10
                output_name = 'fsrftest_10features.csv';
            case 15
                output_name = 'fsrftest_15features.csv';
            case 20
                output_name = 'fsrftest_20features.csv';
            case 25
                output_name = 'fsrftest_25features.csv';
            case 30
                output_name = 'fsrftest_30features.csv';
        end
    case 5
        switch n
            case 5
                output_name = 'fsrmrmr_5features.csv';
            case 10
                output_name = 'fsrmrmr_10features.csv';
            case 15
                output_name = 'fsrmrmr_15features.csv';
            case 20
                output_name = 'fsrmrmr_20features.csv';
            case 25
                output_name = 'fsrmrmr_25features.csv';
            case 30
                output_name = 'fsrmrmr_30features.csv';
        end
end

%% Save the results to a CSV file.
writematrix(datevec(datenum(clock)),[path.output output_name],'WriteMode','append');
writematrix([length(T_train) length(T_test) num_size 1-num_size],[path.output output_name],'WriteMode','append');

% Number of feature selections output
writematrix('fQuantity',[path.output output_name],'WriteMode','append');
writematrix(n,[path.output output_name],'WriteMode','append');

% Feature ranking results output
writematrix('Sort Result',[path.output output_name],'WriteMode','append');
writematrix(feature_column,[path.output output_name],'WriteMode','append');

% error1 error2 Train_R2 Test_R2 Train_MAE Test_MAE Train_MBE Test_MBE of XGBoost
writematrix('xgboost Model',[path.output output_name],'WriteMode','append');

writematrix('T_sim1',[path.output output_name],'WriteMode','append');
writematrix(T_sim1,[path.output output_name],'WriteMode','append');

writematrix('T_train',[path.output output_name],'WriteMode','append');
writematrix(T_train,[path.output output_name],'WriteMode','append');

writematrix('T_sim2',[path.output output_name],'WriteMode','append');
writematrix(T_sim2,[path.output output_name],'WriteMode','append');

writematrix('T_test',[path.output output_name],'WriteMode','append');
writematrix(T_test,[path.output output_name],'WriteMode','append'); 

%writematrix('error1 error2 Train_R2 Test_R2 Train_MAE Test_MAE Train_MBE Test_MBE',[path.output output_name],'WriteMode','append');
writematrix([error2 R2 mae2],[path.output output_name],'WriteMode','append');
end
end