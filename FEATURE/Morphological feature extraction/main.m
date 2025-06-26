clear
clc
  %%
  path.data = '.\DATA\';
  path.save = '.\OUTPUT\';
  addpath (genpath('.\CODE\')) 
  %%
  List = dir(strcat(path.data,'*.mat'));
  for J=1:(length(List)-2)
  id=[List(J).name];
  id=str2num(id(isstrprop(id,'digit')));
  load(strcat(path.data,List(J).name))
  load(strcat(path.data,'F1_F2_F3_F4'))
  load(strcat(path.data,'value'))
  
  %% 
    wave_1.ppg = zscore(data.channel_1)';
    wave_2.ppg = zscore(data.channel_2)';
    wave_3.ppg = zscore(data.channel_3)';
    wave_4.ppg = zscore(data.channel_4)';

  %% 
    wave_1.ppg = Matrix_adjust(wave_1.ppg);
    wave_2.ppg = Matrix_adjust(wave_2.ppg);
    wave_3.ppg = Matrix_adjust(wave_3.ppg);
    wave_4.ppg = Matrix_adjust(wave_4.ppg);

    %% extracting PPG P wave
    [PPG_P.Loc_1,~] = msptd_beat_detector(wave_1.ppg,200);
    [PPG_P.Loc_2,~] = msptd_beat_detector(wave_2.ppg,200);
    [PPG_P.Loc_3,~] = msptd_beat_detector(wave_3.ppg,200);
    [PPG_P.Loc_4,~] = msptd_beat_detector(wave_4.ppg,200);
    [PPG_P.Loc_1,PPG_P.Loc_2,PPG_P.Loc_3,PPG_P.Loc_4] = Loc_adjust(PPG_P.Loc_1,PPG_P.Loc_2,PPG_P.Loc_3,PPG_P.Loc_4);
%     %Loc_A = PPG_P.Loc_1;Loc_B = PPG_P.Loc_2;Loc_C = PPG_P.Loc_3;Loc_D = PPG_P.Loc_4;
    %%
   [wave_1.vpg,wave_1.apg,wave_1.third,wave_1.fourth] = multi_derivative(wave_1.ppg);
    wave_1.vpg = zscore(wave_1.vpg);
    wave_1.apg = zscore(wave_1.apg);
    wave_1.third = zscore(wave_1.third);
    wave_1.fourth = zscore(wave_1.fourth);
    
    [wave_2.vpg,wave_2.apg,wave_2.third,wave_2.fourth] = multi_derivative(wave_2.ppg);
    wave_2.vpg = zscore(wave_2.vpg);
    wave_2.apg = zscore(wave_2.apg);
    wave_2.third = zscore(wave_2.third);
    wave_2.fourth = zscore(wave_2.fourth);
    
    [wave_3.vpg,wave_3.apg,wave_3.third,wave_3.fourth] = multi_derivative(wave_3.ppg);
    wave_3.vpg = zscore(wave_3.vpg);
    wave_3.apg = zscore(wave_3.apg);
    wave_3.third = zscore(wave_3.third);
    wave_3.fourth = zscore(wave_3.fourth);
    
    [wave_4.vpg,wave_4.apg,wave_4.third,wave_4.fourth] = multi_derivative(wave_4.ppg);
    wave_4.vpg = zscore(wave_4.vpg);
    wave_4.apg = zscore(wave_4.apg);
    wave_4.third = zscore(wave_4.third);
    wave_4.fourth = zscore(wave_4.fourth);
    %%
    F1=num(id,2);
    F2=num(id,3);
    F43=num(id,4);
    F44=num(id,5);
    val=value(id,2);
%%channel_1
error_count = 0;
error_beat = 0;
    for beat =1:1:(length(PPG_P.Loc_1)-2)
    %% PPG feature points were extracted beat by beat
        [error_code,Loc_1.PPG,Loc_1.VPG,Loc_1.APG] = ppg_point_extraction(PPG_P.Loc_1(beat),PPG_P.Loc_1(beat+1),PPG_P.Loc_1(beat+2),wave_1.ppg,wave_1.vpg,wave_1.apg,wave_1.third);
     %num_onset=PPG_P.Loc_1(beat);num_mid=PPG_P.Loc_1(beat+1);num_offset=PPG_P.Loc_1(beat+2);ppg_block=wave.ppg;vpg_block=wave.vpg;apg_block=wave.apg;third_block=wave.third;
    %% calculate feature: ECG and PPG Feature Calculation
        if error_code == 0    
        [subject_feature_A(beat,:)] = ppg_feature_calculation_A(Loc_1.PPG,Loc_1.VPG,Loc_1.APG,wave_1.ppg,wave_1.vpg,wave_1.apg,F1,F2,F43,F44,val,id,PPG_P.Loc_1(beat),PPG_P.Loc_1(beat+2));
    %PPG_Loc=Loc_1.PPG;VPG_Loc=Loc_1.VPG;APG_Loc=Loc_1.APG;ppg=wave_1.ppg;vpg=wave_1.vpg;apg=wave_1.apg;num_onset=PPG_P.Loc_1(beat);num_offset=PPG_P.Loc_1(beat+2);
        else
        subject_feature_A(beat,:) = zeros(1,106);
     %Record error beat
        error_count = error_count+1;
        error_beat(error_count)=beat;
        end
    end
%%channel_2
    for beat =1:1:(length(PPG_P.Loc_2)-2)
    %% PPG feature points were extracted beat by beat
        [error_code,Loc_2.PPG,Loc_2.VPG,Loc_2.APG] = ppg_point_extraction(PPG_P.Loc_2(beat),PPG_P.Loc_2(beat+1),PPG_P.Loc_2(beat+2),wave_2.ppg,wave_2.vpg,wave_2.apg,wave_2.third);
    %% calculate feature: ECG and PPG Feature Calculation
        if error_code == 0
        [subject_feature_B(beat,:)] = ppg_feature_calculation(Loc_2.PPG,Loc_2.VPG,Loc_2.APG,wave_2.ppg,wave_2.vpg,wave_2.apg,PPG_P.Loc_1(beat),PPG_P.Loc_1(beat+2));
        else
        subject_feature_B(beat,:) = zeros(1,100);
        error_count = error_count+1;
        error_beat(error_count)=beat;
        end
    end
%%channel_3
    for beat =1:1:(length(PPG_P.Loc_3)-2)
    %% PPG feature points were extracted beat by beat
        [error_code,Loc_3.PPG,Loc_3.VPG,Loc_3.APG] = ppg_point_extraction(PPG_P.Loc_3(beat),PPG_P.Loc_3(beat+1),PPG_P.Loc_3(beat+2),wave_3.ppg,wave_3.vpg,wave_3.apg,wave_3.third);
    %% calculate feature: ECG and PPG Feature Calculation
        if error_code == 0
        [subject_feature_C(beat,:)] = ppg_feature_calculation(Loc_3.PPG,Loc_3.VPG,Loc_3.APG,wave_3.ppg,wave_3.vpg,wave_3.apg,PPG_P.Loc_1(beat),PPG_P.Loc_1(beat+2));
        else
        subject_feature_C(beat,:) = zeros(1,100);
        error_count = error_count+1;
        error_beat(error_count)=beat;
        end
    end
%%channel_4
    for beat =1:1:(length(PPG_P.Loc_4)-2)
    %% PPG feature points were extracted beat by beat
        [error_code,Loc_4.PPG,Loc_4.VPG,Loc_4.APG] = ppg_point_extraction(PPG_P.Loc_4(beat),PPG_P.Loc_4(beat+1),PPG_P.Loc_4(beat+2),wave_4.ppg,wave_4.vpg,wave_4.apg,wave_4.third);
    %% calculate feature: ECG and PPG Feature Calculation
        if error_code == 0
        [subject_feature_D(beat,:)] = ppg_feature_calculation(Loc_4.PPG,Loc_4.VPG,Loc_4.APG,wave_4.ppg,wave_4.vpg,wave_4.apg,PPG_P.Loc_1(beat),PPG_P.Loc_1(beat+2));
        else
        subject_feature_D(beat,:) = zeros(1,100);
        error_count = error_count+1;
        error_beat(error_count)=beat;
        end
    end

   subject_feature=[subject_feature_A subject_feature_B subject_feature_C subject_feature_D]; 
   clear subject_feature_A subject_feature_B subject_feature_C subject_feature_D

   %% 
   if error_beat ~= 0
    error_beat = sort(unique(error_beat),'descend');%The error beat is sorted in descending order
    subject_feature(error_beat,:)=[];%Delete the line with the error beat
   end

   subject_Feature = trimmean(subject_feature,40);

    if J == 1
     subject_feature_87 = subject_Feature;
    else
    subject_feature_87 = [subject_feature_87;subject_Feature];
    end
    subject_feature_87 = sortrows(subject_feature_87,1);
% save(strcat(path.save,[List(J).name]),'subject_feature')
  end
  %%csvwrite(strcat(path.save,'data.csv'),PPGdata.data)
   csvwrite(strcat(path.save,'subject_feature.csv'),subject_feature_87)%The file is saved in csv format