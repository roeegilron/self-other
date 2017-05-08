function runInfinite_cross_validated_on_run()
if ismac
    % loop on all rois, testing
    runAnalysisInfinitePrevelance_cross_validated();
elseif isunix
    roisrun = [28 29 48 49 50 51 66 67 110 111 11 14 1];
    for i = 1:length(roisrun)
        %% to run in parllel comment section above and uncomment section below:
        startmatlab = 'matlabr2016a -nodisplay -r ';
        runprogram  = sprintf('"run runAnalysisInfinitePrevelance_cross_validated(%d).m; exit;" ',roisrun(i));
        unix([startmatlab  runprogram ' &'])
    end
elseif ispc
end


end
