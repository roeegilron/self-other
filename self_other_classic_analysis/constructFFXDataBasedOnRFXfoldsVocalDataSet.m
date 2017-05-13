function constructFFXDataBasedOnRFXfoldsVocalDataSet()
computeStzler = 1;
numMaps = 3e4; % num of shuffels maps to use 
dirWithDta = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\';
dirFFX = fullfile(dirWithDta,'FFX_results');
dirRFX = fullfile(dirWithDta,'RFX_results');
outDir = fullfile(dirWithDta, 'FFXandRFX_files_readyForanalysis');
% find ffx files: 
ffxFiles = findFilesBVQX(dirFFX,'stats*FFX*.mat');
% find rfx files: 
rfxFiles = findFilesBVQX(dirRFX,'Vocal*75*RFX*.mat');
for i = 2:length(rfxFiles)
    [pn,fn] = fileparts(rfxFiles{i});
    load(rfxFiles{i},'subsExtracted')
    str = regexp(fn,'cvFold[0-9]+','match');
    fold = str2num(str{1}(7:end));
    computeFFXresults(subsExtracted,fold,computeStzler,dirFFX,outDir,numMaps)    
end

end