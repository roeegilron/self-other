    function create_vmp_from_second_level_files(settings,params)
%% plot the vmp from all second level files 
% find all the .mat file 
vmpfn = findFilesBVQX(settings.resfold,settings.nameOfTempVMP);
rawvmp = BVQXfile(vmpfn{1});
% find all results files 
matfilprefixs = findFilesBVQX(settings.resfold,[settings.seclevelprefix '*.mat']);

for i = 1:length(matfilprefixs)
    start = tic;
    tosavevmp = rawvmp; 
    load(matfilprefixs{i});
    [pn, fn] = fileparts(matfilprefixs{i});
    pval = calcPvalVoxelWise(avgAnsMat);
    sigfdr = fdr_bh(pval,0.05,'pdep','yes');
    % compute neighbours: 
    tmp = regexp(fn,'[0-9]+-slsze','match');
    slsizestr = regexp(tmp{1},'[0-9]+','match');
    sigfdrplot = sigfdrwithneighbors(sigfdr,locations,str2num(slsizestr{1}));
    % save some vals for later plotting 
    pvaltoplot(:,i) = pval;
    pvaltoplotnames{i} = fn;
    pvaltoplotfoldnames{i} = pn;
    % plot three gropus - one for real data, the other boolean, and FWER
    % control 
    dataFromAnsMatBackIn3d = scoringToMatrix(mask,avgAnsMat(:,1),locations);
    tosavevmp.NrOfMaps = 2; 
    % real data 
    tosavevmp.Map(1).VMPData = double(dataFromAnsMatBackIn3d);
    tosavevmp.Map(1).Name = fn;
    dataFromAnsMatBackIn3d = scoringToMatrix(mask,double(sigfdrplot)',locations);
    % voxel wise fdr 
    tosavevmp.Map(2) = rawvmp.Map(1);
    tosavevmp.Map(2).VMPData = dataFromAnsMatBackIn3d;
    tosavevmp.Map(2).Name = sprintf('sig fdr voxel wise 005 (%d)',sum(sigfdr(:)));
    % fwer control 
    %[sigfwer,sigbonf, clustdata] = calcFWERcontrol(avgAnsMat,mask,locations);
    
    % set vmp threholsd (max min etc.) 
    for j = 1:tosavevmp.NrOfMaps;
        vmpdat = tosavevmp.Map(j).VMPData;
        idxnonzer = find(vmpdat~=0); 
        if ~isempty(idxnonzer)
        minval = min(tosavevmp.Map(1).VMPData(idxnonzer));
        maxval = max(tosavevmp.Map(1).VMPData(idxnonzer));
        tosavevmp.Map(j).LowerThreshold = minval;
        tosavevmp.Map(j).RGBLowerThreshPos = minval;
        tosavevmp.Map(j).RGBLowerThreshNeg = minval;
        tosavevmp.Map(j).RGBUpperThreshNeg = maxval;
        tosavevmp.Map(j).RGBUpperThreshPos = maxval;
        end
    end
    fprintf('done in %f (%s)\n',toc(start),fn);
    vmpfntosave = fullfile(pn,[fn '.vmp']);
    tosavevmp.SaveAs(vmpfntosave);
end 
save(fullfile(settings.resfold,'pvals_from_all_tests.mat'),...
    'mask','locations','pvaltoplot','pvaltoplotnames','pvaltoplotfoldnames');
end


