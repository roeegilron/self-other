% Given a map of the interesting places in the brain, returns a vector
% containing the x,y,z coordinates of the interesting voxels.
function res = getVectorLocationFromMapAtlas(map,roi)
res = [];
for i = 1:size(map,1)
    for j = 1:size(map,2)
        for k = 1:size(map,3)
            if map(i,j,k)==roi
                res = [res; i,j,k];
            end
        end
    end
end