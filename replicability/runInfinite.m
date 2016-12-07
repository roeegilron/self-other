function runInfinite(justwriteres)
if ~justwriteres
    if ismac
        % loop on all rois, testing
        runAnalysisInfinitePrevelance();
    elseif isunix
        % run each roi on a seperate cote
        roisrun = 1:2;
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

% writeVMP_percents(settings,params);

end