function MAIN_runMuniMeng_ffxStyle_subproc()
% [filesFoundInDir, dirName ]  = loadDirForRack();
substorun = importdata('subsused.txt');
substorun = sort(substorun);
substorun = 3000:3012;
idxs = input('start at sub idx?');
idxe = input('end at sub idx?');

for i = 1:length(idxs:idxe)
    subnum = substorun(i);
    MAIN_doSearchLightCrossValFolds_Ht2_NewT2013_subproc(subnum);
end
end
