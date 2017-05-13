close all;
clear all;
load('normMaps30k.mat');

%% plot graph of RFX and MVPA norm maps all voxels vs each other
subsOut = {'20subs','75subs'};
subsOut = {'20subs'};
cnt = 1;
hFig = figure;
for i = 1:length(subsOut)
    set(gcf,'Position',[ 253        -292        1993         767])
    normMap = eval(['normMap' subsOut{i}]);
    subplot(2,3,cnt);cnt = cnt+1;
    logMVPA = log(normMap.MVPA);
    logRFX = log(normMap.RFX);
    y = [logMVPA;logRFX]';
    [y, idx] = sortrows(y,[1 ]);
    bar(y,'stacked');
    legend({'MVPA norms','RFX norms'});
    %     plot(1:length(normMap.MVPA),zscredMVPA(orderIdxs),'LineWidth',2)
    %     plot(1:length(normMap.MVPA),zscredRFX(orderIdxs),'LineWidth',2)
    ylabel('log of norms per sphere');
    xlabel('spheres');
    title(sprintf('comparison of sorted RFX and MVPA norms across voxels %s',subsOut{i}));
    
    subplot(2,3,cnt);cnt= cnt+1;
    bar(sort(normMap.clump))
    ylabel('clump index');
    xlabel('spheres');
    title(sprintf('sorted clumping indeces reduced by 3 (9D) %s',subsOut{i}));
    
    subplot(2,3,cnt);cnt= cnt+1;
    hold on;
    title(sprintf('histogram of RFX and MVPA norms %s',subsOut{i}));
    histogram(logMVPA);
    histogram(logRFX);
    hold off;
    legend({'MVPA norms','RFX norms'});
    ylabel('count of log of scored norms per sphere');
    xlabel('log scored norm value');
end
%% compute values for each left out subject
probSubs = ... % over 50 zero vox
    [2     5     6    11    15,...
    24    25    38    41    43,...
    46    54    60    61    67,...
    68    71    78    83    99   101   105   108   113   128,...
    130   138   143   144   166   167   179   180   195   198   210   214];

%% compute norm maps for RFX and MVPA style benchmarks for two maps 20 - 75
tblrslts = struct2table(dataOut);
subsOut = {'20subs','75subs'};


%% create bar graphs for each significane level and 20 / 75 subs
xTickTitles = {'RFX voxels', 'RFX not select','FFX voxels','FFX not select'};
uniqSig = unique(tblrslts.cutOffVal);
methodUsed = {'FDR','FWE'};
methodUsed = {'FDR'};
clear y; % use this to plot stuff beloew was used before 
cnt = 1;
subPltCnt = 1;
for i = 1:length(uniqSig) % loop on cut off
    for k = 1:length(subsOut) % loop on subsjects out
        for z = 1:length(methodUsed)
            normMaps = eval(['normMap' subsOut{k}]);
            % find portion of table I want
            idxscutoff = find(tblrslts.cutOffVal == uniqSig(i));
            idxssubout = find(strcmp(subsOut{k},tblrslts.statMethod)==1);
            idxsmetuse = find(strcmp(methodUsed{z},tblrslts.methodUsed)==1);
            idxsofintrst1 = intersect(idxscutoff,idxssubout);
            idxsofintrst = intersect(idxsofintrst1,idxsmetuse);
            tmptbl = tblrslts(idxsofintrst,:);
            infidx(1) = find(strcmp(tmptbl.InferenceMet, 'RFX')==1);
            indName{1} = 'RFX';
            infidx(2) = find(strcmp(tmptbl.InferenceMet, 'FFX')==1);
            indName{2} = 'FFX';
            roiType{1} = ''; % e.g. don't put 'not' before RFX tick lable
            roiType{2} = 'not';
            idxsTouse = {'idxsROI','notIdxs'};
            benchmark = {'MVPA','RFX'};
            % loop on mvpa, rfx benchmark
            for b = 1:2 % loop on MVPA / RFX benchmark
                for f = 1:2 % loop on rfx / ffx
                    for w = 1:2 % loop on idxs to use / roi / not idxs
                        tmpnormMap = normMaps.(benchmark{b});
                        rawDat = tmpnormMap(tmptbl(infidx(f),w).(idxsTouse{w}){:});
                        if isempty(rawDat)
                            rawDat =0;
                        end
                        y(b,cnt) = nanmean(rawDat);
                        erR(b,cnt) = nansem(rawDat');
                        if strcmp(indName{f},'RFX')
                            typeTest = 'Directional';
                        else
                            typeTest = 'Nondirectional';
                        end
                        xTickTitles{cnt} = sprintf('%s %s (%d)',roiType{w},typeTest,length(rawDat));
                        cnt = cnt + 1;
                    end
                end
                cnt = 1;
            end
            %% draw a bar graph with error bars
            hFig = figure;
            set(hFig,'Position',[238         -52        1212         488])
            % draw the mvpa results
            subplot(1,2,subPltCnt); subPltCnt = subPltCnt +1;
            bar(1:4,y(1,:))
            hold on;
            errorbar(1:4,y(1,:),erR(1,:),erR(1,:),'g.','LineWidth',2)
            hold off;
            set(gca,'XTickLabel',xTickTitles);
            set(gca,'YLim',[0 20]);
            title('Nondirectional benchmark');
            ylabel('mean of norms within ROI');
            % draw the RFX results
            subplot(1,2,subPltCnt); subPltCnt = 1;
            bar(1:4,y(2,:))
            set(gca,'XTickLabel',xTickTitles);
            title('Directional benchmark');
            set(gca,'YLim',[0 2]);
            ylabel('norm of means within ROI');
            titlStr = sprintf('%s %s %.3f',subsOut{k},methodUsed{z},uniqSig(i));
            suptitle(titlStr);
            hold on;
            errorbar(1:4,y(2,:),erR(2,:),erR(2,:),'g.','LineWidth',2)
            hold off;
            clear y erR;
        end
    end
end