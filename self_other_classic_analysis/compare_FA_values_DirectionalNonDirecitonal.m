function compare_FA_values_DirectionalNonDirecitonal()
% This function creats the WM,CSF and GM masks in the MNI space.
%% load fa 
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';
vmpbasefn = 'directionalvsnondirectionalFFX_20subs_fold21_with_FA-vals'; % just GM has 1
%%
faData = struct('mapName',[],'vals',[]);
numsubs = 20;
useHistogramFunc = 1;
cnt = 1;
vmp = BVQXfile(fullfile(rootDir,[vmpbasefn  '.vmp']));
for j = 1:vmp.NrOfMaps % loop on maps
    faData(cnt).mapName = vmp.Map(j).Name;
    rawVals = vmp.Map(j).VMPData;
    rawVals = double(rawVals);
    valsNoZeros = rawVals(rawVals~=0);
    rawValsScaled = normalizeVecZeroToOne(valsNoZeros);
    faData(cnt).vals = rawValsScaled;
    cnt = cnt + 1;
end
faTable = struct2table(faData);

% loop on unq sl sizes and create a histogram of gm, csf, wm for each sl
% size
hfig = figure;
whitebg([1 1 1])
hold on;
set(hfig,'Position',[1000          81        1201        1257]);
for m = 1:3
    h= histogram(faData(m).vals,50,...
        'DisplayStyle','stairs',...
        'Normalization','probability');
    h.BinWidth = 0.02;
    
    xlim([0 1]);
end
ttlStr = sprintf('directional vs non vs common');
title(ttlStr);
xlabel('Normalized FA values')
ylabel('Probability of result (%)');
legend({'D','ND','COM'},'Location','NorthWest');

%% join D with Common 
hfig = figure;
whitebg([1 1 1])
hold on;
set(hfig,'Position',[1000          81        1201        1257]);
valsMat(1).vals = [faData(1).vals; faData(3).vals];
valsMat(2).vals = [faData(2).vals];
colorsToUse = [0.5 0.5 0.5 0.5; 0 0 0 0.5 ];
for m = 1:2
    h= histogram(valsMat(m).vals,...
        'DisplayStyle','stairs',...
        'Normalization','probability');
    h.BinWidth = 0.08;
    
    n = 10;
    xs = h.BinEdges(1:end-1)+h.BinWidth/2;
    ys = h.Values;
    xs = [0 xs 1];
    ys = [0 ys 0];
    yspoly = polyfit(xs,ys,n);
    
    x1 = linspace(0,1-0.01,200);
    y1 = polyval(yspoly,x1);
    plot(x1,y1);
%     
%     [n,edges] = hist(valsMat(m).vals,20);
%     n = n/sum(n);
%     h= histfit2(valsMat(m).vals,20,'gamma');
%     h(1).FaceColor =  [1 1 0.5 ];
%     h(1).EdgeColor = [1 1 0.5 ];
%     h(1).FaceAlpha = 0.5
%     h(2).Color =  colorsToUse(m,:);
    
%     xlim([0 1]);
end
ttlStr = sprintf('directional vs ND only');
title(ttlStr);
xlabel('Normalized FA values')
ylabel('Probability of result (%)');
legend({'D','ND Only'},'Location','NorthWest');
set(findall(hfig,'-property','Font'),'Font','Arial')
set(findall(hfig,'-property','FontSize'),'FontSize',16)

end