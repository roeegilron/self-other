function MAIN_write_data_for_ori_functional_connectivity()
%% This function prepare data for Ori functional conectivity analysis
clc; clear all; close all;
[settings, params ] = get_settings_and_parms();
subDirs = findFilesBVQX(settings.rootdir,'3*',struct('dirs',1,'depth',1)) ;
%% get vtcs 
skipthis = 0;
dat =[];
if ~skipthis
    for i = 1:length(subDirs) % loop on subjects
        start = tic; 
        [runDirs, settings.substr] = getRuns(subDirs{i});
        msk = load_msk(settings);
        run = []; 
        for j = 1:length(runDirs) % loop on runs
            start = tic;
            settings.rundir  = j;
            settings.savedir = runDirs{j};
%             fprintf('sub %s run %d found:\t',...
%                 settings.substr,settings.rundir);            
            prt     = load_prt(settings,runDirs{j});  % load prt
            vtc     = load_vtc(settings,runDirs{j});  % load vtc
            [vtcflat,locations,map] = flatten_vtc(vtc,msk);
            [cursub,currun] = get_sub_run_num(subDirs{i},runDirs{j});
            % get time course foo
            run(j).tc  = get_flat_vtc_per_cond(settings,vtcflat,prt,cursub,currun);  
            %fprintf('sub %s run %d done in %f\n',...
%                 settings.substr,settings.rundir,toc(start));
        end
        save_tc(settings,run,map,locations);
        fprintf('sub %s  done in %f\n',...
            settings.substr,toc(start));
    end
    xff(0,'clearallobjects')
end
%load(fullfile(settings.data_dump_dir,settings.data_dump_fn)); 
end

function [settings, params ] = get_settings_and_parms()
settings.rootdir       = fullfile('..','..','..','MRI_Data_self_other','subjects_3000_study');
settings.vtcsrcprefix  = '*THPGLMF2c_TAL.vtc';
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

function [cursub,currun] = get_sub_run_num(substr,rundirstr)
[pn,fn] = fileparts(substr); 
cursub =['s' fn];
[pn,fn] = fileparts(rundirstr); 
currun = fn;
end

function [runDirs, substr] = getRuns(subdir)
runDirs = findFilesBVQX(fullfile(subdir,'functional'),'run*',struct('depth',1,'dirs',1));
[pn,substr] = fileparts(subdir);
end

function vtc = load_vtc(settings,rundir)
vtc = [];
vtcfn = findFilesBVQX(rundir,settings.vtcsrcprefix);
vtc = BVQXfile(vtcfn{1});
end

function prt = load_prt(settings,rundir)
prt = [];
prtfn = findFilesBVQX(rundir,settings.prtprefix);
prt = BVQXfile(prtfn{1});
end

function msk = load_msk(settings)
dirmask = fullfile(settings.rootdir,settings.substr,'anatomical');
maskfn = sprintf('%s_wb_gm.msk',settings.substr);
msk = BVQXfile(fullfile(dirmask,maskfn));
end

function [vtcflat,locations,map] = flatten_vtc(vtc,mask)
vtcdat = vtc.VTCData;
data = double(vtcdat);
locations = getLocations(mask.Mask);
map = mask.Mask;
for i = 1:size(data,1)
    vtcflat(:,i) = reverseScoringToMatrixForFlat(squeeze(data(i,:,:,:)), locations);
end

end


function tc = get_flat_vtc_per_cond(settings,vtc,prt,cursub,currun)
prtvol = prt.ConvertToVol(settings.tr);
onsets_matrx = prtvol.OnOffsets;
cnt = 1; 
for i = 3:size(prtvol.ConditionNames,1) % interesting conditions start at 3
    idxs = onsets_matrx(onsets_matrx(:,1)==i,2);
    % loop on trials and compute average trials 
    idxuse = [] ;  
    for j = 1:size(idxs,1)
        % get rid of first trial
        if idxs(j)-settings.pointbefore > 0 && idxs(j)+settings.pointafter < size(vtc,2)
            idxuse = [idxuse, idxs(j)-settings.pointbefore:idxs(j)+settings.pointafter];
        end
    end
    tc(cnt).data = zscore(vtc(:,idxuse)')'; % zscore each voxel indepednetly in time course
    tc(cnt).cond = prtvol.ConditionNames{i};
    tc(cnt).cursub           = cursub; 
    tc(cnt).currun           = currun;
    cnt = cnt + 1; 
end
end

function save_tc(settings,run,map,locations)
data_dump_dir = fullfile('..','data','data_ori');
evalc('mkdir(data_dump_dir)');
%% concantenat all run data 
for j = 1:length(run(1).tc)
    tc_concat = []; 
    for i = 1:length(run)
        tc_concat = [tc_concat, run(i).tc(j).data];
    end
    tcout(j).data = tc_concat;
    tcout(j).cond = run(i).tc(j).cond;
    tcout(j).cursub = run(i).tc(j).cursub;
end
% print conds 
% conds = {tcout.cond};
% for i = 1:length(conds)
%     fprintf('%d. %s\n',i,conds{i});
% end
%% save data 

% self 
idxjoin = [4:6];
save_tc_helper(idxjoin,tcout,map,locations,data_dump_dir,'self')
% other 
idxjoin = [1:3];
save_tc_helper(idxjoin,tcout,map,locations,data_dump_dir,'other')
% aronit 
foldsave = 'aronit';
dirsave = fullfile(data_dump_dir,foldsave);
idxjoin = [2 5];
% rashamkol 
foldsave = 'rashamkol';
idxjoin = [3 6];
% traklin 
foldsave = 'traklin';
idxjoin = [1 4];
% self aronit 
foldsave = 'self_aronit';
idxjoin = [5];
% self rashamkol 
foldsave = 'self_rashamkol';
idxjoin = [6];
% self traklin
foldsave = 'self_traklin';
idxjoin = [4];
% other aronit
foldsave = 'other_aronit';
idxjoin = [2];
% other rashmkol
foldsave = 'other_rashmkol';
idxjoin = [3];
% other traklin 
foldsave = 'other_traklin';
idxjoin = [1];

end

function save_tc_helper(idxjoin,tcout,map,locations,data_dump_dir,foldsave)
dirsave = fullfile(data_dump_dir,foldsave);
evalc('mkdir(dirsave)'); 
data = []; 
for i = 1:length(idxjoin)
    data = [data, tcout(idxjoin(i)).data];
end
fnms = sprintf('%s.mat',tcout(1).cursub);
ffs = fullfile(dirsave,fnms);
% fix nans or zeros; 
tmp = sum(data,2);
idxzeros = tmp==0;
data = data(~idxzeros,:);
locations = locations(~idxzeros,:);
map = getMapFromLocations(locations,map);
save(ffs,'data','map','locations');
end
