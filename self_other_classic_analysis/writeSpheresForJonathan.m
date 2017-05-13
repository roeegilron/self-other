function writeSpheresForJonathan()
close all
clc
load('normMaps.mat');
rootDirOriginalData = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
load(fullfile(rootDirOriginalData,'allSubsBetas.mat'),'allSubsData','mask','locations','labels');
probSubs = ... % over 50 zero vox
    [2     5     6    11    15,...
    24    25    38    41    43,...
    46    54    60    61    67,...
    68    71    78    83    99   101   105   108   113   128,...
    130   138   143   144   166   167   179   180   195   198   210   214];
relSubs = setdiff(1:218,probSubs);
allRelSubs = allSubsData(:,:,relSubs);
a = squeeze(mean(allSubsData(labels==1,:,relSubs),1));
b = squeeze(mean(allSubsData(labels==2,:,relSubs),1));
data = double([a,b]);
labelsSVM = [ones(1,size(a,2)), ones(1,size(a,2)).*2]';
deltaAllSub = a-b;
idx = knnsearch(locations, locations, 'K', 27);

rfx.Bad = [18965  8814];
rfx.Good = [17173 16274 ];
ffx.Bad = [23619 23606];
ffx.Good = [14636  13691];
com.Bad = [14174 14174];
com.Good = [14281 14281];
method = {'com','ffx','rfx'};
type = {'Good','Bad'};
figure;
cnt=1;
for j = 1:3 % method  rfx ffx
    for k = 1:2 % type bad good
        for i = 1:2 % loop on sphers
            rlIdx = eval(sprintf('%s.%s(%d)',method{j},type{k},i));
            %             rlIdx = 14281
            towr = deltaAllSub(idx(rlIdx,:),:)';
            towrsvm = data(idx(rlIdx,:),:)';
%                         acc = calcSVM(towrsvm,labelsSVM,[],1);
            ttl = sprintf('%s%sSphere%d',method{j},type{k},i);
            dataRaw = squeeze(allRelSubs(:,idx(rlIdx,:),:));
            save([ttl '_v7.mat'],'dataRaw','labels','-v7');
            %             subplot(4,2,cnt); cnt = cnt+1;
            %             bar(towr','stacked');
            %             set(gca,'XLim',[-40 40]);
            %             title(ttl);
            %             ylabel('raw delta for all subs');
            %             xlabel('sphere idxs')
            for z = 1:size(dataRaw,3)
                dataSub = squeeze(dataRaw(:,:,z));
                Twithin(z) = calcTmuniMeng(dataSub(labels==1,:)-dataSub(labels==2,:));
                fn = sprintf('%s%sSphere%d_sub%d.csv',method{j},type{k},i,z);
                dlmwrite(fullfile(pwd,'spheresForJonathan',fn),...
                    dataSub,'precision','%.9f');
            end
            meanT = nanmean(Twithin);
            fprintf('t val %s %s %d between = %f within = %f \t fa %f \n',...
                method{j},type{k},i,calcTmuniMeng(towr),meanT,...
                calcClumpingIndexSVD(towr))
            % within
            subplot(1,2,1)
            hold on; 
            if k ==1; col=[186 85 159]; else col=[67  120 187]; end
            scatter(j,meanT,200,'MarkerEdgeColor',col/255,'LineWidth',3);
            title('Within M&M'); 
            ylabel('MMs within');
            set(gca,'Xtick',1:3);
            set(gca,'XtickLabel',method);
            set(gca,'XLim',[0 3]);
            % between
            subplot(1,2,2) 
            hold on;
            scatter(j,calcTmuniMeng(towr),200,'MarkerEdgeColor',col/255,'LineWidth',3);
            title('Between M&M'); 
            ylabel('MMs Between');
            set(gca,'Xtick',1:3);
            set(gca,'XtickLabel',method);
            set(gca,'XLim',[0 3]);
        end
    end
end
end