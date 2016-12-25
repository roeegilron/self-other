function writeVMP_Group(corrval,settings,params) 
% set filename to save 

% write data to file; 
switch params.roisuse
    case 'atlas'
        mapname = sprintf('Group_map-%s_dataAvg-%s_behavMat-%s',...
            params.roisuse,...
            params.dataAvg,...
            params.behavMatUs); 
        writeVMP_percents(corrval,mapname,settings,params); 
    case 'searchlight'
        mapname = sprintf('Group_map-%s_dataAvg-%s_behavMat-%s',...
            params.roisuse,...
            params.dataAvg,...
            params.behavMatUs);
        writeVMP_searchlight(corrval,mapname,settings,params);

end

end