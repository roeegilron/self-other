function createPRTforExp2000s()
% decide if you want to skip creation of obs prts
createObs = 1;
% device if you want to move created prts to subject specific directories: 
movePRTs = 1;
% get log file names
% location of experiment log files
rootDir = 'H:\1_AnalysisFiles\MRI_Data\mat_files_for_experiment\3_letter_experiment\3_letter_exp_final_version';
% folder to save PRTs to:
prtDir = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis\prts';
fileNamesToConvertObs = getfileNames(rootDir,'ObservationRun','.mat');
fileNamesToConvertLoc = getfileNames(rootDir,'LocalizerSubject*200*','.mat');


%% create PRT for observation trials.
if createObs
    for i=1:length(fileNamesToConvertObs)
        seq = generateSequencesForGLM_PRT_newVer(fileNamesToConvertObs{i});
        createPrt_self_other_new(fileNamesToConvertObs{i},seq,prtDir);
    end
end
%%

%% create prt for localizer trials
for j = 1:length(fileNamesToConvertLoc)
    seq = generateSequencesForGLM_PRT_localizer_newVer(fileNamesToConvertLoc{j});
    createPrt_localizer_new(fileNamesToConvertLoc{j},seq,prtDir);
end
%%


%% move PRTS to subject specific directories 
subjects = {'2000','2001','2002','2003','2005','2006'};
subPatterns = 'H:\1_AnalysisFiles\MRI_Data\GLM_reAnalysis\9999\functional\prts';
if movePRTs
    for i = 1:length(subjects)
        prtsToMove = findfiles(prtDir,['*' subjects{i} '*.prt']);
        folderToMoveTo = strrep(subPatterns,'9999',subjects{i});
        for j = 1:length(prtsToMove)
            [~, p ] = fileparts(prtsToMove{j});
            destinationPath = fullfile(folderToMoveTo,[p '.prt']);
            movefile(prtsToMove{j},destinationPath);
        end
    end
end

end