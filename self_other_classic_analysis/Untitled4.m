function  plotFFXvsRFXtxtFilesContents()
rfxTbl = readtable('RFXSystematicInvest.txt');
rawffxTbl = readtable('FFXSystematicInvest.txt');
vosPassing = unique(rawffxTbl.voxelsPassing);

rawProps = rfxTbl.Properties;
PropsToPlot = rawProps.VariableNames(7:end);
hFig = figure;

cutOffVals = [0.05 0.5 0.75 0.9];

cnt =1;
for j = 1:length(vosPassing)
    idxs = (rawffxTbl.voxelsPassing==vosPassing(j));
    ffxTbl = rawffxTbl(idxs,:);
    for i = 1:length(PropsToPlot)
        subplot(4,5,cnt);
        scatter(ffxTbl.(PropsToPlot{i}),rfxTbl.(PropsToPlot{i}))
        hold on;
        axis('equal')
        ylimNum = get(gca,'YLim');
        xlimNum = get(gca,'XLim');
        ceilVal = ceil(max([xlimNum, ylimNum]));
        minVal = floor(min([xlimNum, ylimNum]));
        xlim([minVal ceilVal]);
        ylim([minVal ceilVal]);
        line([ get(gca,'XLim')],[ get(gca,'YLim')],'LineWidth',2)
        ttlStr = sprintf('%s within ROI',PropsToPlot{i});
        title(ttlStr);
        xlblttl = sprintf('FFX FDR %.2f %d Vxls',cutOffVals(j),ffxTbl.voxelsPassing(1));
        xlblttl = sprintf('Rndm dring %d Vxls',ffxTbl.voxelsPassing(1));
        ylblttl = sprintf('RFX Nrm %d Vxls',rfxTbl.voxelsPassing(1));
        xlabel(xlblttl);
        ylabel(ylblttl);
        cnt = cnt + 1;
    end
end