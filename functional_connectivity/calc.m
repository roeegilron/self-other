% step 1 - calculate distance for all voxels
tic
load('vtcMatFile2RodrigezClustering.mat');
data = data';
xx = zeros((size(data,1)*(size(data,1)-1))/2,3);
xx(:,3) = pdist(data)';
step1_time = toc/60
raw_data_size = size(data,1);

% step 2 add the voxels pairs
tic
basic_voxels = [1:raw_data_size];
counter = 1;
for i=1:raw_data_size-1
i
first_col = (basic_voxels(basic_voxels>=i+1));
first_col = first_col';
xx(counter:counter+size(first_col,1)-1,1) = first_col;
xx(counter:counter+size(first_col,1)-1,2) = repmat(i,size(first_col,1),1);
counter=counter+size(first_col,1);
clear first_col;
end

step2_time = toc/60



