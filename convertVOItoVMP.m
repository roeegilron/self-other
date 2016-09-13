function convertVOItoVMP()
rootDir = 'H:\MRI_Data_self_other\subjects_3000_study\results_multi_smoothed';
voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_OnlyPeakRegions.voi';

voi = BVQXfile(fullfile(rootDir,voifn));
ismni = 0;
% load sample example MNI .nii
if ismni
    vmp = BVQXfile(fullfile(pwd,'blank_MNI_3x3res.vmp'));
else
    vmp = BVQXfile(fullfile(pwd,'blank_vmp_tal_3x3res.vmp'));
end

msk = voi.CreateMSK(vmp.BoundingBox);
vmpdat = vmp.Map(1).VMPData; 
vmpdat = zeros(size(vmpdat));
mask = msk.Mask; 
vmpdat(logical(mask)) = 1; 
vmp.Map.VMPData = vmpdat;
vmp.Map(1).Name = voifn(1:end-4); 
vmp.SaveAs(fullfile(rootDir,[voifn(1:end-4) '.vmp']));
end