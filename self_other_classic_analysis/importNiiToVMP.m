function importNiiToVMP()
baseDir = 'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\vocalDataSet\sub_051\stats';
[pn,fn] = fileparts(baseDir);
saveDir = pn;

n = neuroelf;
%% import real data: 
fn = 'beta_0001.nii';
fileToImport = fullfile(baseDir,fn);
vmp = n.importvmpfromspms(fileToImport,'a',[],3); % import at resolution 3mm 
realData = vmp.Map.VMPData; % since I use res of 3 (up sample need to get rid of 0.5's) 
%% import mask 
maskFiles = findFilesBVQX(fullfile(pn,'mask.nii'));
for i = 1:length(maskFiles)
fn = 'mask.nii';
fileToImport = fullfile(baseDir,fn);
fileToImport = maskFiles{i};
vmp = n.importvmpfromspms(fileToImport,'a',[],3); % import at resolution 3mm 
dataMask = vmp.Map.VMPData; % since I use res of 3 (up sample need to get rid of 0.5's) 
dataMask(dataMask<1) = 0;
mask.(sprintf('mask%d',i)) = dataMask;
end
locations = getLocations(dataMask);
ansMat = reverseScoringToMatrixForFlat(realData, locations);
%vmp.SaveAs(fullfile(pn,'mask.vmp'));

end