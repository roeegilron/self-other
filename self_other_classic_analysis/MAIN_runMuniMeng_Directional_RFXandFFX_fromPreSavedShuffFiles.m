function MAIN_runMuniMeng_Directional_RFXandFFX_fromPreSavedShuffFiles()
% [filesFoundInDir, dirName ]  = loadDirForRack();
% mkdir(fullfile(pwd,dirName));
start = tic;
%% set params:
params = getParams();
numShuffels = 1e3;
slSize = 27;
numsubs = input('how many subs do you want to run?\n');
cvFold = input('what cvfold do you want to run?\n');
%%
infMethod = {'RFX','FFX'};
pool = startPool(params);
for z = 1:length(infMethod)
    %% load data
    fltoload  = sprintf('precomputed_Directional_%s_Data_%d-subs_1000-shufs_cvFold%d',...
        infMethod{z},numsubs,cvFold);
    fntosave = ['results_' fltoload];
    load(fltoload);
    datafn = sprintf('%sData',lower(infMethod{z}));
    preshuffeddata = eval(datafn);
    eval(['clear('   '''' datafn ''''   ')'])
    %% get neibours 
    idx = knnsearch(locations, locations, 'K', params.regionSize);
    %% do shuffles 
    for i = 1:numShuffels + 1;
        deltaData = squeeze(preshuffeddata(:,:,i));
        %% loop on brain 
        parfor j = 1:size(idx,1) % loop on all voxels in the brain % XXX
            % for j=1:size(idx,1)
            delta = deltaData(:,idx(j,:));
            [ansMat(j,i,:) ] = calcTstatAll(params,delta);
        end
        timeVec(i) = toc(start); reportProgress(fnTosave,i,params, slSize, timeVec)
    end
    
    save([fntosave '.mat'],...
        'ansMat','mask','locations','params','subsExtracted','-v7.3');
    clear ansMat mask locations subsExtracted
end
end