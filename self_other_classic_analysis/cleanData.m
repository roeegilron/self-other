function [dataout, mapout, locationsout] = cleanData(data,runag, map)
dataout = []; mapout = [] ; badidx = [];
unqruns = unique(runag);
for ucv = 1:length(unqruns)
    data_cv = data(runag == unqruns(ucv),:);
    zerocnt = data_cv == 0;
    zercntmat = sum(zerocnt,1); % a bad voxel has more than 10 zeros 
    badidx = [badidx; find(zercntmat > 10)'];  
    fprintf('run %d has %d bad voxles\n',...
        ucv, sum(zercntmat == size(zerocnt,1)))
end
badidx = unique(badidx); 
locations = getLocations(map);
goodidx   = setdiff(1:size(locations,1),badidx);
locationsout =  locations(goodidx,:);
mapout = zeros(size(map));
for i = 1:size(locationsout,1)
    mapout(locations(i,1),locations(i,2),locations(i,3)) = 1;
end
dataout = data(:,goodidx);
fprintf('took out %d from %d voels for zeros %%%f\n',...
    [sum(map(:)) - sum(mapout(:))], sum(map(:)),...
    (sum(map(:))-sum(mapout(:)))/[sum(map(:)) ]);
end