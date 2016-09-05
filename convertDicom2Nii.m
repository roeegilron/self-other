function convertDicom2Nii()
%%  add the relevant files to the path      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
analysisFunctionDir = genpath(pwd);
addpath(analysisFunctionDir);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  get the relvant folders and convert      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rootDir = 'H:\1_AnalysisFiles\MRI_Data';
outDir = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis';
subjects = [2001:2003 2005];% [2001:2003 2005:2006];
for i = 1:length(subjects);
    fprintf('sub %d started at %s\n',subjects(i),datestr(clock));
    %proccess obervation folders 
    subFolder = dir(  fullfile(rootDir,[num2str(subjects(i)) '*'] ));
    obsFolders = dir(fullfile(rootDir,subFolder.name,'Obs*'));
%     for j = 1:length(obsFolders) % loop on the observation folders
%         if obsFolders(j).isdir % check that this is a folder 
%             sourceF = fullfile(rootDir,subFolder.name,obsFolders(j).name);
%             run = num2str(obsFolders(j).name(7));
%             dataF = fullfile(outDir,['s_' num2str(subjects(i))],'functional',['run' run '_ObsRun' run]);
%             dicm2nii(sourceF,dataF,0)
%         end
%     end
    % proccess anatomical folder
    anatFolder = dir(fullfile(rootDir,subFolder.name,'*BRAVO*'));
    sourceF = fullfile(rootDir,subFolder.name,anatFolder.name);
    dataF = fullfile(outDir,['s_' num2str(subjects(i))],'anatomical','run1');
%     dicm2nii(sourceF,dataF,0);
    % proccess localizer folder 
    locFolder = dir(fullfile(rootDir,subFolder.name,'*Loc*'));
    sourceF = fullfile(rootDir,subFolder.name,locFolder.name);
    dataF = fullfile(outDir,['s_' num2str(subjects(i))],'functional','run0_Localizer');
    dicm2nii(sourceF,dataF,0);
    fprintf('sub %d finished at %s\n',subjects(i),datestr(clock));
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%  remove path                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rmpath(analysisFunctionDir)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
