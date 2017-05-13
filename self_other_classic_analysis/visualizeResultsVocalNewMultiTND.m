function visualizeResultsVocalNewMultiTND()
resltsdir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';
fn = 'Nondirection_FFX_vocalDataset_150-subs_27-slsize_1-cvFold_100-shuf-stlzer_newT2013.mat';
load(fullfile(resltsdir,fn));
% pval = calcPvalVoxelWise(ansMat);
%% fdr control
cutOff = 0.1;
SigFDR = fdr_bh(pval',cutOff,'pdep','no');
% Pval(Pval>cutOff) = 0;
SigFDR = double(SigFDR);
    
% save vmp: 
n = neuroelf;
vmpmni = n.importvmpfromspms(fullfile(pwd,'temp.nii'),'a',[],3);
vmpdat = scoringToMatrix(mask,SigFDR',locations);
vmpmni.Map(1).Name = fn(1:end-4);
vmpdat = single(vmpdat);
vmpmni.Map(1).VMPData = vmpdat;
vmpmni.NrOfMaps = 1;
vmpmni.SaveAs(fullfile(resltsdir,[fn(1:end-4) '.vmp']))
end