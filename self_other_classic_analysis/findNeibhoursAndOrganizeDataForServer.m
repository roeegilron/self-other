function findNeibhoursAndOrganizeDataForServer(all_data,labels,map,params,locations,vtcRes,subjectName)
if params.saveDataForServer % check if should go through the save the data for the server
    vtcRes = params.vtcResolution;
    %% employ the search light to create the data needed for the server
    startT = tic;
    fprintf('started saving data for server for subject %s at %s\n',subjectName,datestr(clock))
    idx = knnsearch(locations, locations, 'K', params.searchLightSize);
    % inizialize giant data structire 
    numVoxels = size(all_data,2);
    numTrials = size(all_data,1);
    slSize = params.searchLightSize;
    data = zeros(numTrials,slSize,numVoxels);
    for v = 1:size(idx,1);
        data(:,:,v) = all_data(:, idx(v,:)); % important to make sure you loop on v - before hand was idx(1,:) whic is a mistake....
    end
    factor = ones(1,size(all_data,1));
    if params.useSaveFast
        savefast(fullfile(params.outputDir,[subjectName params.fileNameSuffixForSavingDataForServer]),...
            'data','factor','labels','map','locations','params','vtcRes','subjectName')
    else
        save(fullfile(params.outputDir,[subjectName params.fileNameSuffixForSavingDataForServer]),...
            'data','factor','labels','map','locations','params','vtcRes','subjectName','-v7.3')
    end
    fprintf('finished saving data for server for subject %s at %s\n',subjectName,datestr(clock))
end

end