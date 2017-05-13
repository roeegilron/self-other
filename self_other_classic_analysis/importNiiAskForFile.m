function importNiiAskForFile()
[fn,pn] = uigetfile('*.nii','select a nii file');

n = neuroelf;
%% import real data: 

fileToImport = fullfile(pn,fn);
vmp = n.importvmpfromspms(fileToImport,'a',[],3); % import at resolution 3mm 
realData = vmp.Map.VMPData; % since I use res of 3 (up sample need to get rid of 0.5's) 
vmp.SaveAs();

end