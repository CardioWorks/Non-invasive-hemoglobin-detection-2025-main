function [optimum_beat] = find_num_max(beat_score,num)
%%
large_small = sort(beat_score,'descend');
max_score = large_small(1:num);
for i = 1:num
 [beat,~,~] = find(beat_score==max_score(i),1,'first');
 optimum_beat(i) = beat;
end
end

