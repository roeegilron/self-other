function createSDMsfromPrt()
rootDirWithAllPrts = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis\prts';
prtFileNames = dir(fullfile(rootDirWithAllPrts,'*.prt'));
for i = 1:length(prtFileNames)
    prt = BVQXfile(fullfile(rootDirWithAllPrts,prtFileNames(i).name));
    if strcmp(prtFileNames(i).name ,'ObservationRun1_Subject_2000.prt')
        params.nvol = 245;
    else
        params.nvol = 252;
    end
    params.sbins = 39;
    sdm = prt.CreateSDM(params);
    sdmName = fullfile(rootDirWithAllPrts,[prtFileNames(i).name(1:end-3) 'sdm']);
    sdm.SaveAs(sdmName)
end
end