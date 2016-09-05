function attachPRTtoVTC()
% though it should bep possible to attach prt to VTC with path name, this
% doesn't seem to work, so will move the prt to the vtc folder and then
% just attach file name.
rootDir = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis';
subDirs = findfiles(rootDir,'s*','dirs=1','depth=1') ;
prtDir = 'H:\1_AnalysisFiles\MRI_Data\MNI_analysis\prts';
for i = 1:length(subDirs) % loop on subjects
    vtcFiles = findfiles(subDirs{i},'*.vtc','depth=1') ;
    for j = 1:length(vtcFiles)
        [folderToMovePrt, fn] = fileparts(vtcFiles{j}); % get vtc file name
        vtc = BVQXfile(vtcFiles{j});
        run = fn(11); % get run %
        if strcmp(run,'1') % skip the first localizer run for now
        else
            newRunNum = num2str(str2num(run) - 1 ); % deceremend run number by one since run 01 is localizer in VTC, but obs in prt
            subNum = subDirs{i}(end-3:end);
            prtFiles = findfiles(prtDir,...
                ['*R*' newRunNum '*S*' subNum '.prt'],'depth=1') ;
            [~, prtFilName] = fileparts(prtFiles{1});
            prtFilName = [prtFilName '.prt'];
            % move prt to folder with vtc 
            movefile(prtFiles{1},fullfile(folderToMovePrt,prtFilName));
            % link protocol
            vtc.NrOfLinkedPRTs = 1;
            vtc.NameOfLinkedPRT = prtFilName;
            
            % save and clear VTC
            vtc.Save;
            vtc.ClearObject;
            % print some output to command window 
            fprintf('sub %s run %s done \n',subNum, newRunNum);
        end
    end
end

end
