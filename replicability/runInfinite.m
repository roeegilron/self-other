function runInfinite(justwriteres)
if ~justwriteres
    if ismac
        % loop on all rois, testing
        runAnalysisInfinitePrevelance();
    elseif isunix
        % run each roi on a seperate cote
        roisrun = [5, 17, 20:20, 26:40,49,76,77,58,59];
        % all rois is 1:111 - can only run 1 roi / core.
        roisrun = 1:40;
        for i = 1:length(roisrun)
            % XXX needs work
            % make sure relative paths make sense
            %% to run in parllel comment section above and uncomment section below:
            startmatlab = 'matlabr2016a -nodisplay -r ';
            runprogram  = sprintf('"run runAnalysisInfinitePrevelance(%d).m; exit;" ',roisrun(i));
            unix([startmatlab  runprogram ' &'])
        end
    elseif ispc
    end
end

%% push via Pushbullet message that finished subject 
settings.pushbullettok  = 'o.kCzZVFiDJpke3RLBIzSz4nMxQB5tcdTq';
% get notification when sub done to cellphone see pushbullet.com 
msgtitle = sprintf('Finished sub %.3d ',subnum);
p = Pushbullet(settings.pushbullettok);
secsjobtook = toc(start);
durjob = sprintf('job took: %s',datestr(secsjobtook/86400, 'HH:MM:SS.FFF'));
p.pushNote([],'Finished Subject ',[msgtitle  fnOut])

ansMat  = agregateResultsInifinte_regression(); 
writeVMP_percents(ansMat,'infinite prevelance - regression method');

end