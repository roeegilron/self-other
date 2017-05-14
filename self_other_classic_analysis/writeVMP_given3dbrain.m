function writeVMP_given3dbrain(brain3d, maptitle,resdir)
addpath(genpath('/Volumes/2TB_EXFAT/Poldrack_RFX_Project/toolboxes/neuroeflf/NeuroElf_v10_5153'));
%% write VMP percents into TAL map based on anatomical atals brain. 
brainlin = brain3d(:); 
zeridxs = brainlin==0; 
minval = min(brainlin(~zeridxs));
maxval = max(brainlin(~zeridxs));

%% get data 
vmpblank = BVQXfile(fullfile(pwd,'blank_vmp_tal_3x3res.vmp')); 
vmptemp  = BVQXfile(fullfile(pwd,'blank_vmp_tal_3x3res.vmp')); 
vmptemp.Map.VMPData = zeros(size(vmptemp.Map.VMPData)); 
%% create new cluster map 
curmap = 1; 
vmpblank.Map(curmap) = vmptemp.Map(1);
vmpblank.Map(curmap).VMPData = brain3d;
mapttl = maptitle;
vmpblank.MAP(curmap).Name = mapttl;
colorToUse = [255 0 255];
% set some map properties
vmpblank.Map(curmap).LowerThreshold = minval;
vmpblank.Map(curmap).UpperThreshold = maxval;%XXX cutOff;
vmpblank.Map(curmap).UseRGBColor = 0;
vmpblank.Map(curmap).RGBLowerThreshNeg = colorToUse;
vmpblank.Map(curmap).RGBUpperThreshNeg = colorToUse;
vmpblank.Map(curmap).RGBLowerThreshPos = colorToUse ;
vmpblank.Map(curmap).RGBUpperThreshPos = colorToUse;

resfnew = [maptitle '.vmp'];
vmpblank.SaveAs(fullfile(resdir,resfnew)); 
end 