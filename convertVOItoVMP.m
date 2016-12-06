function convertVOItoVMP()
%% This function takes a .voi file and converts it to a vmp. 
%% The first map has all VOI's in one map together. 
%% After that you have a seperate map for each voi. 

rootDir = 'H:\MRI_Data_self_other\subjects_3000_study\results_multi_smoothed';
voifn = 'vois_all_s-o_vs_rest_multi_smoothed_defined_from_run1_RFX_FDR0001_150_thresh_with_names.voi';
% voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_Bonforoni_005.voi';
% voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_OnlyPeakRegions.voi';
% voifn = 'vois_all_self_vs_other_multi_smoothed_defined_using_t2013.voi';
voifn = 'junk_vois_for_testing.voi';
voi = BVQXfile(fullfile(rootDir,voifn));
ismni = 0;
% load sample example MNI .nii
if ismni
    vmp = BVQXfile(fullfile(pwd,'blank_MNI_3x3res.vmp'));
else
    vmp = BVQXfile(fullfile(pwd,'blank_vmp_tal_3x3res.vmp'));
end
voinames = voi.VOINames;
msk = voi.CreateMSK(vmp.BoundingBox);
vmpdat = vmp.Map(1).VMPData; 
vmpdat = zeros(size(vmpdat));
mask = msk.Mask; 
vmpdat(logical(mask)) = 1; 
vmp.Map(1).VMPData = vmpdat;
vmp.Map(1).Name = voifn(1:end-4); 
vmp.Map(1).LowerThreshold = 0;
vmp.Map(1).UpperThreshold = 2;
fprintf('map %d has %d voxels\n',1,sum(vmp.Map(1).VMPData(:)));
for i = 1:length(voinames)
    curmapnum = i + 1; 
    vmp.Map(curmapnum) = vmp.Map(1);
    msk = voi.CreateMSK(vmp.BoundingBox,i);
    vmpdat = double(zeros(size(vmpdat)));
    mask = msk.Mask;
    vmpdat(logical(mask)) = 1;
    vmp.Map(curmapnum).VMPData = single(vmpdat);
    vmp.Map(curmapnum).Name = sprintf('%s (%d voxels)',voinames{i},sum(mask(:)));
    vmp.Map(curmapnum).LowerThreshold = 0;
    vmp.Map(curmapnum).UpperThreshold = 2;
    fprintf('map %d has %d voxels\n',...
        curmapnum,sum(vmp.Map(curmapnum).VMPData(:)));
    voinums(i) = sum(vmp.Map(curmapnum).VMPData(:));
end
fprintf('min voi = %d , max voi = %d \n',...
    min(voinums),max(voinums));
vmp.SaveAs(fullfile(rootDir,[voifn(1:end-4) '.vmp']));
end