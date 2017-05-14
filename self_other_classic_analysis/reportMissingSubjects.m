function reportMissingSubjects()
[settings,params] = get_settings_params_self_other();
srcpat = '1ND_FFX_s-%d_shufs-%d_cross_validate_newMultit*';
    for i = params.subuse
        subStrSrc = sprintf(srcpat,i,params.numshufs);
        ff = findFilesBVQX(settings.resdir_ss_prev_cv,subStrSrc);
        if isempty(ff)
            fprintf('sub %d missing\n',i); 
        end
    end
end