% Given a locations list and a vtc file, this function extracts the data of
% the relevant voxels from the vtc File. If there are n voxels, and t TRs
% the resulting matrix is (t*n) size.
function  voxelsData = getVoxelDataFromListAndVtc(locations, vtcData)


voxelsData = single(zeros(size(vtcData, 1), size(locations,1)));

hWait = waitbar(0, 'getVoxelDataFromListAndVtc run');

for i=1:size(locations,1);
    if (mod(i ,1000) == 0)
        waitbar(i/size(locations,1));
    end
    voxelsData(:,i) = single(vtcData(:,locations(i,1),locations(i,2),locations(i,3)));
    nanList(i) =  sum(isnan(vtcData(:,locations(i,1),locations(i,2),locations(i,3))));
    zerList(i) =  sum(vtcData(:,locations(i,1),locations(i,2),locations(i,3))==0);
end

close(hWait)