function createMDM()
subjects = [2000:2003 2005:2006];
runs = [2:5]; % run 1 is localizer 
rootDirForVTCs = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis\';
rootDirForSDMs = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis\prts';
outFolder      = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis\multi_sub_analysis';
mdm = xff('mdm');
cnt = 1;
for i = 1:length(subjects)
    for j = 1:length(runs)
        vtcFile = fullfile(rootDirForVTCs,...
                            ['s_' num2str(subjects(i))],...
                            ['s' num2str(subjects(i)) '_RUN0' num2str(runs(j)) '_MNI.vtc']);
        sdmFile = fullfile(rootDirForSDMs,...
                            ['ObservationRun' num2str(runs(j)-1) '_Subject_' num2str(subjects(i)) '.sdm']);
        mdm.XTC_RTC{cnt,1} = vtcFile;
        mdm.XTC_RTC{cnt,2} = sdmFile;
        cnt = cnt + 1;
    end
end
mdm.NrOfStudies = size(mdm.XTC_RTC,1);
mdm.SeparatePredictors = 2;  % concatenate predictors across runs but not across subjects
mdm.zTransformation = 1;
mdm.PSCTransformation = 0;
mdm.RFX_GLM = 0; % perform FFX at first
mdm.SaveAs(fullfile(outFolder,'2000subjects_MNI.mdm'));

end