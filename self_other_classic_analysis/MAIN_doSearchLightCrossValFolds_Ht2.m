function [varargout] = MAIN_doSearchLightCrossValFolds_Ht2(varargin)
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
end
params.regionSize = slSize;
pool = startPool(params);
%% loop on all voxels in the brain to create T map
idx = knnsearch(locations, locations, 'K', params.regionSize);
% preallocate for memory
params.NumTests = 7;
ansMat = zeros(size(idx,1),1+params.numShuffels,params.NumTests);
% compute some intial values
dataDelta = getDeltaOfData(data,labels,params);
% don't run the test on subjects that have zero elements
idxZero = find(sum(dataDelta,1)==0);
if ~isempty(idxZero); % if have zero elements, don't run this sub. 
    varargout{1} = [];
    fprintf('sub %s has %d zeros\n',fnTosave,length(idxZero));
    return 
end

if runRFX
    shufMatrix = createShuffIdxs(data,labels,params);
    % shufMatrix = createShuffIdxsWithReplacement(data,labels,params);
else
    shufMatrix = createShuffMatrixFFX(data,params);
end

try
    fprintf('job took %f seconds to start parfor loop\n',toc(start));
    for i = 1:(params.numShuffels + 1)
        %don't shuffle first itiration
        if i ==1; params.shuffleData=0; else params.shuffleData=1 ;end;
        if ~runRFX && i~=1% = run FFX 
            dataDelta = getDeltaOfDataFFX(data,labels,shufMatrix(:,i-1));
        end
        for (j=1:size(idx,1)) % loop on all voxels in the brain % XXX
            % for j=1:size(idx,1)
            delta = getDeltaFromBeam(dataDelta,labels,idx,j,i,params,shufMatrix,runRFX);
            [ansMat(j,i,:) ] = calcTstatAll(params,delta);
        end
        timeVec(i) = toc(start); reportProgress(fnTosave,i,params, slSize, timeVec)
    end
    
    if runRFX
        fnTosave = [fnTosave '_RFX'];
    else
        fnTosave = [fnTosave '_FFX'];
    end
    
    sl = sprintf('SLsize%d_', params.regionSize);
    save([fnTosave '_results_' sl datestr(clock,30) '.mat'],'-v7.3');
    %     visualizeResults(ansMat,mask,locations,params);
    delete(pool);
catch ME
    save(['crashed_' datestr(clock,30) '.mat'],'-v7.3');
end

if nargin ~= 0 % running over multiple subjects, return ansMat
    varargout{1} = ansMat;
end
end


