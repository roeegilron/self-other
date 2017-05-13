function temp2()
close all
clc
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\FFXandRFX_current';
load(fullfile(rootDir,'normMapsFolds3031.mat'),'normMap','roisOut')
normType = {'RFX','MVPA','wilcox','fa'};
skip =1;
if skip==1;
    %% box plots
    for i = 1:length(roisOut)
        figure;
        cnt=1;
        for j = 1:length(normType)
            subplot(2,2,cnt); cnt = cnt + 1;
            ttlstr = sprintf('%s norm type = %s',roisOut(i).cond,normType{j});
            norms = normMap.(normType{j});
            rfxnorms = norms(roisOut(i).rfx); grprfx = ones(1,length(rfxnorms))*1;
            ffxnorms = norms(roisOut(i).ffx); grpffx = ones(1,length(ffxnorms))*2;
            comnorms = norms(roisOut(i).com); grpcom = ones(1,length(comnorms))*3;
            x = [rfxnorms ffxnorms comnorms];
            g = [grprfx   grpffx   grpcom];
            boxplot(x,g);
            set(gca,'XTickLabel',{'RFX only','FFX only','common'});
            title(ttlstr);
        end
    end
end

%% scatter plots - all points 
figure;
set(gcf,'Position',[ 744         268        1028         782]);
cnt =1;
for i = 1:length(roisOut)
    subplot(2,2,cnt); cnt = cnt + 1;
    ttlstr = sprintf('%s ',roisOut(i).cond);
    hold on;
    if i >=3
        allrois = [roisOut(i).ffx ; roisOut(i).com; roisOut(i).rfx]';
    else
        allrois = [roisOut(i).ffx roisOut(i).com roisOut(i).rfx];
    end
    
    notselidx = setdiff(1:size(normMap.RFX,2),allrois);
    ps = 0.2;
    scatter(normMap.RFX(notselidx),normMap.MVPA(notselidx),'k','.');
    scatter(normMap.RFX(roisOut(i).ffx),normMap.MVPA(roisOut(i).ffx),'r','.');
    scatter(normMap.RFX(roisOut(i).com),normMap.MVPA(roisOut(i).com),'g','.');
    scatter(normMap.RFX(roisOut(i).rfx),normMap.MVPA(roisOut(i).rfx),'b','.');
    ylim = get(gca,'YLim');
    xlim = get(gca,'XLim');
    title(ttlstr);
    xlabel('RFX norm (norm of means)');
    ylabel('MVPA norm (mean of norms)');
    hold off;
    legend({'none','FFX only','common','RFX only'});
end

%% scatter plots - all points sep
for i = 1:2%length(roisOut)
    ttlstr = sprintf('%s ',roisOut(i).cond);
    hold on;
    if i >=3
        allrois = [roisOut(i).ffx ; roisOut(i).com; roisOut(i).rfx]';
    else
        allrois = [roisOut(i).ffx roisOut(i).com roisOut(i).rfx];
    end
    
    notselidx = setdiff(1:size(normMap.RFX,2),allrois);
    ps = 0.2;
    figure;
    set(gcf,'Position',[ 744         268        1028         782]);
    hold off;
    cnt =1;
    
    subplot(2,2,cnt); cnt = cnt + 1;
    scatter(normMap.RFX(notselidx),normMap.MVPA(notselidx),'k','.');
    title(ttlstr);
    xlabel('RFX norm (norm of means)');
    ylabel('MVPA norm (mean of norms)');
    legend({'none'});
    
    set(gca,'YLim',ylim);
    set(gca,'XLim',xlim);
    
    subplot(2,2,cnt); cnt = cnt + 1;
    scatter(normMap.RFX(roisOut(i).ffx),normMap.MVPA(roisOut(i).ffx),'r','.');
    title(ttlstr);
    xlabel('RFX norm (norm of means)');
    ylabel('MVPA norm (mean of norms)');
    legend({'FFX'});
    
    set(gca,'YLim',ylim);
    set(gca,'XLim',xlim);

    subplot(2,2,cnt); cnt = cnt + 1;
    scatter(normMap.RFX(roisOut(i).com),normMap.MVPA(roisOut(i).com),'g','.');
    title(ttlstr);
    xlabel('RFX norm (norm of means)');
    ylabel('MVPA norm (mean of norms)');
    legend({'common'})
    set(gca,'YLim',ylim);
    set(gca,'XLim',xlim);

    subplot(2,2,cnt); cnt = cnt + 1;
    scatter(normMap.RFX(roisOut(i).rfx),normMap.MVPA(roisOut(i).rfx),'b','.');
    title(ttlstr);
    xlabel('RFX norm (norm of means)');
    ylabel('MVPA norm (mean of norms)');
    legend({'RFX'})
    set(gca,'YLim',ylim);
    set(gca,'XLim',xlim);

    
end

%% scatter plots - ALL POINT seperatly  
figure;
set(gcf,'Position',[ 744         268        1028         782]);
cnt =1;
for i = 1:2%length(roisOut)
    subplot(2,2,cnt); cnt = cnt + 1;
    ttlstr = sprintf('%s ',roisOut(i).cond);
    hold on;
    if i >=3
        allrois = [roisOut(i).ffx ; roisOut(i).com; roisOut(i).rfx]';
    else
        allrois = [roisOut(i).ffx roisOut(i).com roisOut(i).rfx];
    end
    
    notselidx = setdiff(1:size(normMap.RFX,2),allrois);
    ps = 0.2;
    scatter(normMap.RFX(notselidx),normMap.MVPA(notselidx),'k','.');
    title(ttlstr);
    set(gca,'YLim',ylim);
    set(gca,'XLim',xlim);
    xlabel('RFX norm (norm of means)');
    ylabel('MVPA norm (mean of norms)');
    hold off;
    legend({'none'});
end

end

function vector = rmout(invec)
    vector = invec;
    percntiles = prctile(invec,[20 80]); %5th and 95th percentile
    outlierIndex = invec < percntiles(1) | invec > percntiles(2);
    %remove outlier values
    vector(outlierIndex) = [];
end