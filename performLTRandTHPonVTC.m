function performLTRandTHPonVTC()
rootDir = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis';
subDirs = findfiles(rootDir,'s*','dirs=1','depth=1') ;
%prefs for filtering 
opts.temp = true; % enable temporal filtering
opts.tempdt = true; % dertrend
opts.temphp = 3; % temporal highpass in units (cycles in time course
for i = 1:length(subDirs) % loop on subjects 
    vtcFiles = findfiles(subDirs{i},'*.vtc','depth=1') ;
    for j = 1:length(vtcFiles)
        vtc = BVQXfile(vtcFiles{j});
        vtc = vtc.Filter(opts);
        vtc.Save(); 
    end
end

end