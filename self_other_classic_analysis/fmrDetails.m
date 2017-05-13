function fmrDetails()
startDir = uigetdir();
foundFiles  = findFilesBVQX(startDir,'*.fmr',struct('oneperdir',1));
for i = 1:length(foundFiles) 
    [fn, pn] = fileparts(foundFiles{i}); 
    fmr = BVQXfile(foundFiles{i});
    fprintf('dir = %s\nfn = % s\nfirst file = %s\n\n',...
        fn,...
        [pn '.fmr'],...
        fmr.FirstDataSourceFile);
        
end
end