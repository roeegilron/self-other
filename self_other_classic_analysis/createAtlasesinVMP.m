function createAtlasesinVMP()
% this function creates some atlases 
% in VMP by loading relevant .nii files that I got from:
% https://github.com/ateshkoul/NeuroImaging/tree/master/spm/peak_nii
rootDir = 'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\matlabCode\atlasLabels';
n = neuroelf;
%% create harvard - cambridge VMP 
holabels = 'HarvardOxford_cortical_labels.mat';
honii = 'HarvardOxford-cort-maxprob-thr0-1mm.nii';
% load labels:
load(fullfile(rootDir,holabels));
% load nii 
fnatlas = fullfile(rootDir,honii);
vmpatlas = n.importvmpfromspms(fnatlas,'a',[],3);
labelsdata = vmpatlas.Map.VMPData;
zerosdata = zeros(size(labelsdata));
vmpatlas = n.importvmpfromspms(fnatlas,'a',[],3);
vmpatlaspopulate = n.importvmpfromspms(fnatlas,'a',[],3);
for i  = 1:length(ROI)
    vmpatlaspopulate.Map(i) = vmpatlas.Map(1);
    tempmap = zerosdata;
    tempmap(labelsdata == i) = 1;
    vmpatlaspopulate.Map(i).VMPData = tempmap;
    vmpatlaspopulate.Map(i).Name = ROI(i).Nom_C;
    vmpatlaspopulate.Map(i).LowerThreshold = 0;
    vmpatlaspopulate.Map(i).UpperThreshold = 2;%XXX cutOff;
end
vmpatlaspopulate.NrOfMaps = length(ROI);
vmpatlaspopulate.SaveAs(fullfile(rootDir,'HarvardCambrdgeCoritcalAtlas.vmp'))


%% create harvard - cambridge sub cortical
holabels = 'HarvardOxford_subcortical_labels.mat';
honii = 'HarvardOxford-sub-maxprob-thr0-1mm.nii';
% load labels:
load(fullfile(rootDir,holabels));
% load nii 
fnatlas = fullfile(rootDir,honii);
vmpatlas = n.importvmpfromspms(fnatlas,'a',[],3);
labelsdata = vmpatlas.Map.VMPData;
unqlabels = unique(labelsdata);
unqlabels = unqlabels(2:end);
zerosdata = zeros(size(labelsdata));
vmpatlas = n.importvmpfromspms(fnatlas,'a',[],3);
vmpatlaspopulate = n.importvmpfromspms(fnatlas,'a',[],3);
for i  = 1:length(ROI)
    vmpatlaspopulate.Map(i) = vmpatlas.Map(1);
    tempmap = zerosdata;
    tempmap(labelsdata == unqlabels(i)) = 1;
    vmpatlaspopulate.Map(i).VMPData = tempmap;
    vmpatlaspopulate.Map(i).Name = ROI(i).Nom_C;
    vmpatlaspopulate.Map(i).LowerThreshold = 0;
    vmpatlaspopulate.Map(i).UpperThreshold = 2;%XXX cutOff;
end
vmpatlaspopulate.NrOfMaps = length(ROI);
vmpatlaspopulate.SaveAs(fullfile(rootDir,'HarvardCambrdgeCoritcalAtlas_sub_cortical.vmp'))


% %% create Tal atlas labels VMP 
% holabels = 'Talairach_labels.mat';
% honii = 'Talairach-labels-1mm.nii';
% % load labels:
% load(fullfile(rootDir,holabels));
% % load nii 
% fnatlas = fullfile(rootDir,honii);
% vmpatlas = n.importvmpfromspms(fnatlas,'a',[],2);
% labelsdata = vmpatlas.Map.VMPData;
% zerosdata = zeros(size(labelsdata));
% vmpatlas = n.importvmpfromspms(fnatlas,'a',[],2);
% vmpatlaspopulate = n.importvmpfromspms(fnatlas,'a',[],2);
% for i  = 1:length(ROI)
%     vmpatlaspopulate.Map(i) = vmpatlas.Map(1);
%     tempmap = zerosdata;
%     tempmap(labelsdata == i) = 1;
%     vmpatlaspopulate.Map(i).VMPData = tempmap;
%     vmpatlaspopulate.Map(i).Name = ROI(i).Nom_C;
%     vmpatlaspopulate.Map(i).LowerThreshold = 0;
%     vmpatlaspopulate.Map(i).UpperThreshold = 2;%XXX cutOff;
% end
% vmpatlaspopulate.NrOfMaps = length(ROI);
% vmpatlaspopulate.SaveAs(fullfile(rootDir,'TAL_labels.vmp'))

