function calcBoxPlotsOfNormOneSubject(outDataNorm,subNum,rootDirResults)
mkdir(fullfile(rootDirResults,'plotsOfNormsPerSub'));
grpingVar = ....
    [repmat(1,size(outDataNorm.RFX,2),1);...
    repmat(2,size(outDataNorm.FFX,2),1)];
X = [outDataNorm.RFX'; outDataNorm.FFX'];
hFig = figure('visible','off');
boxplot(X,grpingVar)
ttlStr = sprintf('sub %3.3d Box plot of Norm in individual ROIs FFX / RFX',subNum);
title(ttlStr);
xlabel('Analysis Type')
ylabel('Norm within ROI')
labels{1} = sprintf('RFX (%d voxels)',length(outDataNorm.RFX));
labels{2} = sprintf('FFX (%d voxels)',length(outDataNorm.FFX));
set(gca,'XTickLabel',labels)
y1 = outDataNorm.FFX;
y2 = outDataNorm.RFX;
[h,pVal] = ttest2(y1,y2);
text(0.5,1,sprintf('p is %2.2f',pVal),'FontSize',12);
saveas(hFig,fullfile(rootDirResults,'plotsOfNormsPerSub',...
    sprintf('%3.3d_normIndiviSub.jpeg',subNum )));
close(hFig)
end
