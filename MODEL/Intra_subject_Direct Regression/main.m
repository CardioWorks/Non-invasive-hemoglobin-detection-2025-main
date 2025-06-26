warning off 
clear
clc

path.data = '.\DATA\';
path.output = '.\OUTPUT\';
addpath (genpath('.\CODE\'))
addpath (genpath('.\lib\'))
loadWeka(['lib' filesep 'weka']);

%%  Import dataset
load(strcat(path.data,'subject_feature3.mat'))


num_size = 0.8;                              % proportion of training set

%%  divide training set and test set
ds_type = 2;
[data_test,data_train] = data_set(subject_feature,ds_type,num_size);

%% Feature correlation ranking
feature = subject_feature(:,10:410);%
val = subject_feature(:,2);%
%% fs_type：1-pearson 2-relieff 3-fsChiSquare 4-fsrftest 5-fsrmrmr
for fs_type = 5
[RANKED,WEIGHT] = feature_selection_home(feature,val,fs_type);
% bar(WEIGHT)
% xlabel('Predictor rank')
% ylabel('Predictor importance score')

%%  feature select
% n = 10 n = 15 n = 20 n = 25 n = 30 
for n = 10:5:30
feature_column = RANKED(1:n);
correlation_index = WEIGHT(1:n);

%%  Training multiple models together
P_train = data_train(:,feature_column+9);P_test = data_test(:,feature_column+9);T_train = data_train(:,2);T_test = data_test(:,2);M = size(P_train,1);N = size(P_test,1);
[Result] = Multi_model(P_train',P_test' ,T_train',T_test',M,N);
% T_test = T_test';
% T_train = T_train';
% Average the output by id
[Result,T_train,T_test] = OUTPUT_averaging(data_train,data_test,T_train,T_test,Result);

switch fs_type
    case 1
        switch n
            case 5
                output_name = 'id_pearson_5features.csv';
            case 10
                output_name = 'id_pearson_10features.csv';
            case 15
                output_name = 'id_pearson_15features.csv';
            case 20
                output_name = 'id_pearson_20features.csv';
            case 25
                output_name = 'id_pearson_25features.csv';
            case 30
                output_name = 'id_pearson_30features.csv';
        end
    case 2
        switch n
            case 5
                output_name = 'id_relieff_5features.csv';
            case 10
                output_name = 'id_relieff_10features.csv';
            case 15
                output_name = 'id_relieff_15features.csv';
            case 20
                output_name = 'id_relieff_20features.csv';
            case 25
                output_name = 'id_relieff_25features.csv';
            case 30
                output_name = 'id_relieff_30features.csv';
        end
    case 3
        switch n
            case 5
                output_name = 'id_ChiSquare_5features.csv';
            case 10
                output_name = 'id_ChiSquare_10features.csv';
            case 15
                output_name = 'id_ChiSquare_15features.csv';
            case 20
                output_name = 'id_ChiSquare_20features.csv';
            case 25
                output_name = 'id_ChiSquare_25features.csv';
            case 30
                output_name = 'id_ChiSquare_30features.csv';
        end
    case 4
        switch n
            case 5
                output_name = 'id_fsrftest_5features.csv';
            case 10
                output_name = 'id_fsrftest_10features.csv';
            case 15
                output_name = 'id_fsrftest_15features.csv';
            case 20
                output_name = 'beats_fsrftest_20features.csv';
            case 25
                output_name = 'beats_fsrftest_25features.csv';
            case 30
                output_name = 'beats_fsrftest_30features.csv';
        end
    case 5
        switch n
            case 5
                output_name = 'beats_fsrmrmr_5features.csv';
            case 10
                output_name = 'beats_fsrmrmr_10features.csv';
            case 15
                output_name = 'beats_fsrmrmr_15features.csv';
            case 20
                output_name = 'beats_fsrmrmr_20features.csv';
            case 25
                output_name = 'beats_fsrmrmr_25features.csv';
            case 30
                output_name = 'beats_fsrmrmr_30features.csv';
        end
end

%%save results to csv files
writematrix(datevec(datenum(clock)),[path.output output_name],'WriteMode','append');
writematrix([length(P_train) length(P_test) num_size 1-num_size],[path.output output_name],'WriteMode','append');

%Number of feature selections output
writematrix('fQuantity',[path.output output_name],'WriteMode','append');
writematrix(n,[path.output output_name],'WriteMode','append');

%Feature ranking results output
writematrix('Sort Result',[path.output output_name],'WriteMode','append');
writematrix(feature_column,[path.output output_name],'WriteMode','append');

%error1 error2 Train_R2 Test_R2 Train_MAE Test_MAE Train_MBE Test_MBE of XGBoost
writematrix('xgboost Model',[path.output output_name],'WriteMode','append');

writematrix('T_sim1',[path.output output_name],'WriteMode','append');
writematrix(Result.xgboost.T_sim1,[path.output output_name],'WriteMode','append');

writematrix('T_train',[path.output output_name],'WriteMode','append');
writematrix(T_train,[path.output output_name],'WriteMode','append');

writematrix('T_sim2',[path.output output_name],'WriteMode','append');
writematrix(Result.xgboost.T_sim2,[path.output output_name],'WriteMode','append');

writematrix('T_test',[path.output output_name],'WriteMode','append');
writematrix(T_test,[path.output output_name],'WriteMode','append'); 

%writematrix('error1 error2 Train_R2 Test_R2 Train_MAE Test_MAE Train_MBE Test_MBE',[path.output output_name],'WriteMode','append');
writematrix(Result.xgboost.index,[path.output output_name],'WriteMode','append');

%error1 error2 Train_R2 Test_R2 Train_MAE Test_MAE Train_MBE Test_MBE of SVM
writematrix('SVM Model',[path.output output_name],'WriteMode','append'); 

writematrix('T_sim1',[path.output output_name],'WriteMode','append');
writematrix(Result.SVM.T_sim1,[path.output output_name],'WriteMode','append');

writematrix('T_train',[path.output output_name],'WriteMode','append');
writematrix(T_train,[path.output output_name],'WriteMode','append');

writematrix('T_sim2',[path.output output_name],'WriteMode','append');
writematrix(Result.SVM.T_sim2,[path.output output_name],'WriteMode','append');

writematrix('T_test',[path.output output_name],'WriteMode','append');
writematrix(T_test,[path.output output_name],'WriteMode','append');

%writematrix('error1 error2 Train_R2 Test_R2 Train_MAE Test_MAE Train_MBE Test_MBE',[path.output output_name],'WriteMode','append');
writematrix(Result.SVM.index,[path.output output_name],'WriteMode','append');


%error1 error2 Train_R2 Test_R2 Train_MAE Test_MAE Train_MBE Test_MBE Random-forest
writematrix('Random-forest Model',[path.output output_name],'WriteMode','append');

writematrix('T_sim1',[path.output output_name],'WriteMode','append');
writematrix(Result.Random_forest.T_sim1,[path.output output_name],'WriteMode','append');

writematrix('T_train',[path.output output_name],'WriteMode','append');
writematrix(T_train,[path.output output_name],'WriteMode','append');

writematrix('T_sim2',[path.output output_name],'WriteMode','append');
writematrix(Result.Random_forest.T_sim2,[path.output output_name],'WriteMode','append');

writematrix('T_test',[path.output output_name],'WriteMode','append');
writematrix(T_test,[path.output output_name],'WriteMode','append');

%writematrix('error1 error2 Train_R2 Test_R2 Train_MAE Test_MAE Train_MBE Test_MBE',[path.output output_name],'WriteMode','append');
writematrix(Result.Random_forest.index,[path.output output_name],'WriteMode','append');

%error1 error2 Train_R2 Test_R2 Train_MAE Test_MAE Train_MBE Test_MBE of Random-forest
writematrix('Regression_logic Model',[path.output output_name],'WriteMode','append');

writematrix('T_sim1',[path.output output_name],'WriteMode','append');
writematrix(Result.Regression_logic.T_sim1,[path.output output_name],'WriteMode','append');

writematrix('T_train',[path.output output_name],'WriteMode','append');
writematrix(T_train,[path.output output_name],'WriteMode','append');

writematrix('T_sim2',[path.output output_name],'WriteMode','append');
writematrix(Result.Regression_logic.T_sim2,[path.output output_name],'WriteMode','append');

writematrix('T_test',[path.output output_name],'WriteMode','append');
writematrix(T_test,[path.output output_name],'WriteMode','append');

%writematrix('error1 error2 Train_R2 Test_R2 Train_MAE Test_MAE Train_MBE Test_MBE',[path.output output_name],'WriteMode','append');
writematrix(Result.Regression_logic.index,[path.output output_name],'WriteMode','append');

close all
end
end