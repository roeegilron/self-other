function plotVMPresultsInTALatlasRegions()
% This function seperates a thresholded map to reigons based on TAL atlas
% Input: 
% 1. VMP of TAL altas 
% 2. VMP of file you want to break up into clusters 
% Output:
% VMP file broken up into cluster based on TAL. 
%% get data 
talvmpfn = fullfile(pwd,'functional_connectivity','TAL_oxford_harvard_atlas.vmp'); 
resdir   = fullfile('..','..','..','MRI_Data_self_other','subjects_3000_study','results_self_other_sub_beta','self-other');
resfn    = fullfile(resdir,'ND_FFX_self_other_23-subs_125-slsze_1-fld_400shufs_20000-stlzer_mode.vmp');
vmpatlas = BVQXfile(talvmpfn); 
vmpreslt = BVQXfile(resfn); 
vmpblank = BVQXfile(fullfile(pwd,'blank_vmp_tal_3x3res.vmp')); 
vmptemp  = BVQXfile(fullfile(pwd,'blank_vmp_tal_3x3res.vmp')); 
vmptemp.Map.VMPData = zeros(size(vmptemp.Map.VMPData)); 
%% create new cluster map 
curmap = 1; 
mapres = vmpreslt.Map.VMPData>0;
for i = 1:vmpatlas.NrOfMaps
    maptemp = logical(vmpatlas.Map(i).VMPData);
    mapwrite = mapres & maptemp; 
    if sum(mapwrite(:)) ~= 0 % only write regions where overlap 
        vmpblank.Map(curmap) = vmptemp.Map(1);
        vmpblank.Map(curmap).VMPData = mapwrite; 
        mapttl = sprintf('%s (%d)',vmpatlas.Map(i).Name,sum(mapwrite(:)));
        vmpblank.MAP(curmap).Name = mapttl;
        colorToUse = [255 0 255];
        % set some map properties
        vmpblank.Map(curmap).LowerThreshold = 0.5;
        vmpblank.Map(curmap).UpperThreshold = 2;%XXX cutOff;
        vmpblank.Map(curmap).UseRGBColor = 1;
        vmpblank.Map(curmap).RGBLowerThreshNeg = colorToUse;
        vmpblank.Map(curmap).RGBUpperThreshNeg = colorToUse;
        vmpblank.Map(curmap).RGBLowerThreshPos = colorToUse ;
        vmpblank.Map(curmap).RGBUpperThreshPos = colorToUse;

        vmpblank.NrOfMaps = curmap; 
        voxcheck(curmap) = sum(mapwrite(:)); 
        curmap = curmap + 1; 
        
    end 
end
resfnew = ['roisby_atlas.vmp'];
vmpblank.SaveAs(fullfile(resdir,resfnew)); 

end 