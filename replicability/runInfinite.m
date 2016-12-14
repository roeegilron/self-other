function runInfinite(justwriteres)
if ~justwriteres
    if ismac
        % loop on all rois, testing
        runAnalysisInfinitePrevelance();
    elseif isunix
        % run each roi on a seperate cote
        roisrun = [5, 17, 20:20, 26:40,49,76,77,58,59];
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
ansMat  = agregateResultsInifinte_regression(); 
writeVMP_percents(ansMat,'infinite prevelance - regression method');

end