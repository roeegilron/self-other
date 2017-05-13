function reportNaNs()
rootFodler = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\FFXandRFX_files_readyForanalysis';
pat = 'RFXdatastats_normalized_sep_beta_.mat';
fNamesToAnalyze = getFileNames(rootFodler,pat);

for i = 1:length(fNamesToAnalyze)
    load(fNamesToAnalyze{i}) 
    [~,fp] = fileparts(fNamesToAnalyze{i});
    fprintf('[%d] %s\n',i,fp);
    [rows,cols ] = ind2sub(size(ansMat),find(isnan(ansMat) == 1));
    fprintf('\t%d unq rows, %d unq colms\n',...
        length(unique(rows)),...
        length(unique(cols)))
end



end

function outfNs = getFileNames(rootFodler, pattern)
fNs = ...
    findFilesBVQX(fullfile(...
    rootFodler,pattern));
%% prune files with bug - only use one file from each cross val folds
% find files for each fold RFX and FFX 
cntffx = 1; cntrfx =1;
for j = 1:length(fNs)
    [fn, pn] = fileparts(fNs{j});
    if ~isempty(regexp(pn,'FFX'))
        ffxFn{cntffx} = fNs{j};
        cntffx = cntffx + 1;
    else
        rfxFn{cntrfx} = fNs{j};
        cntrfx = cntrfx + 1;
    end
end

outfNs = [rfxFn ffxFn];



end