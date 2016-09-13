function res = scoringToMatrix(mask, data, locations)

% res = zeros(dimensions, dimensions, dimensions);
res = zeros(size(mask));
data=data';
for i = 1:size(data,1)
    res(locations(i,1),locations(i,2),locations(i,3)) = data(i,1);
end
%% for testing 
%{
res = zeros(dimensions, dimensions, dimensions);
for i = 1:size(locations,1)
    res(locations(data(i,1),1),locations(data(i,1),2),locations(data(i,1),3)) = data(i,2);
end
%}
%% 
end