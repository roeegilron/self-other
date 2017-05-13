function mask = getMask() % get mask 

dataLocation = pwd;
dataFn = '2mm_mask.nii.gz';
niftiDAta = load_nii(fullfile(dataLocation,dataFn));
mask = niftiDAta.img;
