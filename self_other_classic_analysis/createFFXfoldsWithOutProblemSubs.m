function createFFXfoldsWithOutProblemSubs()
%% these problems subjects have over 50 voxles 
% in which they have a value of zero in the mask. 
% If you get rid of these subs you are only left with 1499 
% non overalpping NaN's you expcet to find acros sthe whole brain. 
% this gives you better results.
probSubs = ... % over 50 zero vox
    [2     5     6    11    15,...
    24    25    38    41    43,...
    46    54    60    61    67,...
    68    71    78    83    99   101   105   108   113   128,...
       130   138   143   144   166   167   179   180   195   198   210   214];
allSubs = 1:218;
remSubs = setxor(allSubs,probSubs);
computeStzler = 1;
dirWithDta = ...
    'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\';
dirFFX = fullfile(dirWithDta,'FFX_results');
dirRFX = fullfile(dirWithDta,'RFX_results');
outDir = fullfile(dirWithDta, 'FFXandRFX_files_readyForanalysis');
% find ffx files: 
ffxFiles = findFilesBVQX(dirFFX,'stats*FFX*.mat');
% find rfx files: 
rfxFiles = findFilesBVQX(dirRFX,'Vocal*75*RFX*.mat');
for i = 1:length(rfxFiles)
    [pn,fn] = fileparts(rfxFiles{i});
    load(rfxFiles{i},'subsExtracted')
    str = regexp(fn,'cvFold[0-9]+','match');
    fold = str2num(str{1}(7:end));
    countOfProbSubsInFold = length(intersect(subsExtracted,probSubs));
    remSubsShuff = remSubs(randperm(length(remSubs)));
    subsExtracted = remSubsShuff(1:75);
%     fold = 20;
    fprintf('fold %d has %d prob subs\n',fold, countOfProbSubsInFold);
%     computeFFXresults(subsExtracted,fold,computeStzler,dirFFX,outDir)    
end