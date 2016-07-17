function convertDicom2_nii_BIDS()
addpath(genpath(pwd));
%% prefs
prefs.codedir     = pwd; 
prefs.dcm2niifold = fullfile(pwd,'toolboxes','windows','mricrogl');
prefs.rawdatadir  = 'F:\RAW_MRI_DATA';
prefs.funcdirstr  = '%.2d_ep2d_bold*';
prefs.anatom1     = '*MPRAGE_EnchancedContrast*';
prefs.anatom2     = '*MPRAGE_iso1mm*';
prefs.task        = 'self-other-discrim';

%% find subject folders and create dir structure 
rawdirs = findFilesBVQX(prefs.rawdatadir,'RM_lab*',struct('dirs',1,'depth',1)); 
sub = getSubRunKey();
for i = 22:length(rawdirs)
    [fn,pn] = fileparts(rawdirs{i}); 
    substr = pn(13:16);
    %% find anatomical dirs 
    rawanadirs = findFilesBVQX(rawdirs{i},prefs.anatom1,struct('dirs',1,'depth',1));
    if isempty(rawanadirs)
            rawanadirs = findFilesBVQX(rawdirs{i},prefs.anatom2,struct('dirs',1,'depth',1));
    end
    rawanadirs = rawanadirs{1};
    %% convert anatomy of subject 
    subnum = sub.(substr).subn; % get sub num 
    subdir = sprintf('sub-%d',subnum);
    target_sub_dir = fullfile('..','data',subdir);
    mkdir(target_sub_dir);
    target_anat_fold = fullfile(target_sub_dir,'anat');
    mkdir(target_anat_fold);
    nii_ana_name = sprintf('sub-%d_T1W.nii',subnum);
    converdcm2nii(prefs.dcm2niifold,prefs.codedir,rawanadirs,target_anat_fold,nii_ana_name)
    %% convert functional to dicoms
    substruc  = sub.(substr);
    funcdirs = fieldnames(substruc); 
    for k = 2:length(funcdirs)
        func_src_str = sprintf(prefs.funcdirstr,substruc.(funcdirs{k}));
        rawfuncdir = findFilesBVQX(rawdirs{i},func_src_str,struct('dirs',1,'depth',1));
        rawfuncdir = rawfuncdir{1};
        target_func_fold = fullfile(target_sub_dir,'func',funcdirs{k});
        mkdir(target_func_fold);
        runraw = funcdirs{k};
        nii_func_name = sprintf('sub-%d_task-%s_run-%.2d_bold.nii',...
            subnum,prefs.task,str2num(runraw(4)));
        converdcm2nii(prefs.dcm2niifold,prefs.codedir,rawfuncdir,target_func_fold,nii_func_name)
    end
end

%% conver dcm2nii 
inputdir  = '"F:\RAW_MRI_DATA\RM_lab_Roee_StOh_20160713_1606\02_ep2d_bold_254rep_p3_40slices"';
system(['dcm2niix -z n' inputdir] );
end


function converdcm2nii(programdir,presentdir,inputfolder,targetfolder,niiname)
cd(programdir);
system(['dcm2niix -z n ' '"' inputfolder '"'] );
cd(presentdir); 
convertednii = findFilesBVQX(inputfolder,'*.nii');
copyfile(convertednii{1},fullfile(targetfolder,niiname));
end