function vmpCompare()
[pn, fn] = uigetfile('*.vmp','select vmp file to compare');
vmp = BVQXfile(fullfile(fn,pn));
originalData = vmp.Map(1).VMPData;
numVoxelsRuss = length(find(originalData>0.6));

%% choose map to compare 
for i = 2:vmp.NrOfMaps
    fprintf('[%d] %s\n',i,vmp.MapNames{i})
    fprintf('num voxels OriginaData \t\t = %d\n',numVoxelsRuss);
    fprintf('num voxels over thres \t\t  = %d\n',length(find(vmp.Map(i).VMPData>0.3)));
    fprintf('per voxels overlapping \t\t = %f\n',...
        length(intersect(find(vmp.Map(i).VMPData>=0.3),find(originalData>=0.6)))/...
            length(find(originalData>=0.6)))
end
% mapNumToCop = input('select map num \n');
end