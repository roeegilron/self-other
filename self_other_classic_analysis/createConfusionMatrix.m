function createConfusionMatrix()
x = [ 1 1 1; 
      1 2 0.67;
      1 3 0.43;
      2 1 0.34;
      2 2 1;
      2 3 0.23;
      3 1 0.21;
      3 2 0.94;
      3 3 1]; 
sizeOfConfMat = max(x(:,1));
%% preallocate for memory 
confMat = zeros(sizeOfConfMat,sizeOfConfMat);
%% 
idxs = sub2ind(size(confMat),x(:,1),x(:,2));
confMat(idxs) = x(:,3);    
end