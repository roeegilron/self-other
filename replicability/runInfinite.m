function runInfinite(justwriteres)
if ~justwriteres
    if ismac
        % loop on all rois, testing
        runAnalysisInfinitePrevelance();
    elseif isunix
        % run each roi on a seperate cote
        roisrun = 1:40;
        for i = 1:length(roisrun)
            % XXX needs work
            % make sure relative paths make sense
            runProgram('%s', args, 'runAnalysisInfinitePrevelance');
        end
    elseif ispc
    end
end

writeVMP_percents(settings,params);

end