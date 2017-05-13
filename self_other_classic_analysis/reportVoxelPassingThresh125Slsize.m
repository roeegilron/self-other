function reportVoxelPassingThresh125Slsize()
filesFounds = findFilesBVQX(fullfile(pwd,'replicabilityAnalysis','108subs'),'*125-sl*.mat');
cutOff1 = 0.05;
cutOff2 = 0.1;
for i = 1:length(filesFounds)
    load(filesFounds{i},'ansMat'); 
    [~,fn] = fileparts(filesFounds{i});
    Pval = calcPvalVoxelWise(ansMat);
    SigFDR1 = fdr_bh(Pval,cutOff1,'pdep','no');
    SigFDR2 = fdr_bh(Pval,cutOff2,'pdep','no');
    fprintf('in file %s found %d at cut off %f and %d at cut off %f\n',...
        fn,sum(SigFDR1),cutOff1,...
        sum(SigFDR2),cutOff2);
end
end