function [RANKED,WEIGHT] = feature_selection_home(X,Y,fs_type)

switch fs_type
    case 1
        corr_Y_X = corr(Y,X,'type','Pearson');
        corr_Y_X(isnan(corr_Y_X)==1) = 0;%change the 'NaN' value to '0':
        [WEIGHT,RANKED] = sort(abs(corr_Y_X),'descend');
        
    case 2
        [RANKED,WEIGHT] = relieff(X,Y,10,'method','Regression');
        WEIGHT = WEIGHT(RANKED);

    case 3
        [idx,scores] = fscchi2(X,Y);
        RANKED = 1:1:1000;
        RANKED = RANKED(idx);
        WEIGHT = scores(idx);

    case 4
        [idx,scores] = fsrftest(X,Y);
        RANKED = 1:1:1000;
        RANKED = RANKED(idx);
        WEIGHT = scores(idx);

    case 5
        [idx,scores] = fsrmrmr(X,Y);
        RANKED = 1:1:1000;
        RANKED = RANKED(idx);
        WEIGHT = scores(idx);

    case 6
        corr_Y_X = corr(Y,X,'type','Spearman');
        corr_Y_X(isnan(corr_Y_X)==1) = 0;%change the 'NaN' value to '0':
        [WEIGHT,RANKED] = sort(abs(corr_Y_X),'descend');


end

