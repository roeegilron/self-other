function [groupmap, glocations] = getGroupMask(settings,params,subsuse)
%% This function creats a group mask from all subjects
groupmap = [];
for s = 1:length(subsuse)
    for r = 1% just to get mask
        for c = 1 % just to get mask
            fnmload = sprintf(settings.subformat,subsuse(s),r,c,params.suffices{c});
            fullfnm = fullfile(settings.dataloc,fnmload);
            labelStr{c} = params.suffices{c};
            if exist(fullfnm,'file')                
                load(fullfnm,'map');
                if isempty(groupmap) % on first pass initilze gropu map 
                    groupmap = zeros(size(map)) == 0;
                end
                groupmap = groupmap & map;
            end
        end
    end
end
glocations = getLocations(groupmap);

end