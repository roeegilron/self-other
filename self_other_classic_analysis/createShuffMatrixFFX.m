function shufMatrix = createShuffMatrixFFX(data,params) 
%% FFX shuffling 
%  The main idea behind FFX shuffle is that there is no effect 
%  within each subject. Therefore, this shuffle randomizes both 
%  subject and label by just randomizing the rows of the data.
%  I will keep the labels the same. 
%  output: 
%    this code retursn the shuffeled idxs of rows in data 
shufMatrix = zeros(size(data,1),params.numShuffels);

switch params.permMode
 case 'reg'
	for i = 1:size(shufMatrix,2)
	    shufMatrix(:,i) = randperm(size(data,1));
	end


 case 'local'
	% new permutation scheme in which you premute close 
	% in time neigbhours, this is hard coded for bocal data set
	for i = 1:size(shufMatrix,2) % loop on shuffels 
	    idxv = (1:20)'; idxnv = (21:40)';
	    for j = 1:20 % loop on trials 
		if rand>0.5
		    tnv = idxnv(j); tv = idxv(j);
		    idxv(j) = tnv;
		    idxnv(j) = tv;
		end
	    end
	    shufMatrix(:,i) = [idxv ; idxnv];
	end
end

end
