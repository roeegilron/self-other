function scalingOptionsForMVPAorRFXnorms()
load normMaps.mat 
scalingOptions = {'no-scaling','log-scaling','zscore-scaling','centering','0-1 scaling'};
scalingOptions = {'log-scaling'};
subsUsed = {'20subs','75subs'};
cnt= 1; 
for j = 1%:length(subsUsed)
    normaps = eval(sprintf('normMap%s',subsUsed{j}));
    for i = 1:length(scalingOptions)
        hFig=figure;
        set(hFig,'Position',[350         437        1680         548]);
        ttlstr = sprintf('Norm Maps %s %s',scalingOptions{i},subsUsed{j});
        ttlstr = sprintf('Norm Maps %s',scalingOptions{i});
        scaledRFX = scaleVector(normaps.RFX,scalingOptions{i});
        scaledMVPA = scaleVector(normaps.MVPA,scalingOptions{i});
        
        subplot(1,3,cnt); cnt = cnt+ 1;
        hold on;
        h = histogram(scaledRFX);    h.FaceColor = [0.05 0.203 0.9608];
        h = histogram(scaledMVPA);   h.FaceColor = [0.85 0.505 0.0627];
        xlabel('scaled values'); 
        ylabel('count'); 
        legend({'RFX','MVPA'});
        title(ttlstr);
        hold off;
        
        subplot(1,3,cnt); cnt = cnt+1;
        ttlstr = [ttlstr ' voxel wise pairing'];
        y = [scaledRFX;scaledMVPA]';
        [y, idx] = sortrows(y,[1 ]);
        b = bar(y,'stacked');
        b(1).EdgeColor = [0.05 0.203 0.9608];%rfx
        b(2).EdgeColor = [0.85 0.505 0.0627];%mvpa
        b(1).FaceColor= [0.05 0.203 0.9608];%rfx
        b(2).FaceColor = [0.85 0.505 0.0627];%mvpa
        title(ttlstr,'FontSize',12);
        xlabel('idx of voxel','FontSize',12);
        ylabel('size of RFX + MVPA norms combined','FontSize',12);
        legend({'RFX norms','MVPA norms'});
        
        subplot(1,3,cnt); cnt = 1;
        h = histogram((scaledMVPA - scaledRFX)); 
        ttlstr = [ttlstr ' histogram MVPA - RFX'];
        xlabel('(scaled MVPA - scaled RFX) ');
        ylabel('count');
        title(ttlstr);
        hold off;
        
    end
end
end