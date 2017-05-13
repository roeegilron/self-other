function analyzeDirectionaVsNonDirectinalsVocalDataSet()
close all;
clc
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\FFXandRFX_current';
fntosave = 'dataReadFromFiles.mat';
foundFiles = gatherDataDirectionalNonDirectional(rootDir);

methodsUsed = {'FDR','FWE'};%{'FDR','FWE'};
SigLevel = [0.001 0.01, 0.05];

%% modified 
methodsUsed = {'FDR'};
SigLevel = [0.05];
zToUse = [2 7 ];
%% 
% hFig = figure;
cnt = 1; cntDt =1;
for z = zToUse; %1:length(foundFiles)
    attr = matfile(foundFiles(z).fullpath);
    ansMat = attr.ansMat;
    subsUsed = attr.subsExtracted;
    dataAnsMat.ansMat{z} = ansMat; % XXX take this out 
    for i = 1:length(methodsUsed)
        for j = 1:length(SigLevel)
            %% 1000 K shuffels
            if size(ansMat,2) > 15e3
                tmpAnsMat = ansMat(:,1:(1e3+1) );
            else
                tmpAnsMat = ansMat;
            end
            sigMap = ...
                calcAnsMatSig(tmpAnsMat,methodsUsed{i},SigLevel(j));
            pVals = calcPvalVoxelWise(tmpAnsMat);
            
            dataOut.idxsROI{cntDt,1} = find(sigMap ==1); % idxs roi
            dataOut.notIdxs{cntDt,1} = find(sigMap ~=1);
            dataOut.vxlsPassing(cntDt,1) = sum(sigMap);
            dataOut.NumMinPval(cntDt,1) = sum(pVals==1/foundFiles(z).numshuffle);
            dataOut.NumMinPvalInSigMap(cntDt,1) = sum(pVals(find(sigMap==1))==1/foundFiles(z).numshuffle);
            %% 30 K shuffels
            if size(ansMat,2) > 15e3
                sigMap = ...
                    calcAnsMatSig(tmpAnsMat,methodsUsed{i},SigLevel(j));
                pVals = calcPvalVoxelWise(tmpAnsMat);
                
                dataOut.idxsROI30k{cntDt,1} = find(sigMap ==1); % idxs roi
                dataOut.notIdxs30k{cntDt,1} = find(sigMap ~=1);
                dataOut.vxlsPassing30k(cntDt,1) = sum(sigMap);
                dataOut.NumMinPval30k(cntDt,1) = sum(pVals==1/foundFiles(z).numshuffle);
                dataOut.NumMinPvalInSigMap30k(cntDt,1) = sum(pVals(find(sigMap==1))==1/foundFiles(z).numshuffle);
            else % if don't have 30K shuffels just leave empty 
                dataOut.idxsROI30k{cntDt,1} = [];
                dataOut.notIdxs30k{cntDt,1} = [];
                dataOut.vxlsPassing30k(cntDt,1) = NaN;
                dataOut.NumMinPval30k(cntDt,1) = NaN;
                dataOut.NumMinPvalInSigMap30k(cntDt,1) = NaN;
                
            end
            dataOut.subsUsed{cntDt,1} = subsUsed;
            dataOut.numSubs{cntDt,1} = foundFiles(z).numsubs;
            dataOut.cvfold{cntDt,1} = foundFiles(z).cvfold;
            dataOut.numshuffle{cntDt,1} = foundFiles(z).numshuffle;
            dataOut.testType{cntDt,1} = foundFiles(z).testtype;
            dataOut.methodUsed{cntDt,1} = methodsUsed{i};
            dataOut.cutOffVal(cntDt,1)  = SigLevel(j);
            dataOut.InferenceMet{cntDt,1} = foundFiles(z).inference;
            dataOut.fullpath{cntDt,1} = foundFiles(z).fullpath;
            dataOut.filename{cntDt,1} = foundFiles(z).fn;
            
            cntDt = cntDt +1;
            %             subplot(2,6,cnt)
            %             ttlStr = sprintf('%s %f %s',...
            %                 methodsUsed{i},SigLevel(j),TypeOfAnalysis{k});
            %             bar(voxelPassing,0.5)
            %             set(gca,'XTickLabels',InferenceMet)
            %             title(ttlStr);
            %             cnt = cnt + 1;
        end
    end
    %     clear ansMat;
end
save(fullfile(rootDir,fntosave),'dataOut','foundFiles','-v7.3');

return
rootDirOriginalData = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\stats_normalized_sep_beta';
load(fullfile(rootDirOriginalData,'allSubsBetas.mat'));

%% compute values for each left out subject
leftOutSubjects = setxor(1:218,subsExtracted);
probSubs = ... % over 50 zero vox
    [2     5     6    11    15,...
    24    25    38    41    43,...
    46    54    60    61    67,...
    68    71    78    83    99   101   105   108   113   128,...
    130   138   143   144   166   167   179   180   195   198   210   214];
leftOutSubjects = setxor(leftOutSubjects,probSubs);


%% compute norm maps for RFX and MVPA style benchmarks for two maps 20 - 75
tblrslts = struct2table(dataOut);
subsOut = {'20subs','75subs'};
subsOutIdxs = [ 1 3];
hFig = figure;
cnt = 1;
for i = 1:length(subsOut) % loop on subs
    subsExtracted = tblrslts.subsUsed{subsOutIdxs(i)};
    leftOutSubjects = setxor(1:218,subsExtracted);
    leftOutSubjects = setxor(leftOutSubjects,probSubs);
    evalc(['[normMap' subsOut{i} '] = calcNormsOfLeftOutSubjects(allSubsData,leftOutSubjects,locations,labels)']);
end
save('normMaps30K.mat','normMap20subs','normMap75subs','dataOut');

load('normMaps30K.mat');
tblrslts = struct2table(dataOut);

%% create bar graphs for each significane level and 20 / 75 subs
xTickTitles = {'RFX voxels', 'RFX not select','FFX voxels','FFX not select'};
uniqSig = unique(tblrslts.cutOffVal);
cnt = 1;
subPltCnt = 1;
hFig = figure;
for i = 1:length(uniqSig) % loop on cut off
    for k = 1:length(subsOut) % loop on subsjects out
        normMaps = eval(['normMap' subsOut{k}]);
        % find portion of table I want
        idxscutoff = find(tblrslts.cutOffVal == uniqSig(i));
        idxssubout = find(strcmp(subsOut{k},tblrslts.statMethod)==1);
        idxsofintrst = intersect(idxscutoff,idxssubout);
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
                    y(b,cnt) = nanmedian(rawDat);
                    erR(b,cnt) = nansem(rawDat');
                    xTickTitles{cnt} = sprintf('%s %s (%d)',roiType{w},indName{f},length(rawDat));
                    cnt = cnt + 1;
                end
            end
            cnt = 1;
        end
        %% draw a bar graph with error bars
        %         set(hFig,'Position',[179         590        1125         460])
        % draw the mvpa results
        subplot(6,2,subPltCnt); subPltCnt = subPltCnt +1;
        bar(1:4,y(1,:))
        set(gca,'XTickLabel',xTickTitles);
        title('MVPA benchmark');
        ylabel('mean of norm within ROI');
        % draw the RFX results
        subplot(6,2,subPltCnt); subPltCnt = subPltCnt +1;
        bar(1:4,y(2,:))
        set(gca,'XTickLabel',xTickTitles);
        title('RFX benchmark');
        ylabel('mean of norm within ROI');
        titlStr = sprintf('%s FDR %.3f',subsOut{k},uniqSig(i));
        %         suptitle(titlStr);
        %       hold on;
        %         errorbar(y(1,:),erR(1,:),'.','LineWidth',3)
        hold off;
        
    end
end

end