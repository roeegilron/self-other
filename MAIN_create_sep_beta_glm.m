function MAIN_create_sep_beta_glm()
% This functions uses PRTs creates with function names in dir: 
% H:\MRI_Data_self_other\Code\createPRT_Sub_3000
% createPRtsV3.m % create sep beta for each conditions and each trial 
% createPRtsV4_new_prt.m % create one beta for each conditions (collapsing
% on trials). 
% then I use this function to compupte the GLM. 
% then change lines 40 and 41 to work. 

clc
clear all
rootDir = fullfile('..','..','subjects_3000_study');
rootDir = GetFullPath(rootDir);
vtcfnms = findFilesBVQX(fullfile(rootDir,'*3DMC*TAL.vtc'));
for i = 1:length(vtcfnms)
    [pn,fn] = fileparts(vtcfnms{i});
    fprintf('[%.2d]\t%s\n',i,fn);
end
clc
for i = 48:length(vtcfnms) % only do the subjects not processed yet 
    start = tic;
    % load vtc 
    [vtcdir, fn] = fileparts(vtcfnms{i});
    vtc = BVQXfile(vtcfnms{i}); 
    % load prt 
    prtfn = findFilesBVQX(vtcdir,'*sepbeta.prt');
    prt = BVQXfile(prtfn{1});
    opts = struct('prtr',vtc.TR,'nvol',vtc.NrOfVolumes);
    sdm_motion_fnm = findFilesBVQX(vtcdir,'*3DMC.sdm');
    sdm_motion = BVQXfile(sdm_motion_fnm{1});
    sdm = prt.CreateSDM(opts);
    % add motion to this sdm 
    pdnms = sdm.PredictorNames;
    sdm.PredictorNames = [pdnms(1:end-1), sdm_motion.PredictorNames,pdnms(end)];
    sdm.NrOfPredictors = length(sdm.PredictorNames);
    sdm.PredictorColors =  [sdm.PredictorColors; sdm_motion.PredictorColors];
    sdmmat = [sdm.SDMMatrix(:,1:end-1) , sdm_motion.SDMMatrix, sdm.SDMMatrix(:,end)];
    sdm.SDMMatrix = sdmmat;
    % save sdm 
    sdmfn = [sdm.RunTimeVars.CreatedFromPRT(1:end-4) '_with_motion.sdm'];
    sdm.SaveAs(fullfile(vtcdir,sdmfn));
    % compute and save glm 
    glmname = [sdm.RunTimeVars.CreatedFromPRT(1:end-4) '_with_motion.glm'];
    glm = vtc.CreateGLM(sdm);
    glm.SaveAs(fullfile(vtcdir,glmname));
    % clear BVQX objects 
    vtc.ClearObject;
    glm.ClearObject;
    sdm.ClearObject;
    prt.ClearObject;
    sdm_motion.ClearObject;
    clear vtc glm sdm prt sdm_motion
    fprintf('%s in %f\n',glmname, toc(start));
end

end