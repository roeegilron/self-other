function MAIN_doSearchLightCrossValFolds_Ht2_NewT2013_subproc(varargin)
maxNumCompThreads(1);% XXX remove if doing parfor 
if nargin==2
subnum = varargin{1} ;
minwait = 60*3;
timewait = (varargin{2}-1)*minwait*60; % each shuffle takes 30 min. 
pause(timewait);
else
subnum = varargin{1} ;
end
datadir = '/home/rack-hezi-01/home/roigilro/data/vocal_data_set/stats_normalized_sep_beta_ar3';
resdir  = '/home/hezi/roee/vocalDataSet/extractedDataVocalDataSet/stats_normalized_sep_beta_FIR_ar3';
%datadir = '/home/rack-hezi-03/home/roigilro/OriData1'; % XXX 

%datadir =  '/home/hezi/roee/Zscored_OriData/ActivePassiveLH';
%datadir =  '/home/hezi/roee/Zscored_OriData/ActivePassiveLH';
%datadir =  '/home/hezi/roee/vocalDataSet/extractedDataVocalDataSet/stats_normalized_sep_beta_FIR_ar3'
%datadir = '/home/rack-hezi-01/home/roigilro/data/self_other/words'
[pn,fnuse] = fileparts(datadir);
p = genpath(pwd);
addpath(p);
slSize = 27; % XXX 

fn = sprintf('data_%.3d.mat',subnum);
%fn = sprintf('ssubj%d_ForServer_n.mat',subnum); % 
%fn = sprintf('data_%d.mat',subnum);
load(fullfile(datadir,fn));
params = getParams();
addPathsForServer()
params.numShuffels = 400; % change to 400 XXX
params.regionSize = slSize;
params.permMode = 'reg'; %perms can be local or reg 
params.serial = 'sep_beta_BV';
data = data;

fnTosave = sprintf('mt_results_%s_FFX_ND_norm_%dshuf_SL%d_sub_%.3d_%s_perm_%s',...
		fnuse,params.numShuffels,slSize,subnum,params.permMode,params.serial);
resultsDir = fullfile(resdir, sprintf('results_%s_FFX_ND_norm_%dshuf_SL%d_%s_perm_%s',...
		fnuse,params.numShuffels,slSize,params.permMode,params.serial));
%resultsDir = fullfile(datadir,'mtresultsOriData2');

mkdir(resultsDir);

%% loop on all voxels in the brain to create T map
start = tic;
%% XXXX THIS PURGES ZERO VOXELS 
% load(fullfile(datadir,'idxzerosall153subs.mat'));
% idxskeep = setdiff(1:size(locations,1),idxzer);
% locations = locations(idxskeep,:);
%% XXXX 
idx = knnsearch(locations, locations, 'K', params.regionSize);
% preallocate for memory
params.NumTests = 1;
%ansMat = zeros(size(idx,1),1+params.numShuffels,params.NumTests);
shufMatrix = createShuffMatrixFFX(data,params);
%pool = parpool('local',20);
for i = 1:(params.numShuffels + 1) % loop on shuffels 
    %don't shuffle first itiration
    if i ==1 % don't shuffle data
        labelsuse = labels;
    else % shuffle data
        labelsuse = labels(shufMatrix(:,i-1));
    end
    
    %% XXXXXX ARBITRARY PAIRING 
%    [idxX, idxY, pairingname ] = getRealLabelIdxsDiffPairings(i) ;
	idxX = find(labelsuse==1);
%	idxX = idxX(randperm(length(idxX)));
	idxY = find(labelsuse==2);
%        idxY = idxY(randperm(length(idxX)));
    %%%%%% 
    for j=1:size(idx,1) % loop onvoxels 
        dataX = data(idxX,idx(j,:));
        dataY = data(idxY,idx(j,:));
        [ansMat(j,i,:) ] = calcTstatMuniMengTwoGroup(dataX,dataY);
        %[ansMatOld(j,i,:) ] = calcTstatAll(params,dataX-dataY);
        %[ansMatSVM(j,i,:) ] = calcSVM(dataX,dataY);
    end
    timeVec(i) = toc(start); reportProgress(fnTosave,i,params, slSize, timeVec);
end
%delete(pool);
fnOut = [fnTosave  '.mat'];
save(fullfile(resultsDir,fnOut));
pause(1);
msgtitle = sprintf('Finished sub %d ',subnum);
mailFromMatlab(msgtitle,'-');
end
