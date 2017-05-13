function sigMap = calcAnsMatSig(ansMat,statMethod,alpha)
%% Calc significance of ansMat maps. Return boolean map with voxels passing Sig.
switch statMethod
    case 'FWE'        
        maxVals = sort( max(ansMat(:,2:end),[],1));
        idxUseCutOff = floor((size(ansMat,2)-1)*(1-alpha));
        cutOff = maxVals(idxUseCutOff);
        idx2Pass = find(ansMat(:,1)>cutOff);
        sigMap = zeros(size(ansMat,1),1);
        sigMap(idx2Pass) = 1;
    case 'FDR'
        Pval = calcPvalVoxelWise(ansMat);
        sigMap = fdr_bh(Pval,alpha,'pdep','no');
        sigMap = double(sigMap);
end