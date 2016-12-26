function gdataflat = averageGroupData(groupData,gmap,glocations);
% this function loops on groupd data and places it in a flat
% structure, after averaging according to a group mask (using logical & on
% individual subject maps


for s = 1:length(groupData)
    gdata3d(:,:,:,s) = ...
        scoringToMatrix(groupData(s).map,...
        groupData(s).corr,...
        groupData(s).locations);
end
groupavg3d = mean(gdata3d,4); 
gdataflat = reverseScoringToMatrix1rowAnsMat(groupavg3d,glocations); 
end