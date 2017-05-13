function compare_WM_CSF_GM_FA_vals_from_VMP_created_InBV()
% This function creats the WM,CSF and GM masks in the MNI space. 
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX';
vmpbasefn = 'rawFAmaps_150_subs'; % just GM has 1 
graphsExtract = {'_csf_masked', '_wm_masked','_gm_masked'};
faData = struct('mapName',[],'type',[],'vals',[],'slsize',[]); 
numsubs = 150;
useHistogramFunc = 1;
cnt = 1; 
for i = 1:length(graphsExtract) % loop on type (gm / csf / wm) 
    vmp = BVQXfile(fullfile(rootDir,[vmpbasefn graphsExtract{i} '.vmp']));
    for j = 2:vmp.NrOfMaps % loop on maps
        faData(cnt).mapName = vmp.Map(j).Name;
        faData(cnt).type = graphsExtract{i};
        rawVals = vmp.Map(j).VMPData;
        rawVals = double(rawVals);
        valsNoZeros = rawVals(rawVals~=0);
        rawValsScaled = normalizeVecZeroToOne(valsNoZeros);
        faData(cnt).vals = rawValsScaled;
        faData(cnt).slsize = str2num(faData(cnt).mapName(15:end-8));
        cnt = cnt + 1; 
    end
end
faTable = struct2table(faData); 
unqSlsizes = unique(faTable.slsize);

% loop on unq sl sizes and create a histogram of gm, csf, wm for each sl
% size
hfig = figure;
set(hfig,'Position',[1000          81        1201        1257]);
for k = 1:length(unqSlsizes)
    idxstoloop = find(faTable.slsize == unqSlsizes(k));
    subplot(3,2,k); hold on; 
    for m = 1:length(idxstoloop)
        if useHistogramFunc
            h= histogram(faData(idxstoloop(m)).vals,50,...
                'DisplayStyle','stairs',...
                'Normalization','probability');
            h.BinWidth = 0.02;
        else % use histfit
            [n,edges] = hist(faData(idxstoloop(m)).vals,100);
            n = n/sum(n);
            h= histfit(n,100,'kernel');
            h(1).FaceColor =  [1 1 1];
            h(1).EdgeColor = [1 1 1];
            h(2).Color =  [1 0 0];
        end
        xlim([0 1]);
    end
    ttlStr = sprintf('SL size = %d | num subs = %d', unqSlsizes(k), numsubs);
    title(ttlStr); 
    xlabel('Normalized FA values')
    ylabel('Probability of result (%)'); 
    legend({'csf','wm','gm'},'Location','NorthWest');
end

end