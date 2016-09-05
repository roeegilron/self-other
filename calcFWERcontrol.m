function [sigfwer, sigbonf,  clustdata] = calcFWERcontrol(avgAnsMat,mask,locations)
realt = avgAnsMat(:,1);
srealt = sort(srealt);
cutofft = srealt(floor((length(srealt)*0.98)));
allclustsize = [];
for i = 1:size(avgAnsMat)
    dataFromAnsMatBackIn3d = scoringToMatrix(mask,avgAnsMat(:,i),locations);
    if i == 1 % real data 
        [rvals,rinstances,rrp] = getAllCc(dataFromAnsMatBackIn3d>cutofft,6,size(avgAnsMat,1));
    else % shuffle data
        [vals,instances,rp] = getAllCc(dataFromAnsMatBackIn3d>cutofft,6,size(avgAnsMat,1));
        maxsizes(i-1) = max(vals); 
        clustsizes = [];
        for j = 1:size(vals,1)
            clustsizes = [clustsizes; repmat(vals(j),instances(j),1)];
        end
        allclustsize = [allclustsize ; clustsizes]; 
    end
    fprintf('map %d done \n',i);
end
%% fwer control 
sortedmaxsizes = sort(maxsizes);
cutoffmaxclusisze = sortedmaxsizes(floor((length(sortedmaxsizes)*0.95)));
idxsclusters =  find(rvals>=cutoffmaxclusisze); 
sigfwer  = [];
% xxxx finish work 

%% bonforoni control 
% XXXX finish work 
sigbonf = [] ;
%% export clust data 
dataFromAnsMatBackIn3d = scoringToMatrix(mask,avgAnsMat(:,1),locations);
clustdata.rvals = rvals;
clustdata.rinstances = rinstances;
clustdata.rrp = rrp;
clustdata.maxsizes = maxsizes;
clustdata.allclustsize = allclustsize;
clustdata.realdata = vgAnsMat(:,1);
clustdata.realdata3d = dataFromAnsMatBackIn3d;



end