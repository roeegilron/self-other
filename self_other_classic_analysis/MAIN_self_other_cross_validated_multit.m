function  MAIN_self_other_cross_validated_multit()
if ~justwriteres
    if ismac
        % loop on all rois, testing
        runAnalysisInfinitePrevelance();
    elseif isunix
        [settings,params] = get_settings_params_self_other();
        subsuse = params.subuse; 
        for s = 1:length(subsuse)
            %runAnalysisInfinitePrevelance(roisrun(i));
            % XXX needs work
            % make sure relative paths make sense
            %% to run in parllel comment section above and uncomment section below:
            startmatlab = 'matlabr2016a -nodisplay -r ';
            runprogram  = sprintf('"run runAnalysis_SelfOther_cross_validated(%d).m; exit;" ',subsuse(s));
            unix([startmatlab  runprogram ' &'])
        end
    elseif ispc
    end
end