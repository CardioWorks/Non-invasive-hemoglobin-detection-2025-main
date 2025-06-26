function [error_code,PPG_Loc,VPG_Loc,APG_Loc] = ppg_point_extraction(num_onset,num_mid,num_offset,ppg_block,vpg_block,apg_block,third_block)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ppg_point_extract.m
% Identify and extract the feature points from PPG, VPG and APG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sample_time = 0.005;
max_num = num_offset-1;
min_edge_num = num_onset+1;
%% 4--ppg features points search process
% They are respectively as below:
%【S】【O】【D】【N】【O_next】
%【f】【w】【y】【z】【w_next】
%【a】【b】【c】【d】【a_next】

%% Add the error report process
% Give every point num a initial value and the value can be used to check the pass_or_fail status
num_O = 1;
num_S = 2;
num_N = 3;
num_D = 4;
num_O_next = 5;

num_x = 6;
num_w = 7;
num_y = 8;
num_z = 9;
num_w_next=10;

num_f = 11;
num_a = 12;
num_b = 13;
num_c = 14;
num_d = 15;
num_e = 16;
num_a_next = 17;

PPG_Loc(5) = [0];
VPG_Loc(5) = [0];
APG_Loc(7) = [0];

%% 【a: error code = 21】find the first peak of the two wave: num_a
    num_a = find_max(0,fix((num_onset+num_mid)/2),num_mid,apg_block);

    [pks,locs] = findpeaks(apg_block(num_a:num_mid));

    locs = max(locs) + num_a-1;
    
    if length(locs) >= 1
        num_a = locs;
    end
    
%% 【w: error code = 11】w point
    num_w = find_down_zero(num_w,num_a,max_num,apg_block);
    
 %% 【S: error code = 2】S point
    num_S = find_down_zero(num_S,num_w,max_num,vpg_block);
    
%% 【O: error code = 1】find num_O from num_a to 1[from right to left]---O point
    for i = num_w : -1 : min_edge_num
        if vpg_block(i)*vpg_block(i-1) < 0
            num_O = i;
            break;
        end
    end
     
%% 【b: error code = 22】b point
    num_b = find_up_zero(num_b,num_w,max_num,third_block);
    
 %% 【num_a_next】
    num_a_next = find_max(0,num_mid,max_num,apg_block);

%% 【y: error code = 12】y point
    num_y = find_min(num_y,num_w,num_mid+fix((num_offset-num_mid)/3),vpg_block);

  %% 【z: error code = 13】Find 'z' location from APG(zero-crossing point):num_z
    num_z = find_down_zero(num_z,num_y,max_num,apg_block);
    
%% 【N: error code = 3】N point
    if vpg_block(num_z) > 0    %above 0
        num_N = find_up_zero(num_N,num_S,num_z,vpg_block);
    else
        num_N =num_e + fix((num_z - num_e)/2);
    end
    
%% 【D: error code = 4】Find 'D' location from VPG(zero-crossing point):num_D
    if vpg_block(num_z) > 0    %above 0
        num_D = find_down_zero(num_D,num_N,max_num,vpg_block);
    else
        num_D =num_z + fix((num_z - num_e)/2);
    end
    
%% 【c and d: error code = 23】c point and d point
    num_c = find_down_zero(num_c,num_b,max_num,third_block);
    num_d = find_up_zero(num_d,num_c,max_num,third_block);

%     adjust one or two peak of third_block in b--c interval
    if length(third_block(num_b:num_c)) < 3
        num_b = find_min(num_b,num_b,num_b-6,apg_block);
        num_c = find_max(num_c,num_c,num_c+6,apg_block);
    end

    [pks,locs] = findpeaks(third_block(num_b:num_c));
    
    locs = locs + num_b;
    if length(locs) > 1
        num_c = find_min(num_c,locs(1),locs(2),third_block);
        num_d = fix((num_c+locs(2))/2);
    end

    if num_d > num_N && length(locs) == 1
        num_c = locs(1)-fix((num_c-locs(1))/2);
        num_d = locs(1)+fix(abs(num_c-locs(1))/2);
    end
%% STEP8----[e: error code = 25]Find 'e' location from third derivate(zero-crossing point): num_e
    num_e = find_down_zero(num_e,num_d,max_num,third_block);

%% 【num_x】
    for i = num_w-1 : -1 : min_edge_num
        if apg_block(i)*apg_block(i-1) < 0
            num_x = i;
            break;
        end
    end
   
%% 【num_f】
    for i = num_a-1 : -1 : min_edge_num
        if third_block(i)*third_block(i-1) < 0
            num_f = i;
            break;
        end
    end
    
%% 【w_next】w_next point
    num_w_next = find_max(num_w_next,num_a_next,max_num,vpg_block);
    
%% 【O_next: error code = 5】O_next point
% %search from right to left
    for i = num_w_next : -1 : num_mid
        if vpg_block(i)*vpg_block(i-1) < 0
            num_O_next = i;
            break;
        end
    end
    
%%
%     num_S=find_max(num_S,num_S-5,num_S+5,ppg_block);
%     num_O=find_min(num_O,num_O-5,num_O+5,ppg_block);
%     
%     num_w=find_max(num_w,num_w-5,num_w+5,vpg_block);
%     num_y=find_min(num_y,num_y-5,num_y+5,vpg_block);
%     num_z=find_max(num_z,num_z-5,num_z+5,vpg_block);
%     num_x=find_min(num_x,num_x-5,num_x+5,vpg_block);
%     num_w_next=find_max(num_w_next,num_w_next-5,num_w_next+5,vpg_block);
%     
%     num_a=find_max(num_a,num_a-5,num_a+5,apg_block);
%     num_b=find_min(num_b,num_b-5,num_b+5,apg_block);
%     num_c=find_max(num_c,num_c-5,num_c+5,apg_block);
%     num_d=find_min(num_d,num_d-5,num_d+5,apg_block);
%     num_e=find_max(num_e,num_e-5,num_e+5,apg_block);
%     num_f=find_min(num_f,num_f-5,num_f+5,apg_block);
%     num_a_next=find_max(num_a_next,num_a_next-5,num_a_next+5,apg_block);
%% PPG Feature Point Location
    PPG_Loc(1) = num_O;
    PPG_Loc(2) = num_S;
    PPG_Loc(3) = num_N;
    PPG_Loc(4) = num_D;
    PPG_Loc(5) = num_O_next;
    
    VPG_Loc(1) = num_x;
    VPG_Loc(2) = num_w;
    VPG_Loc(3) = num_y;
    VPG_Loc(4) = num_z;
    VPG_Loc(5) = num_w_next;
    
    APG_Loc(1) = num_f;
    APG_Loc(2) = num_a;
    APG_Loc(3) = num_b;
    APG_Loc(4) = num_c;
    APG_Loc(5) = num_d;
    APG_Loc(6) = num_e;
    APG_Loc(7) = num_a_next;
%% 检查特征点位置是否正确
%% Check feature point position correct or not
    if  isempty(find(PPG_Loc<0)) && isempty(find(VPG_Loc<0)) &&...
            isempty(find(APG_Loc<0)) &&...
            num_f <= num_a && num_a <=num_b && num_b <= num_c && num_c <= num_d && num_d <= num_e && num_e <= num_a_next &&...
            num_x <= num_w && num_w <= num_y && num_y <= num_z && num_z <= num_w_next &&...
            num_O <= num_S && num_S <= num_N && num_N <= num_D && num_D <= num_O_next &&...
            num_a <= num_w && num_w <= num_S &&...
            0.2<=(num_O_next-num_O)*sample_time && (num_O_next-num_O)*sample_time <= 2
        error_code = 0;
    else
        error_code = 19;
    end
end