function behavres = createBehavDifMatrices()
[settings, params] = get_settings_params_encoding();
% get subjects that have behav result 
fnstrc = dir(fullfile(settings.behavdata,'BehavExpData_*.mat')); 
for s = 1:length(fnstrc)
    behavres(s) = computeDistanceMatBehav(...
        fullfile(settings.behavdata, fnstrc(s).name));
end
end