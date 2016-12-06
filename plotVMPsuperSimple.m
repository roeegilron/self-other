function plotVMPsuperSimple()
p= genpath('D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\toolboxes');addpath(p);
n = neuroelf;
% ismni = input('MNI (1) or TAL (0) ? \n'); 
ismni = 0;
% load sample example MNI .nii
if ismni
    vmp = BVQXfile(fullfile(pwd,'blank_MNI_3x3res.vmp'));
else
    vmp = BVQXfile(fullfile(pwd,'blank_vmp_tal_3x3res.vmp'));
end
alpha = 0.05;
%% load file 
rootdir = fullfile('..','..','..','MRI_Data_self_other','subjects_3000_study','results_self_other_sub_beta'); 
resfold = 'self-other'; % 'self-other','other-other','words'; 
foldres = fullfile(rootdir,resfold); 
ff = findFilesBVQX(foldres,'ND_FFX_*newT2013.mat',struct('depth',1));
fprintf('choose file:\n'); 
for i = 1:length(ff)
    [pn,fn] = fileparts(ff{i}); 
    fprintf('[%.2d] %s\n',i,fn);
end
idx = input(' ? ');
fuse = ff{idx};
[pn,fn] = fileparts(ff{idx});
mapttl = sprintf('%s alpha %.3f',fn(1:end-20),alpha);
fnload = fuse;
%% 
ff = findFilesBVQX(foldres,'results_DR*.mat');
load(ff{1},'ansMatReal');
drrrealdata = ansMatReal;
clear ansMatReal; 




% how many second levels files do you want to plot? 
% mapnum = input('how many sec level files do you want to plot? \n'); 
mapnum = 1;
curMapNum = 1;
for i = 1:mapnum
%     [seclevfn,pn] = uigetfile('*.mat','choose second level file'); 
    load(fuse); 
%     fprintf('these are the vars:\n'); 
%     eval('whos'); 
    % nameofavgfile = input('type name of avg file \n','s'); 
%     nameofavgfile = 'avgAnsMat';
    %nameofavgfile = 'ansMat'; % for DR analysis 
%     avgFile = eval(nameofavgfile); 
%     pval = calcPvalVoxelWise(avgFile);
    [sigfdr, critp] = fdr_bh(eval(['pval']),alpha,'pdep','yes');
    idx_plot = find(sigfdr==1);
    dataToPlot = zeros(size(locations,1),1);
    dataToPlot(idx_plot) = 1;%rois(i).normMaps.fa(idxuse); % XXX just get boolean values
    dataToPlot(idx_plot) = ndrrealdata(idx_plot);%rois(i).normMaps.fa(idxuse); % XXX just get boolean values
    mint = min(ndrrealdata(idx_plot));
    maxt = max(ndrrealdata(idx_plot));
%     dataToPlot(:) = avgFile(:,1); % plot real data 
    dataFromAnsMatBackIn3d = scoringToMatrix(mask,dataToPlot,locations);
    vmp.NrOfMaps = curMapNum;
    colorToUse = [255 0 0];
    fprintf('filename %s\n',fnload);
    
    % set some map properties
    vmp.Map(curMapNum) = vmp.Map(1);
    vmp.Map(curMapNum).VMPData = dataFromAnsMatBackIn3d;
    vmp.Map(curMapNum).LowerThreshold = mint;
    vmp.Map(curMapNum).UpperThreshold = maxt;%XXX cutOff;
    vmp.Map(curMapNum).UseRGBColor = 1;
    vmp.Map(curMapNum).RGBLowerThreshNeg = colorToUse;
    vmp.Map(curMapNum).RGBUpperThreshNeg = colorToUse;
    vmp.Map(curMapNum).RGBLowerThreshPos = colorToUse ;
    vmp.Map(curMapNum).RGBUpperThreshPos = colorToUse;
    if isempty(idx_plot)
        numvoxels = 0; 
    else
        numvoxels = length(idx_plot); 
    end
    vmp.Map(curMapNum).Name = sprintf('%s (%d)',mapttl,numvoxels);
    vmp.Map(curMapNum).Type = 1;
    curMapNum = curMapNum + 1;

end
dir2save = foldres;
% vmpfn = input('select vmp fn to save \n','s'); 
vmpfn = [fn(1:end-20) '.vmp'];
vmp.SaveAs(fullfile(dir2save,vmpfn));
vmp.ClearObject;
clear vmp;
end