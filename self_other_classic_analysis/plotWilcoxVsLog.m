function plotWilcoxVsLog()
clc
load('normMaps.mat');
vmpGrunTruth = fullfile(...
    'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\vocalDataSet\grounTruthMaps\spmT_0001',...
    'spmT_0001_RFX_FromPaper.vmp');
vmp = BVQXfile(vmpGrunTruth);
mask= find(vmp.Map.VMPData~=0);
[locations(:,1),locations(:,2),locations(:,3)] = ...
    ind2sub(size(vmp.Map.VMPData),mask);
realDataAnsMat = reverseScoringToMatrix1rowAnsMat(vmp.Map.VMPData,locations);
roiIdxUnivariate = find(realDataAnsMat>4.79);

subsOut = {'20subs','75subs'};
uniqSig = [0.01, 0.05];

methodsUsed = {'FDR','FWE'};%{'FDR','FWE'};
for z = 1:length(methodsUsed)
    for k = 1:length(uniqSig);
        for i = 1:length(subsOut)
            normMap = eval(['normMap' subsOut{i}]);
            %% use the log value and subtract it from each other.
            %         rfxVsMVPAnorms = ...
            %             (scaleVector(normMap.MVPA,'log-scaling')-scaleVector(normMap.RFX,'log-scaling'));
            %%%
            %% use the Wilcox measure
            % measure to use
            measureToUse = {'wilcox','log','fa'};
            normMap.log = log(normMap.MVPA)-log(normMap.RFX);
            for j = 1:length(measureToUse)
                rfxVsMVPAnorms = normMap.(measureToUse{j});
                %%
                rois = getROIsFromdataOutstruc(dataOut,subsOut{i},uniqSig(k),methodsUsed{z});
                zeroVoxels = setxor(1:length(rfxVsMVPAnorms),rois.all);
                rfxVsMVPAnorms(zeroVoxels) = 0;
                mapTitle = sprintf('%s %s %.2f MVPAvsRFX  %d vxls RFX %d vxls FFX',...
                    subsOut{i},methodsUsed{z},uniqSig(k),length(rois.rfx),length(rois.ffx));
                printDetails(mapTitle,rois);
                graphTitles = {mapTitle,...
                    [measureToUse{j} ' histogram in RFX rois'],...
                    [measureToUse{j} ' histogram in univariate RFX rois'],...
                    ['ffx not rfx'],...
                    ['rfx not ffx']};
                if isempty(rois.rfx);
                else
                    roisToUse = {[1:length(normMap.(measureToUse{j}))],...
                        (rois.rfx),...
                        (roiIdxUnivariate),...
                        (setdiff(rois.ffx,rois.rfx)),...
                        (setdiff(rois.rfx,rois.ffx))};
                    hFig = figure;
                    set(hFig,'Position',[488         444        1308         606]);
                    cnt = 1;
                    
                    for m = 1:length(roisToUse)
                        if m ~= 1;
                            cnt = 2;
                            hold on;
                        end
                        if strcmp(measureToUse{j},'wilcox')
                            binW = 0.005*2;
                        elseif strcmp(measureToUse{j},'log')
                            binW = 0.1;
                        else
                            binW = 1;
                        end
                        subplot(1,2,cnt); cnt = cnt+1;
                        histogram(normMap.(measureToUse{j})(roisToUse{m}),...
                            'BinWidth',binW);
                        xlabel([measureToUse{j} ' val']);
                        ylabel('count');
                        title(graphTitles{m});
                    end
                    title(sprintf('comparison of %s within ROIs',measureToUse{j}));
                    legend({'RFX','Univariate','FFX not RFX'});
                end
            end
        end
    end
end
close all;
end

function printDetails(mapTitle,rois)

fprintf('%s\n',mapTitle');
fprintf('\t%d voxels RFX\n',length(rois.rfx));
fprintf('\t\t%d common voxels\n',length(intersect(rois.rfx,rois.ffx)))
fprintf('\t\t+\n');
fprintf('\t\t%d unique voxels\n',length(setdiff(rois.rfx,rois.ffx)))
fprintf('\t\t=\n');
fprintf('\t\t%d FFX voxels\n',length(rois.rfx))

fprintf('\t%d voxels FFX\n',length(rois.ffx));
fprintf('\t\t%d common voxels\n',length(intersect(rois.rfx,rois.ffx)))
fprintf('\t\t+\n');
fprintf('\t\t%d unique voxels\n',length(setdiff(rois.ffx,rois.rfx)))
fprintf('\t\t=\n');
fprintf('\t\t%d FFX voxels\n',length(rois.ffx))

end