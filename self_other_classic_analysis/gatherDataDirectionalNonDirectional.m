function foundFiles = gatherDataDirectionalNonDirectional(rootDir)
rawData = []; 
ff = findFilesBVQX(rootDir,'*Vocal*.mat');
for i = 1:length(ff)
    [pn,fn] = fileparts(ff{i});
    attr = matfile(ff{i});
    foundFiles(i).fullpath = ff{i};
    foundFiles(i).pn = pn;
    foundFiles(i).fn = fn;
    % num subs 
    tmp = size(attr,'subsExtracted');
    foundFiles(i).numsubs = tmp(2);
    % num shuffels 
    tmp = size(attr,'ansMat');
    foundFiles(i).numshuffle = tmp(2) -1; 
    % type of inference (FFX / RFX) 
    if ~isempty(strfind(fn,'RFX'))
        foundFiles(i).inference = 'RFX';
    else
        foundFiles(i).inference = 'FFX';
    end
    % type of test (directional / non directional) 
    if  ~isempty(strfind(fn,'Directional'))
        foundFiles(i).testtype = 'directional';
    else
        foundFiles(i).testtype = 'nondirectional';
    end
    % cv fold 
    idx = strfind(fn,'cvFold')+6;
    foundFiles(i).cvfold = str2num(fn(idx:idx+1));
end

%% print to screen the files found
tbl  = struct2table(foundFiles); 
tbl(:,3:end)
