function MAIN_compute_data_rois_glm_betas()
close all; clear all; path(pathdef); clc; addpath(genpath(pwd));
%extractData()
extractData_from_vmp() % for gerelization analysis -to extract a sub group within each voxel. 
% extractData_unique_vois();
% assembleDataSelfOther()
% assembleDataWords()
% computeMultiT()
% compSVM()
% computeMultiT_prevelance()
end

function extractData()
%% data preperation
addpath(genpath(GetFullPath( fullfile('..','..','..','Poldrack_RFX_Project','toolboxes','neuroeflf','neuroElf_v10_5153'))));
multiDir = fullfile('..','..','MRI_Data_self_other','subjects_3000_study','results_multi_smoothed');
multiDir = 'H:\MRI_Data_self_other\subjects_3000_study\results_multi_smoothed';
voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_OnlyPeakRegions.voi'; % created manually 
voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_Bonforoni_005.voi'; % created with threshold 
voifn = 'vois_all_s-o_vs_rest_multi_smoothed_defined_from_run1_RFX_FDR0001_150_thresh_with_names.voi'; % created with threshold FDR
voifn = 'vois_all_self_vs_other_multi_smoothed_defined_using_t2013.voi';
data_location = fullfile('..','...','..','MRI_Data_self_other','subjects_3000_study');
data_location = 'H:\MRI_Data_self_other\subjects_3000_study';
roi_data_fold = fullfile('..','data','roi_data_beta_based','raw_data_multit2013_voi'); mkdir(roi_data_fold); 
glm = BVQXfile('H:\MRI_Data_self_other\subjects_3000_study\3000\functional\run1\sub3000_run1_sepbeta_with_motion.glm');
glm_search_str = 'sub%s_run%d_sepbeta_with_motion.glm'; % sub, run
%% transform VOI to be 3x3x3 (e.g. TAL resolution and not iso voxel
voi = BVQXfile(fullfile(multiDir,voifn));
% access to NeuroElf functions
n = neuroelf;
% copy VOI (from object in variable voi)
voic = voi.CopyObject;
% iterate over VOI indices
for vc = 1:numel(voi.VOI)
    
    % assuming the GLM is in variable glm
    voi_indices = n.bvcoordconv(voi.VOI(vc).Voxels, 'tal2bvx', glm.BoundingBox);
    
    % removing NaNs first (out-of-bounding-box voxels)
    voi_indices(isnan(voi_indices)) = [];
    
    % using unique, store into copy
    voi_indices = unique(voi_indices);
    voic.VOI(vc).Voxels = n.bvcoordconv(voi_indices, 'bvx2tal', glm.BoundingBox);
    voic.VOI(vc).NrOfVoxels = numel(voi_indices);
end
%%
%% extract data
subfolders = findFilesBVQX(data_location,'3*',struct('dirs',1,'depth',1));
runs = 1:4;
for voin = 1:numel(voi.VOI)
    for i = 1:length(subfolders)
        for j = 1:length(runs)
            [pn,substr] = fileparts(subfolders{i});
            run_dir = sprintf('run%d',runs(j));
            glmfn = sprintf(glm_search_str,substr,runs(j));
            glm_full_path = fullfile(data_location,substr,'functional',run_dir,glmfn);
            if exist(glm_full_path, 'file') == 2
                glm = BVQXfile(glm_full_path);
                [vb, vbv, vbi] = glm.VOIBetas(voic,struct('vl',voin));
                roi_data = cell2mat(vbv); % voxels x predictors.
                explstr = 'roi_data is voxels x predictors';
                for k = 1:glm.NrOfPredictors
                    predict_names{k} = glm.Predictor(k).Name2;
                end
                fntosave = sprintf('sub-%s_run-%d_roi-%s.mat',substr,runs(j),voi.VOINames{voin});
                fnms_fp  = fullfile(roi_data_fold,fntosave);
                save(fnms_fp,'roi_data','predict_names','explstr','voifn','multiDir');
                glm.ClearObject;
            end
        end
    end
end
end

function extractData_from_vmp()
%% data preperation
addpath(genpath(GetFullPath( fullfile('..','..','..','Poldrack_RFX_Project','toolboxes','neuroeflf','neuroElf_v10_5153'))));
vmpfn = 'vois_all_self_vs_other_multi_smoothed_defined_using_t2013.vmp';
vmpfn = 'roisby_atlas.vmp'; 
vmpfn = 'junk_vois_for_testing.vmp'; 
data_location = 'H:\MRI_Data_self_other\subjects_3000_study';
roi_data_fold = fullfile('..','data','roi_data_beta_based','junk_voi_testing'); mkdir(roi_data_fold); 
glm = BVQXfile('H:\MRI_Data_self_other\subjects_3000_study\3000\functional\run1\sub3000_run1_sepbeta_with_motion.glm');
glm_search_str = 'sub%s_run%d_sepbeta_with_motion.glm'; % sub, run
params.getSubVoxel = 1; % if true get sub voxel of peak beta from each subject 
params.voisize     = 100; 
multiDir = fullfile('..','data','voi_files'); 
vmp = BVQXfile(fullfile(multiDir,vmpfn));

%%
%% extract data
subfolders = findFilesBVQX(data_location,'3*',struct('dirs',1,'depth',1));
runs = 1:4;
for voin = 1:vmp.NrOfMaps% loop on vmp map (start from 2, first map contains all vois); 
    mapvoi = logical(vmp.Map(voin).VMPData);
    for i = 1:length(subfolders)
        [mask,locations] = loadMask(subfolders{i}); 
        for j = 1:length(runs)
            roi_data = [];
            [pn,substr] = fileparts(subfolders{i});
            run_dir = sprintf('run%d',runs(j));
            glmfn = sprintf(glm_search_str,substr,runs(j));
            glm_full_path = fullfile(data_location,substr,'functional',run_dir,glmfn);
            if exist(glm_full_path, 'file') == 2
                glm = BVQXfile(glm_full_path);
                bmaps = double(glm.GLMData.BetaMaps);
                if j == 1 % ensures you have the same location idx for all runs if selecting sub voxel (based on first run) 
                    [locidx, jointmap] = getLocationsFlat(params,mask,mapvoi,locations,glm);
                end 
                locationsVOI = getLocations(jointmap); 
                for b = 1:size(bmaps,4)
                    betaFlat = reverseScoringToMatrix1rowAnsMat(squeeze(bmaps(:,:,:,b)),locations);
                    roi_data(:,b) = betaFlat(locidx);
                end
                explstr = 'roi_data is voxels x predictors';
                for k = 1:glm.NrOfPredictors
                    predict_names{k} = glm.Predictor(k).Name2;
                end
                fntosave = sprintf('sub-%s_run-%d_roi-%s.mat',substr,runs(j),matlab.lang.makeValidName(vmp.Map(voin).Name));
                fnms_fp  = fullfile(roi_data_fold,fntosave);
                save(fnms_fp,'roi_data','predict_names','explstr','vmpfn','multiDir','locidx');
                glm.ClearObject;
            end
        end
    end
end
end

function [locidx, jointmap]  = getLocationsFlat(params,maporig,mapvoi,locations,glm)

if ~params.getSubVoxel % don't get sub voxel 
    % get the locations of the full VOI in flat brain idxs (2d)
    jointmap = logical(maporig) & logical(mapvoi); % in 3d
    jointmapflat = reverseScoringToMatrix1rowAnsMat(jointmap,locations);
    locidx = find(jointmapflat == 1);
else
    % get the flat locations of a sphere arround the highest beta score in the
    % first run of size defines in params
    jointmap = logical(maporig) & logical(mapvoi); % in 3d
    locationsNew = getLocations(jointmap);
    jointmapflat = reverseScoringToMatrix1rowAnsMat(jointmap,locations);
    idxjointmapflat = find(jointmapflat==1);
    % get average beta value 
    for k = 1:glm.NrOfPredictors
        predict_names{k} = glm.Predictor(k).Name2;
    end
    catch_log =  cellfun(@isempty,strfind(predict_names','catch')); % all that is not catch
    bmaps = double(glm.GLMData.BetaMaps);
    avg_bmaps = mean(bmaps(:,:,:,catch_log),4);
    meandata = reverseScoringToMatrix1rowAnsMat(avg_bmaps,locations);
    
    tmp = meandata(jointmapflat); % get all voi data
    [betamax, idxmax] = max(tmp);
    idxformax = idxjointmapflat(idxmax); % in maporig flat space- idx of max voxels. 
    
    idx = knnsearch(locations, locations, 'K', params.voisize); % find searchlight neighbours
    idxVOI = knnsearch(locationsNew, locationsNew, 'K', params.voisize); % find searchlight neighbours
    locationsVOI = locationsNew(idxVOI(idxmax,:),:);
    locationsLinear = sub2ind(size(maporig),locationsVOI(:,1),locationsVOI(:,2),locationsVOI(:,3));
    locationsLinearMapSpace = sub2ind(size(maporig),locations(:,1),locations(:,2),locations(:,3));
    [idxCommon, locidx, ~] = intersect(locationsLinearMapSpace,locationsLinear);
    if length(locidx) < params.voisize % your voi is not big enough, need to to find more voxels: 
        % k nereat neigbors sortrs inidces in ascenting order.
        % problem: 
        % need to find k closest neigbours outside of the ones already
        % existing in roi (which is too small) 
        % solution:
        % find all possible neighbous, and exlude x first neigbours. 
        idx_large = knnsearch(locations, locations, 'K', params.voisize*5); % find searchlight neighbours
        flatidx_large = idx_large(idxformax,:); % large flat idxs 
        [remidxs, ~] = setdiff(flatidx_large,locidx); 
        numvoxmissing = params.voisize - length(locidx);
        locidx = [locidx ; remidxs(1:numvoxmissing)'];
    end
end


end

function extractData_unique_vois()
%% data preperation
addpath(genpath(GetFullPath( fullfile('..','..','..','Poldrack_RFX_Project','toolboxes','neuroeflf','neuroElf_v10_5153'))));
multiDir = fullfile('..','..','..','MRI_Data_self_other','subjects_3000_study','results_multi_smoothed');
data_location = fullfile('..','...','..','MRI_Data_self_other','subjects_3000_study');
data_location = 'H:\MRI_Data_self_other\subjects_3000_study';
roi_data_fold = fullfile('..','data','roi_data_beta_based_unique_voi','raw');
glm = BVQXfile('H:\MRI_Data_self_other\subjects_3000_study\3000\functional\run1\sub3000_run1_sepbeta_with_motion.glm');
glmbbx = glm.BoundingBox;
glm_search_str = 'sub%s_run%d_sepbeta_with_motion.glm'; % sub, run

% base voi with all the regions: 
voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_OnlyPeakRegions.voi';
voi = BVQXfile(fullfile(multiDir,voifn));
% access to NeuroElf functions
n = neuroelf;

%% extract data
subfolders = findFilesBVQX(data_location,'3*',struct('dirs',1,'depth',1));
runs = 2:4;
for i = 1:length(subfolders)
    [pn,fn] = fileparts(subfolders{i});
    unqvoifn = sprintf('%s_unq_vois_based_on_run1_smoothed_self-other_vs_rest.voi',fn);
    voifold = fullfile(subfolders{i},'functional','results_smoothed');
    voisub = BVQXfile(fullfile(voifold,unqvoifn)); 
    %% get unq voi voxels 
    % copy VOI (from object in variable voi)
    voisubunq = voisub.CopyObject;
    % iterate over VOI indices
    for vc = 1:numel(voisub.VOI)
        
        % assuming the GLM is in variable glm
        voi_indices = n.bvcoordconv(voisub.VOI(vc).Voxels, 'tal2bvx', glmbbx);
        
        % removing NaNs first (out-of-bounding-box voxels)
        voi_indices(isnan(voi_indices)) = [];
        
        % using unique, store into copy
        voi_indices = unique(voi_indices);
        voisubunq.VOI(vc).Voxels = n.bvcoordconv(voi_indices, 'bvx2tal', glmbbx);
        voisubunq.VOI(vc).NrOfVoxels = numel(voi_indices);
    end
    %%
    
    for voin = 1:numel(voi.VOI)
        for j = 1:length(runs)
            [pn,substr] = fileparts(subfolders{i});
            run_dir = sprintf('run%d',runs(j));
            glmfn = sprintf(glm_search_str,substr,runs(j));
            glm_full_path = fullfile(data_location,substr,'functional',run_dir,glmfn);
            if exist(glm_full_path, 'file') == 2
                glm = BVQXfile(glm_full_path);
                [vb, vbv, vbi] = glm.VOIBetas(voisubunq,struct('vl',voin));
                roi_data = cell2mat(vbv); % voxels x predictors.
                explstr = 'roi_data is voxels x predictors';
                for k = 1:glm.NrOfPredictors
                    predict_names{k} = glm.Predictor(k).Name2;
                end
                fntosave = sprintf('sub-%s_run-%d_roi-%s.mat',substr,runs(j),voi.VOINames{voin});
                fnms_fp  = fullfile(roi_data_fold,fntosave);
                save(fnms_fp,'roi_data','predict_names','explstr','voifn','multiDir');
                glm.ClearObject;
            end
        end
    end
end
end

function assembleDataSelfOther()
% this is now set up to test for generelization. 
params.normzeroto1 = 1; % if true, normalize the betas from each run between zero to 1. 
addpath(genpath(GetFullPath( fullfile('..','..','..','Poldrack_RFX_Project','toolboxes','neuroeflf','neuroElf_v10_5153'))));
roi_data_fold = fullfile('..','data','roi_data','raw');
roi_data_fold = fullfile('..','data','roi_data_beta_based','raw_data_Bonforoni_cutoff_voi');
roi_data_fold = fullfile('..','data','roi_data_beta_based','raw_data_FDR_cutoff_voi');
roi_data_fold = fullfile('..','data','roi_data_beta_based','raw_data_multit2013_voi');
roi_data_fold = fullfile('..','data','roi_data_beta_based','raw_data_multit2013_voi_100vox-peak');


roi_data_save_fold = fullfile('..','data','roi_data','self-other-roi');
roi_data_save_fold = fullfile('..','data','roi_data_beta_based','self-other-roi-FDR-generalization');
roi_data_save_fold = fullfile('..','data','roi_data_beta_based','self-other-multit2013based-voi100peak-generlization');
mkdir(roi_data_save_fold);

roifns = findFilesBVQX(roi_data_fold,'*.mat');
multiDir = 'H:\MRI_Data_self_other\subjects_3000_study\results_multi_smoothed';
multiDir = fullfile('..','data','voi_files'); 
voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_Bonforoni_005.voi';
voifn = 'vois_all_s-o_vs_rest_multi_smoothed_defined_from_run1_RFX_FDR0001_150_thresh_with_names.voi'; % created with threshold FDR
voifn = 'vois_all_self_vs_other_multi_smoothed_defined_using_t2013.voi';
vmpfn = 'vois_all_self_vs_other_multi_smoothed_defined_using_t2013.vmp';
vmp = BVQXfile(fullfile(multiDir,vmpfn));

runs = 1:4;
subjects = 3000:3022;
for i = 2:vmp.NrOfMaps % first map is not has all vois 
    for s = 1:length(subjects)
        data = [];
        labels = [];
        fold = [];
        for r = 1:length(runs)
            fnload = sprintf('sub-%d_run-%d_roi-%s.mat',...
                subjects(s),runs(r),matlab.lang.makeValidName(vmp.Map(i).Name));
            if exist(fullfile(roi_data_fold,fnload),'file')==2
                load(fullfile(roi_data_fold,fnload));
                self_log  = ~cellfun(@isempty,strfind(predict_names','self'));
                othr_log  = ~cellfun(@isempty,strfind(predict_names','other'));
                catch_log =  cellfun(@isempty,strfind(predict_names','catch')); % all that is not catch 
                fold1_log = ~cellfun(@isempty,strfind(predict_names','Traklin')) & catch_log;
                fold2_log = ~cellfun(@isempty,strfind(predict_names','arnoit')) & catch_log;
                fold3_log = ~cellfun(@isempty,strfind(predict_names','rashamkol'))& catch_log;
                foldRaw = zeros(length(fold1_log),1);
                foldRaw(fold1_log) = 1; 
                foldRaw(fold2_log) = 2; 
                foldRaw(fold3_log) = 3; 
                roi_data = roi_data'; % to make it trials x voxels;
                datarun = [roi_data(self_log,:) ; roi_data(othr_log,:)];
                if params.normzeroto1
                    datarun = (datarun-min(datarun(:))) / (max(datarun(:)) - min(datarun(:)));
                end
                data = [data ; datarun];
                datarun = []; 
                lables_add = [ones(sum(self_log),1); ones(sum(othr_log),1)*2];
                labels = [labels ; lables_add];
                fold = [fold; foldRaw(self_log) ;foldRaw(othr_log)  ];
            end
        end
        save_fn = sprintf('data_sub-%d_voi-%s.mat',...
            subjects(s),...
            matlab.lang.makeValidName(vmp.Map(i).Name));
        save(fullfile(roi_data_save_fold,save_fn),'data','labels','fold');
    end
end

end

function assembleDataWords()
params.normzeroto1 = 1; % if true, normalize the betas from each run between zero to 1. 
addpath(genpath(GetFullPath( fullfile('..','..','..','Poldrack_RFX_Project','toolboxes','neuroeflf','neuroElf_v10_5153'))));
roi_data_fold = fullfile('..','data','roi_data','raw');
roi_data_save_fold = fullfile('..','data','roi_data','aronit-rashamkol-roi');
roi_data_fold = fullfile('..','data','roi_data_beta_based','raw_data_Bonforoni_cutoff_voi');
roi_data_fold = fullfile('..','data','roi_data_beta_based','raw_data_FDR_cutoff_voi');
roi_data_fold = fullfile('..','data','roi_data_beta_based','raw_data_multit2013_voi');
roi_data_fold = fullfile('..','data','roi_data_beta_based','raw_data_multit2013_voi_100vox-peak');

roi_data_save_fold = fullfile('..','data','roi_data_beta_based','words-roi-FDR-generalization');
roi_data_save_fold = fullfile('..','data','roi_data_beta_based','words-multit2013based-generlization');
roi_data_save_fold = fullfile('..','data','roi_data_beta_based','words-multit2013based-voi100peak-generlization');
mkdir(roi_data_save_fold);

roifns = findFilesBVQX(roi_data_fold,'*.mat');
multiDir = 'H:\MRI_Data_self_other\subjects_3000_study\results_multi_smoothed';
multiDir = fullfile('..','data','voi_files'); 

voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_Bonforoni_005.voi';
voifn = 'vois_all_s-o_vs_rest_multi_smoothed_defined_from_run1_RFX_FDR0001_150_thresh_with_names.voi'; % created with threshold FDR
voifn = 'vois_all_self_vs_other_multi_smoothed_defined_using_t2013.voi';
vmpfn = 'vois_all_self_vs_other_multi_smoothed_defined_using_t2013.vmp';
vmpfn = 'vois_all_self_vs_other_multi_smoothed_defined_using_t2013.vmp';
vmp = BVQXfile(fullfile(multiDir,vmpfn));

runs = 1:4;
subjects = 3000:3022;
for i = 2:vmp.NrOfMaps % first map is not has all vois 
    for s = 1:length(subjects)
        data = [];
        labels = [];
        fold = [];
        for r = 1:length(runs)
            fnload = sprintf('sub-%d_run-%d_roi-%s.mat',...
                subjects(s),runs(r),matlab.lang.makeValidName(vmp.Map(i).Name));
            if exist(fullfile(roi_data_fold,fnload),'file')==2
                load(fullfile(roi_data_fold,fnload));
                catch_log =  cellfun(@isempty,strfind(predict_names','catch')); % all that is not catch
                word1 = ~cellfun(@isempty,strfind(predict_names','Traklin')) & catch_log;
                word2 = ~cellfun(@isempty,strfind(predict_names','rashamkol')) & catch_log;
                word3 = ~cellfun(@isempty,strfind(predict_names','arnoit')) & catch_log;
                fold1_log = ~cellfun(@isempty,strfind(predict_names','self')) & catch_log;
                fold2_log = ~cellfun(@isempty,strfind(predict_names','other')) & catch_log;
                foldRaw = zeros(length(fold1_log),1);
                foldRaw(fold1_log) = 1;
                foldRaw(fold2_log) = 2;

                roi_data = roi_data'; % to make it trials x voxels;
                
                datarun = [roi_data(word1,:) ; roi_data(word2,:); roi_data(word3,:)];
                if params.normzeroto1
                    datarun = (datarun-min(datarun(:))) / (max(datarun(:)) - min(datarun(:)));
                end
                data = [data ; datarun];
                lables_add = [ones(sum(word1),1); ones(sum(word2),1)*2 ; ones(sum(word3),1)*3];
                labels = [labels ; lables_add];
                fold = [fold; foldRaw(word1) ;foldRaw(word2) ; foldRaw(word3)  ];
            end
        end
        save_fn = sprintf('data_sub-%d_voi-%s.mat',...
            subjects(s),...
            matlab.lang.makeValidName(vmp.Map(i).Name));
        save(fullfile(roi_data_save_fold,save_fn),'data','labels','fold');
    end
end

end

function computeMultiT()
%% run Multi T on ROIs
% This code run a non-direcitional analysis on ROI's.
% First it runs multi-t on single subject results
% It then averages results across subjects using stelzer permutation
% (shuffling with replament) to compute reults on the second level.
% code should work as is on other computers (relative directory walking)
% and multi-platform (unix/pc/osx);

%% get settings / params
[settings, params] = getparams_multit();

%% run multi T single subject - Non Directional
subjects = 3000:3022;
skipthis = 1;
if ~skipthis
    for i = 1:length(subjects)% loop on subs
        sub_src_str = sprintf('data_sub-%d*.mat',subjects(i));
        roifnms = findFilesBVQX(settings.datalocation,sub_src_str);
        for j = 1:length(roifnms) % loop on rois
            data = loadData(roifnms{j});
            start = tic;
            compMultiT(data,settings,params);
            fprintf('sub %s in roi %s in %f secs\n',...
                data.subnm,data.roinm,toc(start));
        end
    end
end

%% plot multi-t results single subject
plotsinglesubresults(settings,params)

%% compute multi-t second level results
computesecondlevelresults(settings,params)

%% plot second level results
plot_group_results(settings,params)
end

function computeMultiT_prevelance()
%% run Multi T on ROIs
% This code run a non-direcitional analysis on ROI's.
% First it runs multi-t on single subject results
% It then averages results across subjects using stelzer permutation
% (shuffling with replament) to compute reults on the second level.
% code should work as is on other computers (relative directory walking)
% and multi-platform (unix/pc/osx);

%% get settings / params
[settings, params] = getparams_multit();

%% run multi T single subject - Non Directional
subjects = 3000:3022;
skipthis = 0;
if ~skipthis
    for i = 1:length(subjects)% loop on subs
        sub_src_str = sprintf('data_sub-%d*.mat',subjects(i));
        roifnms = findFilesBVQX(settings.datalocation,sub_src_str);
        for j = 1:length(roifnms) % loop on rois
            sub(i).roi(j).data = loadData(roifnms{j});
        end
    end
end

numtrials = [10:5:45];
for v = 1:length(sub(1).roi) % loop on roi
    cnts = 1; 
    for nt = 1:length(numtrials) % loop on trials
        for s = 1:length(sub); % loop on subject
            trialsuse = numtrials(nt);
            data = sub(s).roi(v).data.data;
            labels = sub(s).roi(v).data.labels;
            x = data(labels==1,:);
            y = data(labels==2,:);
            idxx = floor(linspace(1,size(x,1),trialsuse));
            idxy = floor(linspace(1,size(y,1),trialsuse));
            xuse = x(idxx,:);
            yuse = y(idxy,:);
            mnm = calcTstatMuniMengTwoGroup(xuse,yuse);
            roi(v).reslts(cnts,1) = mnm(1);
            roi(v).reslts(cnts,2) = numtrials(nt); 
            roi(v).name = sub(s).roi(v).data.roinm;
            cnts = cnts + 1; 
        end
    end
end
%% write data to csv 
outdir = fullfile(pwd,'words-prev-100x-gener'); 
mkdir(outdir);
for i = 1:length(roi)
    fn = sprintf('%s.csv',roi(i).name);
    fnwrite = fullfile(outdir,fn);
    csvwrite(fnwrite,roi(i).reslts); 
    mn = sprintf('%s.mat',roi(i).name);
    mnwrite = fullfile(outdir,mn);
    data = roi(i).reslts; 
    name = roi(i).name;
    save(mnwrite,'data','name'); 
end
% 
% %% plot multi-t results single subject
% plotsinglesubresults(settings,params)
% 
% %% compute multi-t second level results
% computesecondlevelresults(settings,params)
% 
% %% plot second level results
% plot_group_results(settings,params)
end

function plotregionschosen() 
[settings, params] = getparams_svm();

multiDir = fullfile('..','data','voi_files'); 
vmpfn = 'vois_all_self_vs_other_multi_smoothed_defined_using_t2013.vmp';
vmp = BVQXfile(fullfile(multiDir,vmpfn));
subjects = 3000:3022;
data_location = fullfile('..','..','..','MRI_Data_self_other','subjects_3000_study');
subfolders = findFilesBVQX(data_location,'3*',struct('dirs',1,'depth',1));

for v = 2:vmp.NrOfMaps
    for i = 1:length(subfolders)% loop on subs
        sub_src_str = sprintf('data_sub-%d*%s.mat',subjects(i),...
            matlab.lang.makeValidName(vmp.Map(v).Name));
        [mask,locations] = loadMask(subfolders{i});
        roifnms = findFilesBVQX(settings.datalocation,sub_src_str);
        data = loadData(roifnms{1}); % just take first one since location same for all
        for j = 1:length(roifnms) % loop on rois
            data = loadData(roifnms{j});
            start = tic;
            compMultiT(data,settings,params);
            fprintf('sub %s in roi %s in %f secs\n',...
                data.subnm,data.roinm,toc(start));
        end
    end
end


end 


function compSVM()
%% run SVM on ROIs
% This code run a non-direcitional SVM on ROI's.
% First it runs svm on single subject results
% It then averages results across subjects using stelzer permutation
% (shuffling with replament) to compute reults on the second level.
% code should work as is on other computers (relative directory walking)
% and multi-platform (unix/pc/osx);

%% get settings / params
[settings, params] = getparams_svm();

%% run multi SVM single subject - Non Directional
subjects = 3000:3022;
skipthis = 0;
if ~skipthis
    for i = 1:length(subjects)% loop on subs
        sub_src_str = sprintf('data_sub-%d*.mat',subjects(i));
        roifnms = findFilesBVQX(settings.datalocation,sub_src_str);
        for j = 1:length(roifnms) % loop on rois
            data = loadData(roifnms{j});
            start = tic;
            computeSVM(data,settings,params);
            fprintf('sub %s in roi %s in %f secs\n',...
                data.subnm,data.roinm,toc(start));
        end
    end
end

%% plot regions chosen in vmp files 
plotregionschosen(settings,params) 

%% plot multi-t results single subject
plotsinglesubresults(settings,params)

%% compute multi-t second level results
computesecondlevelresults(settings,params)

%% plot second level results
plot_group_results(settings,params)
end

function [voic] = getVOIunq(voi,bbx)
%% transform VOI to be 3x3x3 (e.g. TAL resolution and not iso voxel
% access to NeuroElf functions
n = neuroelf;
% copy VOI (from object in variable voi)
voic = voi.CopyObject;
% iterate over VOI indices
for vc = 1:numel(voi.VOI)
    
    % assuming the GLM is in variable glm
    voi_indices = n.bvcoordconv(voi.VOI(vc).Voxels, 'tal2bvx', bbx);
    
    % removing NaNs first (out-of-bounding-box voxels)
    voi_indices(isnan(voi_indices)) = [];
    
    % using unique, store into copy
    voi_indices = unique(voi_indices);
    voic.VOI(vc).Voxels = n.bvcoordconv(voi_indices, 'bvx2tal', bbx);
    voic.VOI(vc).NrOfVoxels = numel(voi_indices);
end
%%
end

function [mask,locations] = loadMask(subfold)
[pn,fn] = fileparts(subfold); 
strcstr = sprintf('%s_wb_gm.msk',fn); 
mskfn = findFilesBVQX(fullfile(subfold,'anatomical'),strcstr); 
msk = BVQXfile(mskfn{1}); 
mask = logical(msk.Mask); 
locations  = getLocations(mask);
end