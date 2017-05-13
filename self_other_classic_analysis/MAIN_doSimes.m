function MAIN_doSimes(varargin)
maxNumCompThreads(1);% XXX remove if doing parfor 
if nargin==2
    subnum = varargin{1} ;
    minwait = 19;
    timewait = (varargin{2}-1)*minwait*60; % each shuffle takes 30 min.
    pause(timewait);
else
    subnum = varargin{1} ;
end
numshufs = 1e3;
datadir = '/home/rack-hezi-03/home/roigilro/OriData2';
%datadir = '/home/rack-hezi-01/home/roigilro/data/vocal_data_set/stats_normalized_sep_beta_ar3';
%datadir = 'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta_ar3';
datadir = '/home/hezi/roee/ActivePassiveLH/';
p = genpath('/home/rack-hezi-01/home/roigilro/');
addpath(p);
slSize = 27;

%fn = sprintf('data_%.3d.mat',subnum);
fn = sprintf('ssubj%d_ForServer_n.mat',subnum); % XXX 
load(fullfile(datadir,fn));



%parpool('local',15);


start=tic;
data = data;
labels = labels'; % XXX only for Ori data 
alldat = zeros(size(data,2),numshufs+1);
for k = 1:numshufs+1;
    if k == 1;
        labelsuse = labels;
    else
        labelsuse(k,:) = labels(randperm(length(labels)));
    end
    
    for j = 1:size(data,2) % loop on voxels
        [alldat(j,k)] = ttest2_roee_fast(data(labelsuse(k,:)==1,j),data(labelsuse(k,:)==2,j));
    end
end
fprintf('sub %s done in %f\n',fn,toc(start));

%delete(gcp);
fnTosave = sprintf('results_simes_%.3d_%d_shuf',subnum,numshufs);
resultsDir = datadir;
fnOut = [fnTosave '.mat'];
save(fullfile(resultsDir,fnOut));
msgtitle = sprintf('Finished sub %.3d ',subnum);
%mailFromMatlab(msgtitle,'-');

end
