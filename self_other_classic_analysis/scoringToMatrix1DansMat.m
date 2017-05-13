function res = scoringToMatrix1DansMat(mask, data, locations)

if ndims(mask) == 3 
    res = zeros(size(mask));
else
    res = zeros(mask, mask, mask);
    % used to be 
%     res = zeros(dimensions, dimensions, dimensions);
% but I changd it since mask is either a 3d logical array
% but in old Ariel version it was just a number (like 128) 
end



for i = 1:size(data,1)
    res(locations(data(i,1),1),locations(data(i,1),2),locations(data(i,1),3)) = data(i,2);
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