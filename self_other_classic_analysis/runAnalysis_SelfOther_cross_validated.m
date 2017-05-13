function runAnalysis_SelfOther_cross_validated(varargin)
%% this function averages multi-t scores across runs 
maxNumCompThreads(1);
cd('..');
addpath(genpath(pwd));
cd('self_other_classic_analysis');
[settings,params] = get_settings_params_self_other(); 

if isempty(varargin)
    subuse = 3000;
else
    subuse = varargin{1}; 
end

[data, labels, runag,map] = getDataPerSubAllBrain(subuse,settings,params);
locations = getLocations(map);
% take zeros out of data by run, labels 
[dataclean, mapclean, locationsclean] = cleanData(data,runag, map);
idx = knnsearch(locationsclean, locationsclean, 'K', params.regionSize);
unqruns = unique(runag);
startrun = tic; 
for ucv = 1:length(unqruns)
    data_cv = dataclean(runag == unqruns(ucv),:);
    % extract zeros from data:
%     data_cv = data_cv(:,sum(data_cv,1)~=0);
    labels_cv = labels(runag == unqruns(ucv),:);
    cvtimer = tic;
    for sl = 1:size(idx,1)  % loop on sl 
        datause = data_cv(:,idx(sl,:));
        for s = 1: params.numshufs + 1 
            labelsuse = getlabels(labels_cv,s,ucv); 
            ansMat(sl,s,ucv) = calcTstatMuniMengTwoGroup_v2(datause(labelsuse==1,:),datause(labelsuse==2,:));
        end
    end
    fprintf('sub %d took %f to run %d shufs in one cv run\n',...
        subuse,toc(cvtimer), params.numshufs);
end
mask = mapclean; 
locations = locationsclean;
fnsmv = sprintf('ND_FFX_s-%d_shufs-%d_cross_validate_newMultit.mat',...
    subuse,params.numshufs);
fldrsv = settings.resdir_ss_prev_cv;
fnmsvfull = fullfile(fldrsv,fnsmv); 
save(fnmsvfull,'ansMat','mask','locations'); 

fprintf('sub %d took %f to run %d shufs\n',...
    subuse,toc(startrun), params.numshufs);

end

function labelsout = getlabels(labels,s,ucv)
if s ==1 % don't shuffle 
    labelsout = labels; 
else
    runfac = ucv * 1000; % so don't get same shuf across runs 
    seeduse = s + runfac; 
    rng(seeduse); 
    shufidx = randperm(length(labels));
    labelsout = labels(shufidx); 
end
end

function [dataout, mapout, locationsout] = cleanData(data,runag, map)
dataout = []; mapout = [] ; badidx = [];
unqruns = unique(runag);
for ucv = 1:length(unqruns)
    data_cv = data(runag == unqruns(ucv),:);
    zerocnt = data_cv == 0;
    zercntmat = sum(zerocnt,1); % a bad voxel has more than 10 zeros 
    badidx = [badidx; find(zercntmat > 10)'];     
end
badidx = unique(badidx); 
locations = getLocations(map);
goodidx   = setdiff(1:size(locations,1),badidx);
locationsout =  locations(goodidx,:);
mapout = zeros(size(map));
for i = 1:size(locationsout,1)
    mapout(locations(i,1),locations(i,2),locations(i,3)) = 1;
end
dataout = data(:,goodidx);

end

