function MAIN_runMuniMeng_ffxStyle()
% [filesFoundInDir, dirName ]  = loadDirForRack();
resultsDir = fullfile(pwd,'ffxResults_100shufs_not_smootheD_newT2013');
% self other: 
resultsDir = fullfile(pwd,'fD:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study\dataForServer_SepBeta\words');
substorun = importdata('subsused.txt');
substorun = sort(substorun);
% self othr 
substorun = 3000:3012;
%% set params: 
numShuffels = 50; 
slSize = 27;
runRFX = 0;
%% 
params = getParams();
pool = startPool(params);
idxs = input('start at sub idx?');
idxe = input('end at sub idx?');


for i = 1:length(idxs:idxe)
    subidx = substorun(i);
    load(filesFoundInDir{i});
%     data = zscore(data);
	[pn,fn] = fileparts(filesFoundInDir{i});
	temp = regexp(fn,'[0-9]+','match');
	sName = ['s' temp{1}];
    fnTosave = [dirName '_' sName];
    %% run the hotteling test for each subject 
    MAIN_doSearchLightCrossValFolds_Ht2_NewT2013(...
        data,...
        locations,...
        mask,... % called map in original data 
        labels,...
        fnTosave,...
        slSize,...
        runRFX,...
        numShuffels,...
        resultsDir);		
end
delete(pool);
end