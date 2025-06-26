function [error_code,ECG_Loc,PPG_Loc,VPG_Loc,APG_Loc] = ecg_ppg_point_extraction(error_code,num_onset,num_mid,num_offset,ppg_block,vpg_block,apg_block,third_block,num_SS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ppg_point_extract.m
% Identify and extract the feature points from PPG, VPG and APG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%
sample_time = 0.008;
max_num = num_offset-1;
min_edge_num = num_onset+1;

%% 4--ppg features points search process
% They are respectively as below:
%¡¾R¡¿¡¾R_next¡¿
%¡¾O¡¿¡¾S¡¿¡¾N¡¿¡¾D¡¿¡¾O_next¡¿
%¡¾w¡¿¡¾y¡¿¡¾z¡¿¡¾w_next¡¿
%¡¾a¡¿¡¾b¡¿¡¾c¡¿¡¾d¡¿¡¾e¡¿¡¾a_next¡¿¡¾b2¡¿

%% Add the error report process
% Give every point num a initial value and the value can be used to check the pass_or_fail status
num_O = 1;
num_S = 2;
num_N = 3;
num_D = 4;
num_O_next = 5;
%num_S_next = 6;
num_R = 7;
num_R_next = 8;

num_w = 11;
num_y = 12;
num_z = 13;
num_w_next = 14;

num_a = 21;
num_b = 22;
num_c = 23;
num_d = 24;
num_e = 25;
num_a_next = 26;
num_b2 = 27;

ECG_Loc(2) = [0];
PPG_Loc(5) = [0];
VPG_Loc(4) = [0];
APG_Loc(7) = [0];

%% ¡¾PPG SQI: error_code = 17¡¿
if error_code == 0
    S_SQI = ppg_sqi(ppg_block(num_onset:num_offset));
    if S_SQI <= 0
        error_code = 17;
    end
end

%% ¡¾R: error code = 7¡¿
if error_code == 0
    num_R = num_onset;   %R
    error_code = ppg_error_report(7,num_R);
end

%% ¡¾R_next: error code = 8¡¿
if error_code == 0
    num_R_next = num_mid; %R_next
    
    if 2 < (num_R_next - num_R)*sample_time || (num_R_next - num_R)*sample_time < 0.2
        error_code = 8;
    else
        error_code = ppg_error_report(8,num_R_next);
    end
end

%% ¡¾a: error code = 21¡¿find the first peak of the two wave: num_a
if error_code == 0
    num_a = find_max(0,num_SS,fix(num_mid+num_offset)/2,apg_block);  %a
    error_code = ppg_error_report(21,num_a);
end

%% ¡¾w: error code = 11¡¿w point
if error_code == 0
    num_w = find_down_zero(num_w,num_a,max_num,apg_block);
    error_code = ppg_error_report(11,num_w);
end

%% ¡¾S: error code = 2¡¿S point
if error_code == 0
    num_S = find_down_zero(num_S,num_w,max_num,vpg_block);
    error_code = ppg_error_report(2,num_S);
end

%% ¡¾O: error code = 1¡¿find num_O from num_a to 1[from right to left]---O point
if error_code == 0
    for i = num_S : -1 : min_edge_num
        if vpg_block(i)*vpg_block(i-1) < 0
            num_O = i;
            break;
        end
    end
    
    error_code = ppg_error_report(1,num_O);
end

%% ¡¾y: error code = 12¡¿y point
if error_code == 0
    num_y = find_min(num_y,num_w,fix(num_mid+num_offset)/2,vpg_block);
    error_code = ppg_error_report(12,num_y);
end

%% ¡¾b: error code = 22¡¿b point
if error_code == 0
    num_b = find_up_zero(num_b,num_w,max_num,third_block);
    error_code = ppg_error_report(22,num_b);
end

%% ¡¾c and d: error code = 23¡¿c point and d point
if error_code == 0
    num_c = find_down_zero(num_c,num_b,max_num,third_block);
    num_d = find_up_zero(num_d,num_c,max_num,third_block);
    
    %adjust one or two peak of third_block in b--c interval : obtain correct c point position
    if (num_c - num_b)*sample_time > 16*sample_time
        [~,locs] = findpeaks(third_block(num_b:num_c));
        
        locs = locs + num_b;
        if length(locs) > 1
            num_c = find_min(num_c,locs(1),locs(2),third_block);
            num_d = fix((num_c+locs(2))/2);
        end
    end
    
    error_code = ppg_error_report(23,num_c);
end

%% ¡¾e: error code = 25¡¿e point
if error_code == 0
    num_e = find_down_zero(num_e,num_d,max_num,third_block);
    error_code = ppg_error_report(25,num_e);
end

%% ¡¾z: error code = 13¡¿z point
if error_code == 0
    num_z = find_down_zero(num_z,num_e,max_num,apg_block);
    
    error_code = ppg_error_report(13,num_z);
end

%% ¡¾N: error code = 3¡¿N point
if error_code == 0
    if vpg_block(num_z) > 0    %above 0
        num_N = find_up_zero(num_N,num_e,num_z,vpg_block);
    else
        num_N = fix((num_e+num_z)/2);
    end
    
    error_code = ppg_error_report(3,num_N);
end

%% ¡¾D: error code = 4¡¿Dµã
if error_code == 0
    if vpg_block(num_z) > 0    %above 0
        num_D = find_down_zero(num_D,num_z,max_num,vpg_block);
    else
        num_D = num_z+abs(num_z-num_N);
    end
    
    error_code = ppg_error_report(4,num_D);
end

%% ¡¾a_next and w_next¡¿w_next
% find a_next firstly
if error_code == 0
    num_a_next = find_max(0,num_R_next,num_offset,apg_block);  %a_next
    error_code = ppg_error_report(26,num_a_next);
end

if error_code == 0
    num_w_next = find_down_zero(num_w_next,num_a_next,max_num,apg_block);
    error_code = ppg_error_report(11,num_w_next);
end

%% ¡¾O_next: error code = 5¡¿O_next point
% %search from right to left
if error_code == 0
    for i = num_a_next : -1 : num_R
        if vpg_block(i)*vpg_block(i-1) < 0
            num_O_next = i;
            break;
        end
    end
    
    error_code = ppg_error_report(5,num_O_next);
end

%% ¡¾S_next: error code = 6¡¿
%Discard S_next point extraction
% if error_code == 0
%     num_S_next = find_down_zero(num_S_next,num_w_next,max_num-1,vpg_block);
%
%     error_code = ppg_error_report(6,num_S_next);
% end

%% ¡¾b2: error code = 27¡¿ b2 point
if error_code == 0
    num_b2 = num_d;
    for j= num_S : num_N
        if abs(ppg_block(j) - ppg_block(num_b)) < 0.02
            num_b2=j;
            break;
        end
        num_b2 = num_d;
    end
    error_code = ppg_error_report(27,num_b2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PPG Feature Point Location
if error_code == 0
    ECG_Loc(1) = num_R;
    ECG_Loc(2) = num_R_next;
    
    PPG_Loc(1) = num_O;
    PPG_Loc(2) = num_S;
    PPG_Loc(3) = num_N;
    PPG_Loc(4) = num_D;
    PPG_Loc(5) = num_O_next;
    
    VPG_Loc(1) = num_w;
    VPG_Loc(2) = num_y;
    VPG_Loc(3) = num_z;
    VPG_Loc(4) = num_w_next;
    
    APG_Loc(1) = num_a;
    APG_Loc(2) = num_b;
    APG_Loc(3) = num_c;
    APG_Loc(4) = num_d;
    APG_Loc(5) = num_e;
    APG_Loc(6) = num_a_next;
    APG_Loc(7) = num_b2;
    
    %% Check feature point position correct or not
    if  isempty(find(ECG_Loc<0)) && isempty(find(PPG_Loc<0)) && isempty(find(VPG_Loc<0)) &&...
            isempty(find(APG_Loc<0)) && num_R < num_R_next &&...
            num_R < num_O && num_O < num_a && num_a < num_w &&...
            num_w < num_b && num_b < num_S && num_S < num_N &&...
            num_w < num_y && num_a < num_b && num_b < num_c && num_c < num_e &&...
            0.2<(num_O_next-num_O)*sample_time && (num_O_next-num_O)*sample_time < 2
        error_code;
    else
        error_code = 19;
    end
end

end
%% stop here: 4
