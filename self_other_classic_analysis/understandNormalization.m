function understandNormalization()
%% ad path 
p = genpath('D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX');
addpath(p);
%% get all subject folders 
rtdir = 'F:\vocalDataSet\processedData\processedData\';
subdirs = findFilesBVQX(rtdir,'sub*',struct('dirs',1,'maxdepth',1));
rootDir = 'F:\vocalDataSet\processedData\processedData\sub001_Ed';
n = neuroelf;
for i = 1:length(subdirs)
    start = tic;
    % get deformation nii filename and normalized nii filename
    fndeforemd = findFilesBVQX(fullfile(subdirs{i},'ana'),'y_sub*.nii'); % deformation field in native space
    fnorig = findFilesBVQX(fullfile(subdirs{i},'ana'),'sub*.nii'); % nii native space
    fnmni = findFilesBVQX(fullfile(subdirs{i},'ana'),'wmsub*.nii'); % nii in target space 
    % load all of these nii: 
    orig_nii = load_untouch_nii(fnorig{1});% (256 x 256 x 192)
%     Bounding box:
%   -98.8473 -158.8988 -158.2295
%   102.5530  151.4997  148.5124
    deform_nii = load_nii(fndeforemd{1}); % (121 x 145 x 121 x 1 x 3) 
%     % Bounding box:
%    -90  -126   -72
%     90    90   108
    mni_nii = load_nii(fnmni{1}); % (79 x 95 x 79)
% Bounding box:
%    -78  -112   -70
%     78    76    86
    
    % load with SPM vol tool 
    orig_nii = spm_vol(fnorig{1});% (256 x 256 x 192)
    deform_nii = spm_vol(fndeforemd{1}); % (121 x 145 x 121 x 1 x 3) 
    mni_nii = spm_vol(fnmni{1}); % (79 x 95 x 59)
    % report image sizes: 
    fprintf('\t sub %d details:\n',i);
    fprintf('orig .nii is \t %d %d %d \n',size(orig_nii.img));
    fprintf('deform .nii is \t %d %d %d %d %d \n',size(deform_nii.img));
    fprintf('mni .nii is \t %d %d %d \n',size(mni_nii.img));
    % trasnform new normed deformation nii to mni space
    warpnii(fndeforemd{1});
    % load deformation nii in MNI space
    [pn,fn] = fileparts(fndeforemd{1});
    niifiledformedmnispace = load_nii(fullfile(pn,['w' fn '.nii']));
    % calc norm of deformation nii
    imsqzd = squeeze(niifiledformedmnispace.img);
    sumnorm = sum(imsqzd,4);
    % save deforamtion nii (load dummy .nii w file, and save with new name)
    mni_nii = load_nii(fnmni{1});
    mni_nii.img = sumnorm;
    mni_nii.fileprefix = fullfile(pn,['norm_in_mni_' fn]);
    save_nii(mni_nii,fullfile(pn,['norm_in_mni_' fn '.nii']));
    fndeform_nii_in_mni = fullfile(pn,['norm_in_mni_' fn '.nii']);
    % use bvqx in order to reslize new deformed nii in MNI space to 3x3x3
    vmpmnideform = n.importvmpfromspms(fndeform_nii_in_mni,'a',[],3);
    vmpmnideform.SaveAs()
    
    deformdata = vmpmnideform.Map.VMPData;
    vmpmnideform.ClearObject;
    clear vmpmnideform
    % save this new image in a new big matrix 
    deformDataAllSubs(:,:,:,i) = deformdata;
    fprintf('sub %d done in %f secs \n',i,toc(start));
end
save(fullfile(rtdir,'deform_data_allsubs.mat'),'deformDataAllSubs');

%% calc the simaliry 
varallsubs = var(deformDataAllSubs,1,4);
meanallsubs = mean(deformDataAllSubs,4);
filesFA = {'rawFAmaps_20_subs_fold21','rawFAmaps_150_subs'};
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';
vmpbasefn = filesFA{1}; % just GM has 1
vmp = BVQXfile(fullfile(rootDir,[vmpbasefn  '.vmp']));
faa020  = vmp.Map.VMPData;

% plot FA vs mean and FA vs variance 

vecfa = faa150(:);
vecme = varallsubs(:);
vecva = meanallsubs(:);
% scale the vectors between 0 -1; 
vecfa_sc = scaleVector(vecfa,'0-1 scaling');
vecme_sc = scaleVector(vecme,'0-1 scaling');
vecva_sc = scaleVector(vecva,'0-1 scaling');

% plot a scatter plot 
hfig = figure();
subplot(1,2,1);
scatter(vecfa_sc,vecva_sc,1,'.')
title('FA values vs Variance of deformation'); 
xlabel('FA values (scaled between 0-1)');
ylabel('Variance of Deformation (scaled between 0-1)');

subplot(1,2,2);
scatter(vecfa_sc,vecme_sc,1,'.')
title('FA values vs mean deformation'); 
xlabel('FA values (scaled between 0-1)');
ylabel('Mean of Deformation (scaled between 0-1)');

% calc the mean deformation across subjects 
% calc the variance of the deformation 
% correlate these measures to the values of FA 
 
beforeNorm = load_untouch_nii('F:\vocalDataSet\processedData\processedData\sub001_Ed\ana\sub001_Ed-0010-00001-000192-01.nii'); 
deformNii = load_nii('F:\vocalDataSet\processedData\processedData\sub001_Ed\ana\y_sub001_Ed-0010-00001-000192-01.nii');
warpedNii = load_nii('F:\vocalDataSet\processedData\processedData\sub001_Ed\ana\wmsub001_Ed-0010-00001-000192-01.nii');
load('F:\vocalDataSet\processedData\processedData\sub001_Ed\ana\sub001_Ed-0010-00001-000192-01_seg8.mat');

matlabbatch{1}.spm.spatial.normalise.write.subj.def = {'F:\vocalDataSet\processedData\processedData\sub001_Ed\ana\y_sub001_Ed-0010-00001-000192-01.nii'};
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {'F:\vocalDataSet\processedData\processedData\sub001_Ed\ana\y_sub001_Ed-0010-00001-000192-01.nii,1'};
matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;



end

function warpnii(fn)
matlabbatch{1}.spm.spatial.normalise.write.subj.def = {fn};
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {fn};
matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;

spm_jobman('initcfg')
spm_jobman('run',matlabbatch)
end
