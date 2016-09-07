function computeSVM(data,settings,params)
% compute multi t(2013) and shuffles for this particular roi 
rawlabels = data.labels; 
for i = 1:params.numshufs + 1 % first shuffle is real 
    if i == 1
        labelsuse = rawlabels;
    else
        labelsuse = shufflelabelsWithinFold(rawlabels,data.fold); 
    end
    c = balanceDataInFolds(labelsuse,data.fold);
    % loop on folds 
    rawdat = data.data;
    for j = 1:length(c)
        model = svmtrainwrapper(labelsuse(c(j).train),rawdat(c(j).train ,:) ); 
        [~,acc,~] = svmpredictwrapper(labelsuse(c(j).test),rawdat(c(j).test,:),model); 
        accFolds(j) = acc(1);
    end
    ansmat(1,i) = mean(accFolds);
end 
fnms   = sprintf('res_%s.mat',data.roinm);
mkdir(settings.resfolder); 
evalc('mkdir(fullfile(settings.resfolder,data.subnm))');% to supress warning that dir exists 
fullfnms = fullfile(settings.resfolder,data.subnm,fnms);
save(fullfnms,'data','ansmat');
end