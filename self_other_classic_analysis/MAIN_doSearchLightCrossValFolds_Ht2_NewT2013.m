function [varargout] = MAIN_doSearchLightCrossValFolds_Ht2_NewT2013(varargin)
start = tic;
params = getParams();
addPathsForServer()
if nargin == 0 % ask user for data
    [ data,locations, mask, labels, fnTosave ] = loadDataForRack();
    slSize = input ('what is the region size? ');
    runRFX = input('run RFX?'); % 1 = run rfx, 0 = run FFX
else
    data = varargin{1};
    locations = varargin{2};
    mask = varargin{3};
    labels = varargin{4};
    fnTosave = varargin{5};
    slSize = varargin{6};
    runRFX = varargin{7};
    params.numShuffels = varargin{8};
    resultsdir = varargin{9};
end
params.regionSize = slSize;

%pool = startPool(params);
%% loop on all voxels in the brain to create T map
idx = knnsearch(locations, locations, 'K', params.regionSize);
% preallocate for memory
params.NumTests = 1;
ansMat = zeros(size(idx,1),1+params.numShuffels,params.NumTests);

shufMatrix = createShuffMatrixFFX(data,params);


fprintf('job took %f seconds to start parfor loop\n',toc(start));
for i = 1:(params.numShuffels + 1)
    %don't shuffle first itiration
    if i ==1 % don't shuffle data
        labelsuse = labels;
    else % shuffle data
        labelsuse = labels(shufMatrix(:,i-1));
    end
    
    parfor j=1:size(idx,1)% loop on all voxels in the brain % XXX
        %     for j=1:size(idx,1)
        dataX = data(labelsuse==1,idx(j,:));
        dataY = data(labelsuse==2,idx(j,:));
        [ansMat(j,i,:) ] = calcTstatMuniMengTwoGroup(dataX,dataY);
        [ansMat(j,i,:) ] = calcTstatAll(params,dataX-dataY);
    end
    timeVec(i) = toc(start); reportProgress(fnTosave,i,params, slSize, timeVec)
end


sl = sprintf('SLsize%d_', params.regionSize);
fnOut = [fnTosave '_results_' sl datestr(clock,30) '.mat'];
save(fullfile(resultsdir,fnOut));
end