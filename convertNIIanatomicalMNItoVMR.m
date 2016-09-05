function convertNIIanatomicalMNItoVMR()
[f d] = uigetfile('*.nii');
vmr = importvmrfromanalyze([d f]);
vmr.SaveAs()
end