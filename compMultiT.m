function compMultiT(data,settings,params)
% compute multi t(2013) and shuffles for this particular roi 
rawlabels = data.labels; 
for i = 1:params.numshufs + 1 % first shuffle is real 
    if i == 1
        labelsuse = rawlabels;
    else
        labelsuse = rawlabels(randperm(length(rawlabels))); 
    end
    rawdat = data.data; 
    rawdat( :, all(~rawdat,1) ) = [];
    numzervoxls = size(data.data,2)-size(rawdat,2);
    x = rawdat(labelsuse==1,:); 
    y = rawdat(labelsuse==2,:); 
    tmp = calcTstatMuniMengTwoGroup(x,y); % first num is multi t, second is nom of multi t, third is denom of multi t 
    ansmat(1,i) = tmp(1);
end 
fnms   = sprintf('res_%s.mat',data.roinm);
mkdir(settings.resfolder); 
evalc('mkdir(fullfile(settings.resfolder,data.subnm))');% to supress warning that dir exists 
fullfnms = fullfile(settings.resfolder,data.subnm,fnms);
save(fullfnms,'data','ansmat','numzervoxls');
end