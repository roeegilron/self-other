function data = getGroundTruth()
% this function loads the results of the linear svm 
% that Poldrak et.al. published that we are comparing to
dataLocation = pwd;
dataFn = 'thresholded_searchlight_results_0.6_2mm_pumpVcashout.nii.gz';
niftiDAta = load_nii(fullfile(dataLocation,dataFn));
data = niftiDAta.img;

end