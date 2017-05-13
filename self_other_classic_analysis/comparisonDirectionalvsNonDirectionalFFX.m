%% Compare Between Directional FFX and Non Directional FFX
% after that use this comparison to extract look at FA values and create
% VMPs with the unique contributions of each system.

%% compute pvalues
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';
% rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirecFFXoneBigShuff\';
%rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNonDirecAbsValND';
ff = findFilesBVQX(rootDir,'*FFX*.mat');
if ~exist(fullfile(rootDir,'pvals_mandm.mat'),'file')
    for i = 1:length(ff)
        start = tic;
        [pn fn] = fileparts(ff{i});
        % origianl fn
        dataOut(i).fn = fn;
        atr = matfile(ff{i});
        % type of analysis = Dir /Nondir
        if strcmp(fn(1),'N')
            dataOut(i).analyType = 'nondir';
        else
            dataOut(i).analyType = 'direct';
        end
        % number of subs
        ix = regexp(fn,'[0-9]+-subs');
        dataOut(i).numsubs = str2num(fn(ix:ix+1));
        % subs extracted
        dataOut(i).subsExtracted = atr.subsExtracted;
        % sl size
        ix = regexp(fn,'[0-9]+-subs');
        dataOut(i).numsubs = str2num(fn(ix:ix+1));
        % cvfold
        ix = regexp(fn,'[0-9]+-cvFold');
        dataOut(i).cvfold = str2num(fn(ix:ix+1));
        % mask
        dataOut(i).mask = atr.mask;
        % locationas
        dataOut(i).locations = atr.locations;
        % pvals
        ansMat = atr.ansMat;
        if ndims(ansMat)>2
            ansMat = ansMat(:,:,7);
            ansMat = sqrt(ansMat);
        end
        dataOut(i).pvals = calcPvalVoxelWise(ansMat);
        %num shuffels
        dataOut(i).numshufs = size(ansMat,2);
        %print progress
        fprintf('finished calcing sub %d\n in %f secs\n',...
            i,toc(start));
    end
    save(fullfile(rootDir,'pvals.mat'),'dataOut');
else
    load(fullfile(rootDir,'pvals_mandm.mat'),'dataOut');
end

 
%% calc data re the ROI's
infType = 'FDR';
sigLevl = 0.01;
tbl = struct2table(dataOut);
uniqfolds = [20 21 30 31];
for i = 1:length(uniqfolds)
    relidxs = find(tbl.cvfold == uniqfolds(i));
    newtbl = tbl(relidxs,:);
    for j = 1:2
        if strcmp(newtbl.analyType{j},'direct')
            antype = 'direc';
        else
            antype = 'nondi';
        end
        sigMap = fdr_bh(newtbl.pvals{j},sigLevl,'pdep','no');
        rois(i).subsUsed = newtbl.subsExtracted{j};
        rois(i).cvfold   = newtbl.cvfold(j);
        rois(i).([antype 'idxs']) = find(sigMap==1);
    end
    rois(i).direcidxsonly = setdiff(rois(i).direcidxs,rois(i).nondiidxs);
    rois(i).nondiidxsonly = setdiff(rois(i).nondiidxs,rois(i).direcidxs);
    rois(i).comonidxsonly = intersect(rois(i).nondiidxs,rois(i).direcidxs);
    rois(i).mask = newtbl.mask{1};
    rois(i).locations = newtbl.locations{1};
    rois(i).numsusbs = newtbl.numsubs;
    rois(i).inftype = infType;
    rois(i).siglevl = sigLevl;   
end

%% calc the FA values
if ~exist(fullfile(rootDir,'rois.mat'),'file');
    rootDirOriginalData = ...
        'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
    load(fullfile(rootDirOriginalData,'allSubsBetas.mat'),'allSubsData','labels','locations');
    for i = 1:length(rois)
        normMaps = calcNormsOfLeftOutSubjects(allSubsData,rois(i).subsUsed,locations,labels,27); % last params is sl size
%         calcNormsOfLeftOutSubjects(allSubsData,leftOutSubjects,locations,labels,slsize)
        rois(i).normMaps = normMaps;
    end
    save(fullfile(rootDir,'rois.mat'),'rois');
else
    load(fullfile(rootDir,'rois_mandm_fdr_001.mat'),'rois');
end

%% make some graphs
% plot voxels passing in each condition within each cv vold.
figure;
set(gcf,'Position',[301         324        1097         711]);
for i = 1:length(rois)
    subplot(2,2,i);
    hold on;
    y = [...
        length(rois(i).direcidxsonly),...
        length(rois(i).nondiidxsonly),...
        length(rois(i).comonidxsonly)];
    labels = {'directional','nondirectional','common'};
    title(sprintf('voxels passing %d subs',rois(i).numsusbs(1)));
    bar(1:3,y);
    set(gca,'XTick',1:3);
    set(gca,'XTickLabel',labels)
    set(gca,'YLim',[ 0 7e3]);
    hold off;
end

%% make box plots of FA values:
figure;
set(gcf,'Position',[301         324        1097         711]);

for i = 1:length(rois)
    subplot(2,2,i);
    y = []; g = [];
    normaps = rois(i).normMaps;
    hold on;
    %fa vals directiona
    toadd = normaps.fa(rois(i).direcidxsonly)';
    toadl = ones(length(toadd),1);
    y = [y ; toadd]; g = [g ; toadl];
    
    %fa vals nondirection
    toadd = normaps.fa(rois(i).nondiidxsonly)';
    toadl = ones(length(toadd),1)*2;
    y = [y ; toadd]; g = [g ; toadl];
    
    %fa vals common
    toadd = normaps.fa(rois(i).comonidxsonly)';
    toadl = ones(length(toadd),1)*3;
    y = [y ; toadd]; g = [g ; toadl];
    
    boxplot(y,g)
    labels = {'directional','nondirectional','common'};
    title(sprintf('FA values %d subs',rois(i).numsusbs(1)));
    set(gca,'XTick',1:3);
    set(gca,'XTickLabel',labels)
    set(gca,'YLim',[0.16 0.27]);
    hold off;
end



%% scatter plots of norm values:
figure;
set(gcf,'Position',[301         324        1097         711]);

for i = 1:length(rois)
    subplot(2,2,i);
    y = []; g = [];
    normaps = rois(i).normMaps;
    hold on;
    %mean of norms vs norm of means
    mon = normaps.meanofnorms(rois(i).direcidxsonly)';
    nom = normaps.normofmeans(rois(i).direcidxsonly)';
    scatter(mon,nom,'b');
    
    
    mon = normaps.meanofnorms(rois(i).nondiidxsonly)';
    nom = normaps.normofmeans(rois(i).nondiidxsonly)';
    scatter(mon,nom,'r');
    
    
    
    mon = normaps.meanofnorms(rois(i).comonidxsonly)';
    nom = normaps.normofmeans(rois(i).comonidxsonly)';
    scatter(mon,nom,'k');
    
    legend({'directional','nondirectional','common'});
    title(sprintf('MON vs NOM %d subs',rois(i).numsusbs(1)));
    xlabel('mean of norms');
    ylabel('norm of means');
    set(gca,'XLim',[0 80],'YLim',[0 5]);
    hold off;
end




%% scatter plots of norm values scaled:
figure;
set(gcf,'Position',[301         324        1097         711]);

for i = 1:length(rois)
    subplot(2,2,i);
    y = []; g = [];
    normaps = rois(i).normMaps;
    hold on;
    %mean of norms vs norm of means
    mon = normaps.meanofnorms(rois(i).direcidxsonly)';
    nom = normaps.normofmeans(rois(i).direcidxsonly)';
    mon = scaleVector(mon,'0-1 scaling');
    nom = scaleVector(nom,'0-1 scaling');
    scatter(mon,nom,'b');
    
    
    mon = normaps.meanofnorms(rois(i).nondiidxsonly)';
    nom = normaps.normofmeans(rois(i).nondiidxsonly)';
    mon = scaleVector(mon,'0-1 scaling');
    nom = scaleVector(nom,'0-1 scaling');
    scatter(mon,nom,'r');
    
    
    
    mon = normaps.meanofnorms(rois(i).comonidxsonly)';
    nom = normaps.normofmeans(rois(i).comonidxsonly)';
    mon = scaleVector(mon,'0-1 scaling');
    nom = scaleVector(nom,'0-1 scaling');
    
    scatter(mon,nom,'k');
    
    legend({'directional','nondirectional','common'});
    title(sprintf('MON vs NOM %d subs',rois(i).numsusbs(1)));
    xlabel('mean of norms scaled from 0-1');
    ylabel('norm of means scaled from 0-1');
    set(gca,'XLim',[0 1],'YLim',[0 1]);
    hold off;
end