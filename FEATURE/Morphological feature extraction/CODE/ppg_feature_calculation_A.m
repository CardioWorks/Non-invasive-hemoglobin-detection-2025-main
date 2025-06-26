function[subject_feature] = ppg_feature_calculation_A(PPG_Loc,VPG_Loc,APG_Loc,ppg,vpg,apg,F1,F2,F43,F44,val,id,num_onset,num_offset)
%% initial value
sample_time = 0.005;

%% point address
num_O = PPG_Loc(1);
num_S = PPG_Loc(2);
num_N = PPG_Loc(3);
num_D = PPG_Loc(4);
num_O_next = PPG_Loc(5);

num_x = VPG_Loc(1);
num_w = VPG_Loc(2);
num_y = VPG_Loc(3);
num_z = VPG_Loc(4);
num_w_next=VPG_Loc(5);

num_f = APG_Loc(1);
num_a = APG_Loc(2);
num_b = APG_Loc(3);
num_c = APG_Loc(4);
num_d = APG_Loc(5);
num_e = APG_Loc(6);
num_a_next = APG_Loc(7);
%% ppg features calculation

%%振幅
%PPG
I_SO = ppg(num_S)-ppg(num_O);%1
I_NO = ppg(num_N)-ppg(num_O);%2
I_DO = ppg(num_D)-ppg(num_O);%3

%VPG
x = vpg(num_x);%4
w = vpg(num_w);%5
y = vpg(num_y);%6
z = vpg(num_z);%7
I_wx = vpg(num_w)-vpg(num_x);%8
I_wy = vpg(num_w)-vpg(num_y);%9

%APG
a = apg(num_a);%10
b = apg(num_b);%11
c = apg(num_c);%12
d = apg(num_d);%13
e = apg(num_e);%14
f = apg(num_f);%15
I_af = apg(num_a)-apg(num_f);%16
I_ab = apg(num_a)-apg(num_b);%17
I_ac = apg(num_a)-apg(num_c);%18
I_cb = apg(num_c)-apg(num_b);%19

%VPG、APG points on PPG
I_aO = ppg(num_a)-ppg(num_O);%20
I_wO = ppg(num_w)-ppg(num_O);%21
I_bO = ppg(num_b)-ppg(num_O);%22
I_cO = ppg(num_c)-ppg(num_O);%23
I_yO = ppg(num_y)-ppg(num_O);%24
I_O2O = ppg(num_O_next)-ppg(num_O);%25
I_zO = ppg(num_z)-ppg(num_O);%26

%%振幅之比
%PPG
R1 = I_DO/I_SO;%27
R2 = I_NO/I_SO;%28

%%时间跨度
%PPG
T_O2O = (num_O_next-num_O)*sample_time;%29
T_SO = (num_S-num_O)*sample_time;%30
T_NO = (num_N-num_O)*sample_time;%31
T_DO = (num_D-num_O)*sample_time;%32
T_SD = (num_S-num_D)*sample_time;%33

[num_N2] = find_sameheight(0,num_S,(ppg(num_S)-ppg(num_N)),ppg);
T_NN2 = (num_N-num_N2)*sample_time;%34

%VPG
T_zw = (num_z-num_w)*sample_time;%35
T_yw = (num_y-num_w)*sample_time;%36
T_wx = (num_w-num_x)*sample_time;%37
T_w2w = (num_w_next-num_w)*sample_time;%38

%APG
T_af = (num_a-num_f)*sample_time;%39
T_ba = (num_b-num_a)*sample_time;%40
T_ca = (num_c-num_a)*sample_time;%41
T_da = (num_d-num_a)*sample_time;%42
T_ea = (num_e-num_a)*sample_time;%43
T_a2a = (num_a_next-num_a)*sample_time;%44

%VPG、APG points on PPG
T_aO = (num_a-num_O)*sample_time;%45
T_wO = (num_w-num_O)*sample_time;%46
T_bO = (num_b-num_O)*sample_time;%47
T_yO = (num_y-num_O)*sample_time;%48
T_cO = (num_c-num_O)*sample_time;%49

%时间跨度之比
%PPG
R3 = T_SO/T_O2O;%50
R4 = T_NO/T_O2O;%51
R5 = T_DO/T_O2O;%52
R6 = T_SD/T_O2O;%53

%%Wdith
%PPG
[num_r25] = find_sameheight(0,num_S,(ppg(num_S)-ppg(num_O))/4*3,ppg);
r25 = (num_S-num_r25)*sample_time;%54

[num_r50] = find_sameheight(0,num_S,(ppg(num_S)-ppg(num_O))/4*2,ppg);
r50 = (num_S-num_r50)*sample_time;%55

[num_r75] = find_sameheight(0,num_S,(ppg(num_S)-ppg(num_O))/4,ppg);
r75 = (num_S-num_r75)*sample_time;%56

[num_d25] = find_sameheight(1,num_S,(ppg(num_S)-ppg(num_O_next))/4*3,ppg);
d25 = (num_S-num_d25)*sample_time;%57

[num_d50] = find_sameheight(1,num_S,(ppg(num_S)-ppg(num_O_next))/4*2,ppg);
d50 = (num_S-num_d50)*sample_time;%58

[num_d75] = find_sameheight(1,num_S,(ppg(num_S)-ppg(num_O_next))/4,ppg);
d75 = (num_S-num_d75)*sample_time;%59

[num_M2] = find_sameheight(1,num_S,(ppg(num_S)-ppg(num_w)),ppg);
PW = (num_M2-num_w)*sample_time;%60

%%area
%PPG
V = area_calculate(ppg(num_O),num_O,num_O_next,ppg);%61
V1 = area_calculate(ppg(num_O),num_O,num_S,ppg);%62
V2 = area_calculate(ppg(num_O_next),num_S,num_O_next,ppg);%63
A1 = area_calculate(ppg(num_O),num_O,num_N,ppg);%64
A2 = area_calculate(ppg(num_O_next),num_O,num_N,ppg);%65

%rate of area
R7 = A2/A1;%66
R8 = V2/V1;%67
R9 = V1/V;%68
R10 = A1/V;%69
R11 = A2/V;%70

%%slope
%PPG
s1 = I_SO/T_SO;%71
s2 = I_SO/(T_O2O-T_SO);%72
s3 = I_DO/(T_O2O-T_DO);%73
s4 = I_wO/T_wO;%74
s5 = (ppg(num_M2)-ppg(num_O_next))/((num_O_next-num_M2)*sample_time);%75

%VPG
s6 = I_wx/T_wx;%76
s7 = I_wy/T_yw;%77

%APG
s8 = I_af/T_af;%78
s9 = I_ab/T_ba;%79

%%特征值
Pm = V/(num_O_next-num_O);
k = (Pm-ppg(num_O))/(ppg(num_S)-ppg(num_O));%80

Pm1 = A1/(num_N-num_O);
k1 = (Pm1-ppg(num_O))/(ppg(num_S)-ppg(num_O));%81

Pm2 = A2/(num_O_next-num_N);
k2 = (Pm2-ppg(num_O))/(ppg(num_S)-ppg(num_O));%82
%%
%频域特征
[FDF] = fre_feature_calculation(ppg,num_onset,num_offset);
%%
ppg_feature(1) = I_SO;
ppg_feature(2) = I_NO;
ppg_feature(3) = I_DO;
ppg_feature(4) = x;
ppg_feature(5) = w;
ppg_feature(6) = y;
ppg_feature(7) = z;
ppg_feature(8) = I_wx;
ppg_feature(9) = I_wy;
ppg_feature(10) = a;
ppg_feature(11) = b;
ppg_feature(12) = c;
ppg_feature(13) = d;
ppg_feature(14) = e;
ppg_feature(15) = f;
ppg_feature(16) = I_af;
ppg_feature(17) = I_ab;
ppg_feature(18) = I_ac;
ppg_feature(19) = I_cb;
ppg_feature(20) = I_aO;
ppg_feature(21) = I_wO;
ppg_feature(22) = I_bO;
ppg_feature(23) = I_cO;
ppg_feature(24) = I_yO;
ppg_feature(25) = I_O2O;
ppg_feature(26) = I_zO;
ppg_feature(27) = R1;
ppg_feature(28) = R2;
ppg_feature(29) = T_O2O;
ppg_feature(30) = T_SO;
ppg_feature(31) = T_NO;
ppg_feature(32) = T_DO;
ppg_feature(33) = T_SD;
ppg_feature(34) = T_NN2;
ppg_feature(35) = T_zw;
ppg_feature(36) = T_yw;
ppg_feature(37) = T_wx;
ppg_feature(38) = T_w2w;
ppg_feature(39) = T_af;
ppg_feature(40) = T_ba;
ppg_feature(41) = T_ca;
ppg_feature(42) = T_da;
ppg_feature(43) = T_ea;
ppg_feature(44) = T_a2a;
ppg_feature(45) = T_aO;
ppg_feature(46) = T_wO;
ppg_feature(47) = T_bO;
ppg_feature(48) = T_yO;
ppg_feature(49) = T_cO;
ppg_feature(50) = R3;
ppg_feature(51) = R4;
ppg_feature(52) = R5;
ppg_feature(53) = R6;
ppg_feature(54) = r25;
ppg_feature(55) = r50;
ppg_feature(56) = r75;
ppg_feature(57) = d25;
ppg_feature(58) = d50;
ppg_feature(59) = d75;
ppg_feature(60) = PW;
ppg_feature(61) = V;
ppg_feature(62) = V1;
ppg_feature(63) = V2;
ppg_feature(64) = A1;
ppg_feature(65) = A2;
ppg_feature(66) = R7;
ppg_feature(67) = R8;
ppg_feature(68) = R9;
ppg_feature(69) = R10;
ppg_feature(70) = R11;
ppg_feature(71) = s1;
ppg_feature(72) = s2;
ppg_feature(73) = s3;
ppg_feature(74) = s4;
ppg_feature(75) = s5;
ppg_feature(76) = s6;
ppg_feature(77) = s7;
ppg_feature(78) = s8;
ppg_feature(79) = s9;
ppg_feature(80) = k;
ppg_feature(81) = k1;
ppg_feature(82) = k2;
ppg_feature(83) = FDF.AF_AM;
ppg_feature(84) = FDF.AF_CF;
ppg_feature(85) = FDF.AF_MSF;
ppg_feature(86) = FDF.AF_RMSF;
ppg_feature(87) = FDF.AF_FVAR;
ppg_feature(88) = FDF.f_base;
ppg_feature(89) = FDF.S_base;
ppg_feature(90) = FDF.f_1nd;
ppg_feature(91) = FDF.S_1nd;
ppg_feature(92) = FDF.f_2nd;
ppg_feature(93) = FDF.S_2nd;
ppg_feature(94) = FDF.f_3nd;
ppg_feature(95) = FDF.S_3nd;
ppg_feature(96) = FDF.PS_MNF;
ppg_feature(97) = FDF.PS_MDF;
ppg_feature(98) = FDF.PS_TP;
ppg_feature(99) = FDF.PS_MNP;
ppg_feature(100) = FDF.PS_MPF;


ppg_feature = [id val F1 F2 F43 F44 ppg_feature ];
    %% 8--Save data
    % interested features
    subject_feature = [ppg_feature];
end