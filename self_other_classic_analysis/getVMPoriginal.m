function vmp = getVMPoriginal(pn,mask)
% create vmp with t stat data  
% This is the original data - this is only relevant for Russ's data 
% just return an empty vmp map if mask is not MNI 
if sum(size(mask)) < 250 % russ's mask is 91x109x91
   vmp = BVQXfile('vmp');
   return 
end
niftiDataOriginal = load_nii(fullfile(pwd,...
    'thresholded_searchlight_results_0.6_2mm_pumpVcashout.nii.gz'));
save_nii(niftiDataOriginal,fullfile(pn,['originalData' '.nii']));
n = neuroelf;
vmp = n.importvmpfromspms(fullfile(pn,['originalData' '.nii']),'a',[],2);

% combine the original and t stat vmps , original is blue
vmp.Map.LowerThreshold = 0.6;
vmp.Map.UpperThreshold = 0.7;
vmp.Map.Name = 'originalData';
vmp.Map.RGBLowerThreshPos = [ 0 0 255];
vmp.Map.RGBUpperThreshPos = [ 0 0 255];
vmp.Map.RGBLowerThreshNeg = [ 0 0 255];
vmp.Map.RGBUpperThreshNeg = [ 0 0 255];
vmp.Map.UseRGBColor = 1; 
end