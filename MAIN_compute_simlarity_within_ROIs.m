function MAIN_compute_simlarity_within_ROIs()
%% This function runs simalarity analysis within ROI's 
%% Finally it produces figures with simalrity measures 
clc; clear all; close all;
[settings, params ] = get_settings_and_parms();
subDirs = findFilesBVQX(settings.rootdir,'3*',struct('dirs',1,'depth',1)) ;
skipthis = 1;
dat =[];
if ~skipthis
    for i = 1:length(subDirs) % loop on subjects
        [runDirs, settings.substr] = getRuns(subDirs{i});
        for j = 1:length(runDirs) % loop on runs
            start = tic;
            settings.rundir  = j;
            settings.savedir = runDirs{j};
            prt     = load_prt(settings,runDirs{j});  % load prt
            vtc     = load_vtc(settings,runDirs{j});  % load vtc
            voi     = load_voi(settings);  % load voi (reload same each run bcs clearing objects);
            for vn = 1:voi.NrOfVOIs
                settings.voinm = voi.VOINames{vn};
                voitc   = load_voi_tc(settings,vtc,voi); % extract voitc
                [cursub,currun] = get_sub_run_num(subDirs{i},runDirs{j});
                tc_voi  = get_avg_tc_per_condition_voi(settings,vtc,voi,voitc,prt,cursub,currun);  % get average time course from each run and each condition
                fns = sprintf('%s_%s_voi-%s.mat',...
                    tc_voi(1).cursub,tc_voi(1).currun,tc_voi(1).voiname);
                save(fullfile(settings.data_dump_dir,fns),'tc_voi');
            end
            fprintf('sub %s run %d done in %f\n',...
                settings.substr,settings.rundir,toc(start));
        end
    end
    xff(0,'clearallobjects')
    fns = fullfile(settings.data_dump_dir,settings.data_dump_fn);
    save(fns,'dat');
end
%load(fullfile(settings.data_dump_dir,settings.data_dump_fn)); 
average_runs_and_run_simalarity(dat,settings);
end

function [settings, params ] = get_settings_and_parms()
settings.rootdir       = fullfile('..','..','..','MRI_Data_self_other','subjects_3000_study');
settings.vtcsrcprefix  = '*TAL_SD3DVSS6.00mm.vtc';
settings.prtprefix     = '*7conds_mar_2016*.prt';
settings.sdmrawprefix  = '*with_motion_7_conds.sdm';
settings.voi_use       = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_OnlyPeakRegions.voi';
settings.resultsdir    = fullfile(settings.rootdir,'results_multi_smoothed');
settings.data_dump_dir = fullfile('..','data','roi_data_from_vtc');
settings.data_dump_fn  = 'raw_data_pattern_roi_trials_averaged.mat';
settings.figfold       = fullfile('..','figures','simalarity_based_on_vtc');
settings.voinm         = 'SPL-R';
settings.tr            = 2500;
settings.sdmprefix     = 'sub*functional_connectivity_with_motion.sdm';
settings.seclevdir     = 'results_multi_smoothed';
settings.subsuse       = [3000:3005, 3007:3011, 3013:3014 3016:3022];
settings.runuse        = [2:4];
settings.pointbefore   = 1; % time (vol) to extract before trial start 
settings.pointafter    = 5; % time (vol) to extract after trial start 
% 'visaul_R'    'visual_L'    'premotor_L'
% 'premotor_R'    'SMA-bilateral'    'visual-R-posterior'
% 'visual-L-posterior'    'SPL-L'    'SPL-R'
params = [];
end

function voi = load_voi(settings)
fnmload = fullfile(settings.resultsdir,settings.voi_use);
voi = BVQXfile(fnmload);
end

function sdm_raw = load_raw_sdm(settings,rundir)
sdmfn = findFilesBVQX(rundir,settings.sdmrawprefix);
sdm_raw = BVQXfile(sdmfn{1});
end

function vtc = load_vtc(settings,rundir)
vtcfn = findFilesBVQX(rundir,settings.vtcsrcprefix);
vtc = BVQXfile(vtcfn{1});
end

function prt = load_prt(settings,rundir)
prtfn = findFilesBVQX(rundir,settings.prtprefix);
prt = BVQXfile(prtfn{1});
end

function [runDirs, substr] = getRuns(subdir)
runDirs = findFilesBVQX(fullfile(subdir,'functional'),'run*',struct('depth',1,'dirs',1));
[pn,substr] = fileparts(subdir);
end

function voitc = load_voi_tc(settings,vtc,voi)
% %% get the unique voxels 
% access to NeuroElf functions
n = neuroelf;

% copy VOI (from object in variable voi)
voic = voi.CopyObject;

% iterate over VOI indices
for vc = 1:numel(voi.VOI)
    
    % assuming the GLM is in variable glm
    voi_indices = n.bvcoordconv(voi.VOI(vc).Voxels, 'tal2bvx', vtc.BoundingBox);
    
    % removing NaNs first (out-of-bounding-box voxels)
    voi_indices(isnan(voi_indices)) = [];
    
    % using unique, store into copy
    voi_indices = unique(voi_indices);
    voic.VOI(vc).Voxels = n.bvcoordconv(voi_indices, 'bvx2tal', vtc.BoundingBox);
    voic.VOI(vc).NrOfVoxels = numel(voi_indices);
end

%% get the time course: 

voitc = [] ;
[voitc, voin] = vtc.VOITimeCourse(voic,...
    struct('weight',2,...
    'voisel',settings.voinm));
voitc = cell2mat(voitc);% time x voxels 
end

function tc = get_avg_tc_per_condition_voi(settings,vtc,voi,voitc,prt,cursub,currun)
prtvol = prt.ConvertToVol(settings.tr);
onsets_matrx = prtvol.OnOffsets;
cnt = 1; 
for i = 3:size(prtvol.ConditionNames,1) % rel condition name starts at 3
    idxs = onsets_matrx(onsets_matrx(:,1)==i,2);
    % loop on trials and compute average trials 
    cnttc = 1; 
    for j = 1:size(idxs,1)
        % get rid of first trial
        if idxs(j)-settings.pointbefore > 0 && idxs(j)+settings.pointafter < size(voitc,1)
            rawtc(:,:,cnttc) = voitc(idxs(j)-settings.pointbefore:idxs(j)+settings.pointafter,:);
            % rawtc is [time points x voxels x trials]
            cnttc = cnttc + 1; 
        end
    end
    meantc = mean(rawtc,3); % average trials [time points x voxels] 
    meanvoitc = mean(meantc,2);
    tc(cnt).meantc_pattern   = meantc(:); % linerized 
    tc(cnt).zmeantc_pattern  = zscore(meantc(:));
    tc(cnt).meantc           = meanvoitc;
    tc(cnt).zmeantc          = zscore(meanvoitc);
    tc(cnt).condname         = prtvol.ConditionNames{i};
    tc(cnt).voisize          = size(rawtc,2);
    tc(cnt).cursub           = cursub; 
    tc(cnt).currun           = currun;
    tc(cnt).voiname          = settings.voinm;
    cnt = cnt + 1; 
end
end

function save_sdm_fnc(sdm_fnc,settings)
%sub3015_run3_sepbeta_with_motion
dirsave = settings.savedir;
fnmsv = sprintf('sub%s_run%d_functional_connectivity_with_motion.sdm',...
    settings.substr,settings.rundir);
flfnmnsv = fullfile(dirsave,fnmsv);
sdm_fnc.SaveAs(flfnmnsv);

end

function mdm_trimed = trim_mdm(mdm,settings)
xtcrtc = mdm.XTC_RTC;
cnt = 1; 
for i = 1:length(settings.subsuse)
    for j = 1:length(settings.runuse)
        srcstr = sprintf('%d_run%d_',...
            settings.subsuse(i),settings.runuse(j));
        idxuse = find(~cellfun(@isempty,strfind(xtcrtc(:,1),srcstr))==1);
        xtc_new{cnt,1} = xtcrtc{idxuse,1};
        xtc_new{cnt,2} = xtcrtc{idxuse,2};
        cnt = cnt +1; 
    end
end

mdm_trimed = xff('mdm'); % open an MDM for each subjects
mdm_trimed.XTC_RTC  = xtc_new; 
mdm_trimed.NrOfStudies = size(mdm_trimed.XTC_RTC,1);
mdm_trimed.SeparatePredictors = 2; % concatenate predictors across runs but not across subjects
mdm_trimed.zTransformation = 1;
mdm_trimed.PSCTransformation = 0;
mdm_trimed.RFX_GLM = 1; % perform FFX at first
mdmfn = 'some_subs_functional_connectivity_7_conds_RFX.mdm';
mdm_trimed.SaveAs(fullfile(settings.rootdir,settings.seclevdir,mdmfn));
end

function compute_GLM(mdm,settings)
glm = mdm.ComputeGLM();
glmfn =  'some_subs_functional_connectivity_7_conds_RFX.glm';
glm.SaveAs(fullfile(settings.rootdir,settings.seclevdir,glmfn))
end

function voic     = getUnqVoxels(voiin,vtc)
% access to NeuroElf functions
n = neuroelf;

% copy VOI (from object in variable voi)
voic = voiin.CopyObject;

% iterate over VOI indices
for vc = 1:numel(voiin.VOI)
    
    % assuming the GLM is in variable glm
    voi_indices = n.bvcoordconv(voiin.VOI(vc).Voxels, 'tal2bvx', vtc.BoundingBox);
    
    % removing NaNs first (out-of-bounding-box voxels)
    voi_indices(isnan(voi_indices)) = [];
    
    % using unique, store into copy
    voi_indices = unique(voi_indices);
    voic.VOI(vc).Voxels = n.bvcoordconv(voi_indices, 'bvx2tal', vtc.BoundingBox);
    voic.VOI(vc).NrOfVoxels = numel(voi_indices);
end

end

function [cursub,currun] = get_sub_run_num(substr,rundirstr)
[pn,fn] = fileparts(substr); 
cursub =['s' fn];
[pn,fn] = fileparts(rundirstr); 
currun = fn;
end

function average_runs_and_run_simalarity(dat,settings)
measuresuse = {'meantc_pattern','zmeantc_pattern','meantc','zmeantc'};
rtdir = settings.data_dump_dir;
voi     = load_voi(settings);
voinames = voi.VOINames;
for k = 1:length(measuresuse) % loops on measure computed 
    for v = 1:length(voinames) % loop on vois 
        forRDM = []; 
        subcnt = 1;
        for i = settings.subsuse % loop on subjects 
            tmp = []; runcnt = 1; 
            for j = settings.runuse
                fnload =  sprintf('s%d_run%d_voi-%s.mat',...
                    i,j,voinames{v});
                load(fullfile(rtdir,fnload));
                for c = 1:length(tc_voi) % loop on condition
                    tmp(:,runcnt,c) = tc_voi(c).(measuresuse{k}); 
                    connames{c} = tc_voi(c).condname;
                    % tmp is [voxels x runs x condition] 
                end
                runcnt = runcnt + 1;
            end
            forRDM(:,:,subcnt) = squeeze(mean(tmp,2));
            subcnt = subcnt + 1; 
        end
        outdat(v).forRDM = forRDM;
        outdat(v).measureuse = measuresuse{k};
        outdat(v).measurenum = k;
        outdat(v).voiname = voinames{v};
        outdat(v).connames = connames;

    end
    computeSimalarity(outdat,settings); 
end


end

function computeSimalarity(outdat,settings)
savefigs = 1; 
voinames = {outdat.voiname};
condnames = {'Ot','Oa','Or','St','Sa','Sr'};
measurenum = outdat(1).measurenum ;
measureuse = outdat(1).measureuse ;
fold2save = settings.figfold;
for voin = 1:length(voinames) % loop on voi name 
    
    forRDM = outdat(voin).forRDM;
    figtitle = sprintf('%s (%s)',...
        strrep(voinames{voin},'_',' '),...
        strrep(measureuse,'_',' '));

    conditions = condnames;
    
    for s=1:size(forRDM,3)
        D_subjects(:,:,s) = pdist(forRDM(:,:,s)','minkowski');
    end
    D = mean(D_subjects,3);
    
    try 
        Y1=mdscale(D,2); flag = ' ';
    catch 
        Y1=mdscale(D,2,'criterion','metricsstress'); flag ='f';
    end
    
    
    % MDS
    fig_mds = figure('visible','off');
    scatter(Y1(:,1),Y1(:,2),1e-2)
    text(Y1(:,1),Y1(:,2),conditions,'fontsize',8)
    set(fig_mds,'Color',[1 1 1])
    title([figtitle ' ' flag]);
    axis off
    figname = sprintf('%d_%s_%s_%s.jpeg',...
        measurenum,...
        'MDS',...
        voinames{voin},...
        measureuse);
    if savefigs; saveas(fig_mds,fullfile(fold2save,figname)); end;
    close(fig_mds);
    
    % Similarity matrix
    %distance_mat = squareform(D);
    distance_mat = squareform((( D- min(D) ) / ( max(D) - min(D) ) ) + 0.5);
    similarity_mat = exp(-distance_mat)*100;
    fig_sim = figure('visible','off');
    imagesc(distance_mat); % used to be simlarity_mat
    % caxis([16.39 22.57])
    colormap redbluecmap
    set(gca,'xtick',1:length(conditions),'xticklabels', conditions);
    set(gca,'ytick',1:length(conditions),'yticklabels', conditions);
    set(gcf,'Color',[1 1 1])
    title(figtitle);
    figname = sprintf('%d_%s_%s_%s.jpeg',...
        measurenum,...
        'sim_matrix',...
        voinames{voin},...
        measureuse);
    if savefigs; saveas(fig_sim,fullfile(fold2save,figname)); end;
    close(fig_sim);
    
    % % Dendograms
    fig_tree=figure('visible','off');
    tree = linkage(D,'single');
    [H,T,outperm] = dendrogram(tree);
    set(gca,'xticklabel',conditions(outperm));
    set(gcf,'Color',[1 1 1]);
    title(figtitle);
    figname = sprintf('%d_%s_%s_%s.jpeg',...
        measurenum,...
        'dendograms',...
        voinames{voin},...
        measureuse);
    if savefigs; saveas(fig_tree,fullfile(fold2save,figname)); end;
    close(fig_tree);

end
end


