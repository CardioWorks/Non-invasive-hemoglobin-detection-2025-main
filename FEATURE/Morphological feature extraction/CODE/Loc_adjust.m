function [Loc_A,Loc_B,Loc_C,Loc_D] = Loc_adjust(Loc_A,Loc_B,Loc_C,Loc_D)

M = mode([length(Loc_A),length(Loc_B),length(Loc_C),length(Loc_D)]);

std1=std(diff(Loc_A));
std2=std(diff(Loc_B));
std3=std(diff(Loc_C));
std4=std(diff(Loc_D));
%%
s=[std1,std2,std3,std4];
[~,i]=min(s);

%%
switch i
    case 1
        PPG_P_Loc=Loc_A;
    case 2
        PPG_P_Loc=Loc_B;
    case 3
        PPG_P_Loc=Loc_C;
    case 4
        PPG_P_Loc=Loc_D;
end

%%
if length(Loc_A) ~= M
    Loc_A = PPG_P_Loc;
end

if length(Loc_B) ~= M
    Loc_B = PPG_P_Loc;
end

if length(Loc_C) ~= M
    Loc_C = PPG_P_Loc;
end

if length(Loc_D) ~= M
    Loc_D = PPG_P_Loc;
end
