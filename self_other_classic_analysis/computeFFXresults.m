function computeFFXresults(subsToExtract,fold,computeStzler,ffxResFold,outDir,numMaps)
% computeStzler =1;  % - > compute FFX maps stezler way to get 1000 MSCMS from only 100 possible median maps.
% ansMat(voxles,shuffles,stats);
slsize = 9;
cntSubs = length(subsToExtract);
cnt = 1;
%% etrxct results from each subject
for i = subsToExtract
    start = tic;
    subStrSrc = sprintf('*shuf*%3.3d*.mat',i);
    ff = findFilesBVQX(ffxResFold,subStrSrc);
    load(ff{1})
	if exist('map','var')
		mask = map;
	end
    mfo = matfile(ff{1});
    try
        ansMatOld = mfo.ansMatOld;
        ansMatSVM = mfo.ansMatSVM;
    catch
        %         fprintf('no ansMatOld (T2008 run on this sub\n');
    end
    %XXX GET RID OF THIS - this is old T just checking
    %     ansMat = squeeze(ansMat(:,:,1));
    fprintf('B = sub %d has %d nans\n',i,sum(isnan(median(ansMat,2))))
    modeuse = 'equal-min'; % modes to deal with zeros also 'equal-zero', 'equal-min' and 'weight'
    ansMat = squeeze(ansMat(:,:,1)); % first val is multi t 2013
    fixedAnsMat = fixAnsMat(ansMat,locations,modeuse); % fix ansMat for zeros
    ansMatOut(:,:,cnt) = fixedAnsMat;
    if exist('ansMatOld','var')
        ansMatOld = squeeze(ansMatOld(:,:,1)); % first val is multi t 2008
        ansMatOutOld(:,:,cnt) = fixAnsMat(ansMatOld,locations,modeuse); % fix ansMat for zeros
        % XXXX
    end
    if  exist('ansMatSVM','var')
        ansMatSVMOut(:,:,cnt) = fixAnsMat(ansMatSVM,locations,modeuse); % fix ansMat for zeros
    end
    cnt = cnt + 1;
    fprintf('A = sub %d has %d nans\n\n',i,sum(isnan(median(fixedAnsMat,2))))
    %     ansMat = squeeze(ansMat);
    %     zero all nana idxs
    %     idxNans = find(isnan(median(ansMat,2))==1);% median on nan gives NaN...
    %         ansMat(idxNans,:) = 0;
    
end
% find out how many hsufs you have
numshufs = size(ansMatOut,2)-1;

%save(fullfile(outDir,'rawData_ar3_FFX.mat'),'ansMatOut','ansMatOutOld','mask','locations','-v7.3');

%% compute the MSCM maps
if computeStzler
    [avgAnsMat,stlzerPermsAnsMat] = createStelzerPermutations(ansMatOut,numMaps,'mean');
    if exist('ansMatOutOld','var')
        [avgAnsMatOld,stlzerPermsAnsMatOld] = createStelzerPermutations(ansMatOutOld,numMaps,'mean');
    end
    if exist('ansMatSVMOut','var')
        [avgAnsMatSVM,stlzerPermsAnsMatSVM] = createStelzerPermutations(ansMatSVMOut,numMaps,'mean');
    end
else
    % need to shuffle the MSCM maps being average
    % each subject underwent same shuffle matrix
    % this creates some sort of dependency 
    [avgAnsMat ,stlzerPermsAnsMat ]= createPermsShufWithoutReplacement(ansMatOut);% XXX use mean was median
    if exist('ansMatOutOld','var')
         [avgAnsMatOld ,stlzerPermsAnsMatOld ] = createPermsShufWithoutReplacement(ansMatOutOld);% XXX use mean was median
    end
    if exist('ansMatSVMOut','var')
        [avgAnsMatSVM ,stlzerPermsAnsMatSVM ] = createPermsShufWithoutReplacement(ansMatSVMOut);% XXX use mean was median
    end
end
clear ansMat;


%% save the file
numsubs = size(ansMatOut,3);
[pn,fn]= fileparts(ffxResFold);
if computeStzler
    fnTosave = sprintf(...
        'ND_FFX_VDS_%d-subs_%d-slsze_%d-fld_%dshufs_%d-stlzer_mode-%s_newT2013.mat',...
        numsubs,...
        slsize,...
        fold,...
        numshufs,...
        numMaps,...
        modeuse);
else
    fnTosave = sprintf(...
        'ND_FFX_VDS_%d-subs_%d-slsze_%d-fld_%dshufs_mode-%s_newT2013_SVM.mat',...
        numsubs,...
        slsize,...
        fold,...
        numMaps,...
        modeuse);
end
%% XX Delete this plotting section
if exist('avgAnsMatOld','var')
    plotT2008vsT2013(avgAnsMatOld,avgAnsMat) % order is old,new
    if exist('avgAnsMatSVM','var')
        save(fullfile(outDir,fnTosave),...
            'avgAnsMat','avgAnsMatOld','avgAnsMatSVM','locations',...
            'stlzerPermsAnsMat','stlzerPermsAnsMatOld','stlzerPermsAnsMatSVM',...
            'mask','fnTosave','subsToExtract');
    else
        save(fullfile(outDir,fnTosave),...
            'avgAnsMat','avgAnsMatOld','locations',...
            'stlzerPermsAnsMat','stlzerPermsAnsMatOld',...
            'mask','fnTosave','subsToExtract');
    end
    
else
    %plotT2008vsT2013(avgAnsMat)
    save(fullfile(outDir,fnTosave),...
        'avgAnsMat','locations',...
        'stlzerPermsAnsMat',...
        'mask','fnTosave','subsToExtract');
end

end
