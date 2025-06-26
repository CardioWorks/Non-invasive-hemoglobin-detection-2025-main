clear
clc
  %%
  path.data = '.\DATA\';
  path.save = '.\OUTPUT\';
  addpath (genpath('.\CODE\')) 

  List = dir(strcat(path.data,'*.txt'));
  for j = 1:length(List)
    id=[List(j).name];
    id=str2num(id(isstrprop(id,'digit')));
    PPGdata = importdata(strcat(path.data,[List(j).name]));
    %%
    x = isa(PPGdata,"double");
    if x == 1
    channel_1=PPGdata(:,1);
    channel_2=PPGdata(:,2);
    channel_3=PPGdata(:,3);
    channel_4=PPGdata(:,4);
    else
    channel_1=PPGdata.data(:,1);
    channel_2=PPGdata.data(:,2);
    channel_3=PPGdata.data(:,3);
    channel_4=PPGdata.data(:,4);
    end
    channel_1=channel_1(end:-1:1);
    channel_2=channel_2(end:-1:1);
    channel_3=channel_3(end:-1:1);
    channel_4=channel_4(end:-1:1);
    %%
    data.channel_1 = filter_home_bandpass( channel_1,1,2,200,0.5,8);
    data.channel_2 = filter_home_bandpass( channel_2,1,2,200,0.5,8);
    data.channel_3 = filter_home_bandpass( channel_3,1,2,200,0.5,8);
    data.channel_4 = filter_home_bandpass( channel_4,1,2,200,0.5,8);
    
    channel_1=data.channel_1(cursor_info(2).DataIndex:cursor_info(1).DataIndex,1);
    channel_2=data.channel_2(cursor_info(2).DataIndex:cursor_info(1).DataIndex,1);
    channel_3=data.channel_3(cursor_info(2).DataIndex:cursor_info(1).DataIndex,1);
    channel_4=data.channel_4(cursor_info(2).DataIndex:cursor_info(1).DataIndex,1);

    save(strcat(path.save,[List(j).name(1:end-4)]),'data')
  end