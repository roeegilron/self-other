function vmp = getVMPpstat(ansMat,pn,fn,locations,mask,cutOff,vmp)
% create vmp with t stat data  
Pval = calcPvalVoxelWise(ansMat);
% bcs of BV display issues, set Pval over cut off val to zero
%% fdr control
SigFDR = fdr_bh(Pval,cutOff,'pdep','no');
% Pval(Pval>cutOff) = 0;
SigFDR = double(SigFDR);
if sum(SigFDR) ==0 % no maps passed thresh
    fprintf('no voxels passed thresh at p %f \n',cutOff);
    return
end
SigFDR(SigFDR ==1) = 10; % make the value bigger artificially so it displays on VMP
ansMatAverage(:,2) = SigFDR; % XXXXX  first column is real data 
ansMatAverage(:,1) = 1:size(Pval,1);
dataFromAnsMatBackIn3d = scoringToMatrix(mask,ansMatAverage,locations);

% This is the original data 
% just load this temp 
niftiData = load_nii(fullfile(pwd,...
    'thresholded_searchlight_results_0.6_2mm_pumpVcashout.nii.gz')); % this is dummy nifty data
niftiData.img = dataFromAnsMatBackIn3d;
save_nii(niftiData,fullfile(pn,['P' fn(2:end) '.nii']));
n = neuroelf;
vmpPstat = n.importvmpfromspms(fullfile(pn,['P' fn(2:end) '.nii']),'a',[],2);


%% add this map to the vmp 
curMapNum = vmp.NrOfMaps + 1; 
vmp.NrOfMaps = curMapNum;
% set some map properties 
vmp.Map(curMapNum) = vmpPstat.Map;
vmp.Map(curMapNum).LowerThreshold = 0;
vmp.Map(curMapNum).UpperThreshold = 12;%XXX cutOff;
vmp.Map(curMapNum).Name = ['P_FDR_corrected' num2str(cutOff) '-' fn(2:end)];
end
