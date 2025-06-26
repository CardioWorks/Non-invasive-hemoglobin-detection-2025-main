function [error_code,PPG_Loc,VPG_Loc,APG_Loc] = ppg_point_extraction1(error_code,ppg,vpg,apg,third_block)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ppg_point_extraction.m
% Identify and extract the feature points from PPG, VPG and APG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Input:
%error_code----Extracted PPG feature points or not.(0:YES, nonZero:NO)
%sample_time----The sample time of PPG signal
%ppg----PPG waveform of two adjacent heartbeat cycles
%vpg----VPG waveform of two adjacent heartbeat cycles
%apg----APG waveform of two adjacent heartbeat cycles

%% Output:
%error_code----Updated error code for calculation.(0:YES, 1:NO)
%PPG_Loc----The location of PPG feature points
%VPG_Loc----The location of VPG feature points
%APG_Loc----The location of APG feature points

%% Notes: ppg features points location
% They are respectively as below:
%¡¾O¡¿¡¾S¡¿¡¾N¡¿¡¾D¡¿¡¾O_next¡¿in PPG
%¡¾w¡¿¡¾y¡¿¡¾z¡¿¡¾w_next¡¿ in VPG
%¡¾a¡¿¡¾b¡¿¡¾c¡¿¡¾d¡¿¡¾e¡¿¡¾b2¡¿ in APG

%%%%%%
max_num = length(ppg)-1;

%% Error Report Mechanism
% Give each point a initial value(nonZero)
%and the value can be used to check the pass_or_fail status of PPG feature points extraction
num_O = 1;
num_S = 2;
num_N = 3;
num_D = 4;
num_O_next = 5;

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

PPG_Loc = zeros(5);
VPG_Loc = zeros(4);
APG_Loc = zeros(6);

%% STEP1----[a: error code = 21]Find 'a' location from APG: num_a
if error_code == 0
    [a_peak,a_peak_loc] = find_peaks(apg,0.5);
    mean_a_peak = mean(a_peak(2:length(a_peak)));
    
    if (a_peak(1)- mean_a_peak)/mean_a_peak > 0.4
        num_a = a_peak_loc(2);
    else
        num_a = find_max(num_a,101,fix(max_num/2),apg);
    end
    
    error_code = ppg_error_report(num_a);
end

%% STEP2----[O: error code = 1]Find 'O' location from VPG(zero-crossing point£ºright to left)£ºnum_O
if error_code == 0
    for i = num_a : -1 : 2
        if vpg(i)*vpg(i-1) < 0
            num_O = i;
            break;
        end
    end
    
    error_code = ppg_error_report(num_O);
end

%% STEP3----[w: error code = 11]Find 'w' location from APG(zero-crossing point):num_w
if error_code == 0
    num_w = find_down_zero(num_w,num_a,max_num,apg);
    error_code = ppg_error_report(num_w);
end

%% STEP4----[S: error code = 2]Find 'S' location from VPG(zero-crossing point):num_S
if error_code == 0
    num_S = find_down_zero(num_S,num_w,max_num,vpg);
    error_code = ppg_error_report(num_S);
end

%% STEP5----[y: error code = 12]Find 'y' location from VPG(local minimum value):num_y
if error_code == 0
    num_y = find_min(num_y,num_S,num_S+400,vpg);
    error_code = ppg_error_report(num_y);
end

%% STEP6----[b: error code = 22]Find 'b' location from third derivate(zero-crossing point):num_b
if error_code == 0
    num_b = find_up_zero(num_b,num_w,max_num,third_block);
    error_code = ppg_error_report(num_b);
end

%% STEP7----[c: error code = 23]Find 'c' and 'd' location from third derivate(zero-crossing point):num_c and num_d
if error_code == 0
    num_c = find_down_zero(num_c,num_b,max_num,third_block);
    num_d = find_up_zero(num_d,num_c,max_num,third_block);
    
    %adjust one or two peak of third_block in b--c interval
    [pks,locs] = findpeaks(third_block(num_b:num_c));
    
    locs = locs + num_b;
    if length(locs) ~= 1
        num_c = find_min(num_c,locs(1),locs(2),third_block);
        num_d = fix((num_c+locs(2))/2);
    end
    
    error_code = ppg_error_report(num_c);
end

%% STEP8----[e: error code = 25]Find 'e' location from third derivate(zero-crossing point): num_e
if error_code == 0
    num_e = find_down_zero(num_e,num_d,max_num,third_block);
    error_code = ppg_error_report(num_e);
end

%% STEP9----[z: error code = 13]Find 'z' location from APG(zero-crossing point):num_z
if error_code == 0
    num_z = find_down_zero(num_z,num_e,max_num,apg);
    error_code = ppg_error_report(num_z);
end

%% STEP10----[N: error code = 3]Find 'N' location from VPG(zero-crossing point):num_N
if error_code == 0
    if vpg(num_z) > 0    %above 0
        num_N = find_up_zero(num_N,num_e,num_z,vpg);
    else
        num_N =num_e + fix((num_z - num_e)/2);
    end
    
    error_code = ppg_error_report(num_N);
end

%% STEP11----[D: error code = 4]Find 'D' location from VPG(zero-crossing point):num_D
if error_code == 0
    if vpg(num_z) > 0    %above 0
        num_D = find_down_zero(num_D,num_z,max_num,vpg);
    else
        num_D =num_z + fix((num_z - num_e)/2);
    end
    
    error_code = ppg_error_report(num_D);
end

%% STEP12----[a_next and w_next]Find 'a_next' and 'w_next' :num_a_next, num_w_next
if error_code == 0
    for k =1:1:length(a_peak)
        if a_peak_loc(k) == num_a && length(a_peak) > 1 && k ~= length(a_peak)
            num_a_next = a_peak_loc(k+1);
            break;
        end
    end
    
    error_code = ppg_error_report(num_a_next);
end

if error_code == 0
    num_w_next = find_down_zero(num_w_next,num_a_next,max_num,apg);
    error_code = ppg_error_report(num_w_next);
end

%% STEP13----[O_next: error code = 5]Find 'O_next' location from VPG(zero-crossing point):num_O_next
% %search 'O_next' from right to left
if error_code == 0
    for i = num_a_next : -1 : 2
        if vpg(i)*vpg(i-1) < 0
            num_O_next = i;
            break;
        end
    end
    
    error_code = ppg_error_report(num_O_next);
end

%% STEP14----[b2: error code = 19]Find 'b2' from PPG:num_b2
if error_code == 0
    num_b2 = num_d;
    for j= num_S : num_N
        if abs(ppg(j) - ppg(num_b)) < 0.02
            num_b2=j;
            break;
        end
        num_b2 = num_d;
    end

    error_code = ppg_error_report(num_b2);
end

%% PPG Feature Point Location
if error_code == 0
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
    APG_Loc(6) = num_b2;
end
end

function flag_search = ppg_error_report(initial_value)
if initial_value > 0 && initial_value < 30
    flag_search = initial_value;
else
    flag_search = 0;
end
end

function [num_point] = find_up_zero(num_point,num_start,num_end,data)
for j = num_start : num_end
    if data(j) < 0
        j;
        break;
    end
end
%find the up slope zero, find the negative value as start firstly.

for i = j : num_end
    if data(i)*data(i+1) < 0
        num_point=i;
        break;
    end
end
num_point;
end

function [num_point] = find_down_zero(num_point,num_start,num_end,data)
for j = num_start : num_end
    if data(j) > 0
        break;
    end
end
%find the down slope zero, first find the positive value as start firstly.

for i = j : num_end
    if data(i)*data(i+1) < 0
        num_point=i;
        break;
    end
end
end

function [num_point]=find_max(num_point,num_start,num_end,data)
temp = data(num_start);
for i = num_start:num_end
    if temp <= data(i)
        temp = data(i);
        num_point = i;
    end
end
end

function [num_point] = find_min(num_point,num_start,num_end,data)
temp = data(num_start);
for i = num_start:num_end
    if temp >= data(i)
        temp = data(i);
        num_point = i;
    end
end
end

function [maxv,maxl] = find_peaks(data,ratio)
[num_max]=find_max(0,1,floor(length(data)/2),data);
threshold_height = ratio*data(num_max);

[maxv,maxl] = findpeaks(data,'MinPeakHeight',threshold_height);
end