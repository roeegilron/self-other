function writeMasksToVMP_across_subjects()
[settings,params] = get_settings_params_self_other();
ffxResFold = settings.resdir_ss_prev_cv;
srcpat = '1ND_FFX_s-%d*_cross_validate_newMultit*';

%% get vmp files 
vmpblank = BVQXfile(fullfile(pwd,'blank_vmp_tal_3x3res.vmp')); 
vmptemp  = BVQXfile(fullfile(pwd,'blank_vmp_tal_3x3res.vmp')); 
vmptemp.Map.VMPData = zeros(size(vmptemp.Map.VMPData)); 
%% create new cluster map 
curmap = 1; 
%% get 3d mask from each subject
for i = params.subuse
    start = tic;
    subStrSrc = sprintf(srcpat,i);
    ff = findFilesBVQX(ffxResFold,subStrSrc);
    load(ff{1},'mask')
    if i == 3000
        mapout = logical(mask);
    else
        mapout = mapout & logical(mask);
    end
    fprintf('sub %s %d voxels extracted in %f\n',subStrSrc,...
        sum(mask(:)), toc(start));
    maptitle = sprintf('sub %d mask',i); 
    vmpblank.Map(curmap) = vmptemp.Map(1);
    brain3d = double(mask); 
    vmpblank.Map(curmap).VMPData = brain3d;
    mapttl = maptitle;
    vmpblank.MAP(curmap).Name = mapttl;
    colorToUse = [255 0 255];
    % set some map properties
    vmpblank.Map(curmap).LowerThreshold = 0;
    vmpblank.Map(curmap).UpperThreshold = 2;
    vmpblank.Map(curmap).UseRGBColor = 0;
    vmpblank.Map(curmap).RGBLowerThreshNeg = colorToUse;
    vmpblank.Map(curmap).RGBUpperThreshNeg = colorToUse;
    vmpblank.Map(curmap).RGBLowerThreshPos = colorToUse ;
    vmpblank.Map(curmap).RGBUpperThreshPos = colorToUse;
    curmap = curmap + 1; 
end
resdir  = settings.resdir_ss_prev_cv; 
resfnew = 'all_subjects_mask_files.vmp'; 
vmpblank.SaveAs(fullfile(resdir,resfnew)); 

