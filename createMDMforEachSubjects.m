function createMDMforEachSubjects()
rootDir = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis';
subDirs = findfiles(rootDir,'s*','dirs=1','depth=1') ;
sdmDir = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis\prts';
outFolder = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis\multi_sub_analysis';

for i = 1:length(subDirs) % loop on subjects
    vtcFiles = findfiles(subDirs{i},'*.vtc','depth=1') ;
    mdm = xff('mdm'); % open an MDM for each subjects
    cnt = 1;
    for j = 1:length(vtcFiles)
        [~, fn] = fileparts(vtcFiles{j});
        run = fn(11); % get run %
        if strcmp(run,'1') % skip the first localizer run for now
        else
            newRunNum = num2str(str2num(run) - 1 ); % deceremend run number by one since run 01 is localizer in VTC, but obs in prt
            subNum = subDirs{i}(end-3:end);
            sdmFiles = findfiles(sdmDir,...
                ['*R*' newRunNum '*S*' subNum '.sdm'],'depth=1') ;
            mdm.XTC_RTC{cnt,1} = vtcFiles{j};
            mdm.XTC_RTC{cnt,2} = sdmFiles{1};
            cnt = cnt + 1;
        end
    end
    mdm.NrOfStudies = size(mdm.XTC_RTC,1);
    mdm.SeparatePredictors = 2; % concatenate predictors across runs but not across subjects
    mdm.zTransformation = 1;
    mdm.PSCTransformation = 0;
    mdm.RFX_GLM = 0; % perform FFX at first
    mdm.SaveAs(fullfile(outFolder,['s' num2str(subNum) '_MNI.mdm']));
end

end