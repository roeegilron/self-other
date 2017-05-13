function analyzeDataReplicabilityLargeShufFiles()
sizesToAnalyze = [54 27 13];
fileNames = getFileNames(sizesToAnalyze);
cutOffVals = [0.05, 0.1];
% tabulateResults(); 
fid = startFile();
for k = 1:length(cutOffVals)
    groundTruth = getGroundTruthMap(cutOffVals(k));
    compareResults(groundTruth,groundTruth,108,fid,1,cutOffVals(k))
    for i = 1:length(sizesToAnalyze)
        fnR = sprintf('RussBaseData_%dSubs_realData.mat',sizesToAnalyze(i)); % file name real
        fnS = sprintf('RussBaseData_%dSubs_hugeShuff.mat',sizesToAnalyze(i)); % file name shuffle 
        rDtaStc = matfile(fullfile(pwd,'replicabilityAnalysis',fnR));
        ssDtaSt = matfile(fullfile(pwd,'replicabilityAnalysis',fnS));
        ansMatShuff = ssDtaSt.ansMatShuff;
        ansMatWithR = [zeros(size(rDtaStc.ansMatReal,1),1) , ansMatShuff];
        for j = 1:15 % loop on real data shuf maps 
            ansMatWithR(:,1) = rDtaStc.ansMatReal(:,i); % itirate on real data
%             create95PercHistogram(ansMat,tmpFn{j});
            sigAnsMat = calcSignificance(ansMatWithR,cutOffVals(k));
            compareResults(...
                groundTruth,sigAnsMat,sizesToAnalyze(i),fid,j,cutOffVals(k))
%             clear sigAnsMat ansMat;
        end
    end
end
end

function groundTruth = getGroundTruthMap(cutOff)
grnTrthFn = findFilesBVQX(...
    fullfile(pwd,'replicabilityAnalysis'),...
    'Russ*108*results*.mat');
ansMat = getAnsMat(grnTrthFn{1});
% groundTruth = calcSignificance(ansMat,cutOff);
groundTruth = calcSignificanceFWER(ansMat,cutOff);
end

function sigAnsMat = calcSignificance(ansMat,cutOff)
Pval = calcPvalVoxelWise(ansMat);
sigAnsMat = fdr_bh(Pval,cutOff,'pdep','no');
end

function ansMat = getAnsMat(fn)
load(fn,'ansMat')
end

function fileNames = getFileNames(sizesToAnalyze)
for i = 1:length(sizesToAnalyze)
    fileNames{:,i} = ...
        findFilesBVQX(...
        fullfile(pwd,'replicabilityAnalysis'),...
        sprintf('Russ*_%d*results*.mat',...
        sizesToAnalyze(i)));
end
end

function fid = startFile()
fid = fopen(fullfile(pwd,'replicabilityAnalysis',...
    'replicabilityAnalysisResultsHugeShuffMaps.txt'),'w+');
fprintf(fid,'%s,%s,%s,%s\n','cutOff','NumSubjects','percentOverlap','voxelsPassing');
end

function compareResults(grndTruth,ansMat,slSize,fid,mapNum,cutOff)
fullMatch = sum(grndTruth);
voxelsPas = sum(ansMat==1);
amntMatch = length(intersect(find(ansMat==1), find(grndTruth==1)));
percMatch = amntMatch/fullMatch;
fprintf(fid,'%f,%d,%f,%d\n',cutOff,slSize,percMatch,voxelsPas);
fprintf(...
    'cut off %2.2f, mp %d, SL size %d, vxls passing %d, percMatch %2.2f.\ttime = %s\n',...
    cutOff,mapNum,slSize,voxelsPas,percMatch,datestr(clock,0));
fnTosv = sprintf('cutOff-%2.2f-mapNum-%d-slSize-%d.mat',...
    cutOff,mapNum,slSize);
% save(fullfile(pwd,'replicabilityAnalysis',fnTosv),'ansMat'); % XXXX 
end

function tabulateResults() 
fnTosv = 'replicabilityAnalysisResults_fixed.txt';
txtFn = fullfile(pwd,'replicabilityAnalysis',fnTosv);
if exist(txtFn,'file')
    t = readtable(txtFn); 
    ctOff05 = t((t.cutOff==0.05),:);
    figure;
    boxplot(ctOff05.voxelsPassing,{ctOff05.slSize})
    title('Voxels Passing Threshold - 0.05');
    xlabel('sl size')
    ylabel('voxels passing voxels wise 0.05 threshold')
    
    figure;
    ctOff01 = t((t.cutOff==0.1),:);
    boxplot(ctOff01.voxelsPassing,{ctOff01.slSize})
    title('Voxels Passing Threshold - 0.1');
    xlabel('sl size')
    ylabel('voxels passing voxels wise 0.1 threshold')
else
end
end

function create95PercHistogram(ansMat,fn)
[pn, fp] = fileparts(fn);
sortedAnsMat = sort(ansMat(:,2:end),2);
% shuf histogram 
hFig = figure('visible','off');
histogram(sortedAnsMat(:,955))
ttl = ...
    sprintf('95%% T cut-off across all voxels in the brain (max = %2.2f)',...
    max(sortedAnsMat(:,955)));
title(ttl)
xlabel('T stat (muni-meng)');
ylabel('voxel count'); 
saveas(hFig,fullfile(pn,'images',['1_' fp  '_shuff.jpeg']))
close(hFig);
% real histogram 
hFig = figure('visible','off');
histogram(ansMat(:,1))
ttl = ...
    sprintf('real data map across all voxels in the brain (max = %2.2f)',...
    max(ansMat(:,1)));
title(ttl)
xlabel('T stat (muni-meng)');
ylabel('voxel count'); 
saveas(hFig,fullfile(pn,'images',['2_' fp  '_real.jpeg']))
close(hFig);
% real compared to shuf 
hFig = figure('visible','off');
hold on 
histogram(sortedAnsMat(:,955))
histogram(ansMat(:,1))
ttl = ...
    sprintf('real vs shuff');
title(ttl)
xlabel('T stat (muni-meng)');
ylabel('voxel count'); 
legend({'shuff 95% T','real'})
saveas(hFig,fullfile(pn,'images',['3_' fp  '_realvsshuff.jpeg']))
close(hFig);
end

function createLargeFileShuffMatrx(tmpFn)
[pn,fp] = fileparts(tmpFn{1}) ;
ansMatShuff = []; 
for i = 1:length(tmpFn)
    exampl = matfile(tmpFn{i});
    ansMatShuff = [ansMatShuff, exampl.ansMat(:,2:end)];
    fprintf('finished map %d of %s. time %s\n',...
        i, fp(1:19), datestr(clock,0));
end 
save(fullfile(pn,[fp(1:19) '_hugeShuff.mat']),'ansMatShuff'); 
end 

function sigMap = calcSignificanceFWER(ansMat,cutOff)
Pval = calcPvalVoxelWise(ansMat);
sigMap = fdr_bh(Pval,cutOff,'pdep','no');
fwerMax = max(ansMat(:,2:end),[],2); 
sortedfwerMax = sort(fwerMax);
idx = ceil(size(sortedfwerMax,1)*(1-cutOff));
cutoffVal = sortedfwerMax(idx);
sum(ansMat(:,1) > cutoffVal);

ncumsum = cumsum(fwerMax);
idx = find(ncumsum > (ncumsum(end)*(1-cutOff)),1,'first');
sum(ansMat(:,1)>fwerMax(idx))

x = rand(1, 1000) - 0.5;
m = mean(x);
dist = abs(x - m);
[sortDist, sortIndex] = sort(dist);
index_95perc = sortIndex(1:floor(0.95 * numel(x)));
x_95percent = x(index_95perc);
end

function  creatLargeFileRealData(tmpFn)
[pn,fp] = fileparts(tmpFn{1}) ;
ansMatReal = []; 
for i = 1:length(tmpFn)
    exampl = matfile(tmpFn{i});
    ansMatReal(:,i) = exampl.ansMat(:,1);
    fprintf('finished map %d of %s. time %s\n',...
        i, fp(1:19), datestr(clock,0));
end 
save(fullfile(pn,[fp(1:19) '_realData.mat']),'ansMatReal'); 

end
