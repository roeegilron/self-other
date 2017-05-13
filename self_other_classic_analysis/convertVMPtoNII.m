function convertVMPtoNII()
% select vmp 
[vmpfn, vmppn] = uigetfile('*.vmp','Please Select a vmp file');
vmpTconvert = BVQXfile(fullfile(vmppn,vmpfn)); 
shellvmp    = BVQXfile(fullfile(vmppn,vmpfn)); % create 'shell' vmp from the first map in target VMP 
shellvmp.NrOfMaps = 1;
shellvmp.Map = shellvmp.Map(1);
outfold = uigetdir('select output dir for images');
for i = 1:vmpTconvert.NrOfMaps
    shellvmp.Map = vmpTconvert.Map(i); 
    mn = vmpTconvert.Map(i).Name;
    niiname = [matlab.lang.makeValidName(mn) '.nii'];
    shellvmp.ExportNifti(fullfile(outfold,niiname),true);
end

end