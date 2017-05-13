function mask = createMaskFromLocations (data,locations)

% res = zeros(dimensions, dimensions, dimensions);
res = zeros(size(data));

for i = 1:size(locations,1)
    res(locations(i,1),locations(i,2),locations(i,3)) = 1;
end