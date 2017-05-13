function loadNIIfile()
[pn,fn] = uigetfile('*.nii','choose nifti');
niftiDAta = load_nii(fullfile(fn,pn));

end