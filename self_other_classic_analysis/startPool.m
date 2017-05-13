function pool = startPool(params);
if params.useParallel
    if isunix
        pool = parpool('local',20,'IdleTimeout',900) % for linux 2014a
    elseif ispc
        pool = parpool('local',7,'IdleTimeout',900) % for pc
    end
else
    pool = [];
end
