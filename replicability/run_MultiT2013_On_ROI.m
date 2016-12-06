function [pval, ansMat] = run_MultiT2013_On_ROI(data,labels,settings,params)
params.numshufs = 400;
labelsuse = labels; 
for s = 1:params.numshufs
    if s == 1 
        ansMat(:,1) = calcTstatMuniMengTwoGroup(data(labelsuse==1,:),data(labelsuse==2,:));
    else
        labelsuse = labels(randperm(length(labels)));
        ansMat(:,s) = calcTstatMuniMengTwoGroup(data(labelsuse==1,:),data(labelsuse==2,:));
    end
end

pval = calcPvalVoxelWise(ansMat); 

end