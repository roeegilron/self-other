function createHistoram(ansMat, pn, fn)
if ~size(ansMat,2)>1 % this means no shuffeled data
    histogram(ansMat);
    title(fn);
    xlabel('T stat');
    ylabel('Count');
    saveas(hFig,fullfile(pn,[fn '.jpeg']))
else
    %% plot some figures 
    
    %% real data 
    hFig = figure('visible','off');
    histogram(ansMat(:,1));
    title(fn);
    xlabel('T stat Real Data');
    ylabel('Count');
    saveas(hFig,fullfile(pn,[fn '_realDATA_' '.jpeg']))
    %% shuff data 
    hFig = figure('visible','off');
    shuffMean = mean(ansMat(:,2:end),2);
    histogram(shuffMean);
    title([fn 'mean of shuffeled data']);
    xlabel('T value - voxel wise mean of shuffeled maps');
    ylabel('Count');
    saveas(hFig,fullfile(pn,[fn '_shuffDATA_Mean' '.jpeg']))
    %% calc p value and compare to russ data 
    hFig = figure('visible','off');
    Pval = calcPvalVoxelWise(ansMat);
    grounTruth = getGroundTruthAnsMat();
    voxelsPassing(1) = sum(grounTruth>0.6);
    pCutOff = [0.001 , 0.005, 0.01,0.05, 0.1];
    pCutLabels = {'Russ','0.001' , '0.005', '0.01','0.05', '0.1'};
    for i = 1:length(pCutOff)
        voxelsPassing(i+1) = ...
             sum(Pval<=pCutOff(i));
    end
    bar(1:length(voxelsPassing),voxelsPassing)
    Axis = gca;
    Axis.XTickLabel = pCutLabels;
    title('Comp. Russ and # voxels Passing At Various P''s');
    ylabel('number of voxels passing threshold'); 
    xlabel('P val'); 
    saveas(hFig,fullfile(pn,[fn '_compNumVoxsPassThresh_' '.jpeg']))
end

end