function analyzeRFXvsMVPAstyleAnalysisVocalDataSet()
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\FFXandRFX_current';
fileToAnalyze{1,1} = 'VocalDataSet_results_20-subs_27-slSize_cvFold20_RFX_zscored_20150826T214641.mat'; % i = 1 = 20 subs , i = 2 = 75 sybs 
fileToAnalyze{1,2} = 'VocalDataSet_results_20-subs_27-slSize_cvFold20_FFXstlzrstyleNoZeroingNaN.mat'; % j = 1 = RFX  j = 2 = FFX 

fileToAnalyze{2,1} = 'VocalDataSet_results_75-subs_27-slSize_cvFold30_RFX_zscored_20150826T145341.mat';
fileToAnalyze{2,2} = 'VocalDataSet_results_75-subs_27-slSize_cvFold30_FFXstlzrstyleNoZeroingNaN.mat';
for i = 1:size(fileToAnalyze,1) % loop on subjs used
    for j = 1:size(fileToAnalyze,1) % loop on method used(RFX / FFX 
        load(fullfile(rootDir,fileToAnalyze{i,j}),'ansMat','subsExtracted')
        if ~isempty(strfind(fileToAnalyze{i,j},'RFX'));
            typeMeth{i,j} = 'RFX';
        elseif ~isempty(strfind(fileToAnalyze{i,j},'FFX'));
            typeMeth{i,j} = 'FFX';
        end
        ansMatBig{i,j} = ansMat;
        subsUsed{i,j} = subsExtracted;
        clear ansMat
    end
end
methodsUsed = {'FDR','FWE'};%{'FDR','FWE'}; 
SigLevel = [0.001 0.01, 0.05];
TypeOfAnalysis = {'20subs', '75subs'};
InferenceMet = {'RFX','FFX'};
% hFig = figure;
cnt = 1; cntDt =1;
for i = 1:length(methodsUsed)
    for j = 1:length(SigLevel)
        for k = 1:length(TypeOfAnalysis)
            for z = 1:length(InferenceMet)
                sigMap = ...
                    calcAnsMatSig(ansMatBig{k,z},methodsUsed{i},SigLevel(j));
                pVals = calcPvalVoxelWise(ansMatBig{k,z});
                pValsBig{k,z} = pVals;
                voxelPassing(z) = sum(sigMap);
                dataOut.idxsROI{cntDt,1} = find(sigMap ==1); % idxs roi
                dataOut.notIdxs{cntDt,1} = find(sigMap ~=1);
                dataOut.subsUsed{cntDt,1} = subsUsed{k,z};
                dataOut.statMethod{cntDt,1} = TypeOfAnalysis{k};
                dataOut.methodUsed{cntDt,1} = methodsUsed{i};
                dataOut.cutOffVal(cntDt,1)  = SigLevel(j);
                dataOut.vxlsPassing(cntDt,1) = voxelPassing(z);
                dataOut.InferenceMet{cntDt,1} = InferenceMet{z};
                typeMeth{k,z}
                dataOut.NumMinPval(cntDt,1) = sum(pVals==0.001);
                dataOut.NumMinPvalInSigMap(cntDt,1) = sum(sigMap(find(pVals==0.001)));
                cntDt = cntDt +1;
            end
%             subplot(2,6,cnt)
%             ttlStr = sprintf('%s %f %s',...
%                 methodsUsed{i},SigLevel(j),TypeOfAnalysis{k});
%             bar(voxelPassing,0.5)
%             set(gca,'XTickLabels',InferenceMet)
%             title(ttlStr);
%             cnt = cnt + 1;
        end
    end
end

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