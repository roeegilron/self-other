function plotVMP_testDataAnalysis () 
rootdir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirecFFXoneBigShuff';
fnms = {'Directional____FFX_vocalDataset_20-subs_27-slsize_21-cvFold_1000-shuf_TvalsBench_.mat',...
    'Nondirection_FFX_vocalDataset_20-subs_27-slsize_21-cvFold_1000-shuf_TvalsBench_.mat'};
maplabel = {'D FFX fold 21', 'ND FFX fold 21'};
% save vmp: 
n = neuroelf;
vmp = n.importvmpfromspms(fullfile(pwd,'temp.nii'),'a',[],3);

mapstruc = vmp.Map;
for i = 1:2
    load(fullfile(rootdir,fnms{i}),'ansMat','mask','locations');
    pvalnew = calcPvalVoxelWise(squeeze(ansMat(:,:,1)));
    sigfdrnew =fdr_bh(pvalnew,0.05,'pdep','no');
    sigfdrnew = double(sigfdrnew);
    numvoxels = sum(sigfdrnew);
    if i == 2
        sigfdrnew(sigfdrnew == 1) = 2;
    end
    vmpdat = scoringToMatrix(mask,sigfdrnew,locations); % note that SigFDR must be row vector
    mapname = sprintf('%s (%d)',maplabel{i},numvoxels);
    clear ansMat sigfdrnew 
    lowthres = 0; upperthresh = 3;
    vmpdat = single(vmpdat);
    vmp.Map(i) = mapstruc;
    vmp.Map(i).Name = mapname;
    vmp.Map(i).VMPData = vmpdat;
    vmp.Map(i).LowerThreshold = 0;
end
vmp.NrOfMaps = 2;
vmp.SaveAs(fullfile(rootdir,['D-ND-FFX-check-1-28-16' '.vmp']))


end