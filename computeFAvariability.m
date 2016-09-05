function computeFAvariability()
%% code to compute number of subjects needed in subsample in order to compute subsample variation 

% take all FA values computed on AR(3) for all 150 subjects 

% choose 10 spheres randomly 
sizeofsubsample =[10:10:100];
for i = 1:randsphere % for each sphere 
    for j = 1:sizeofsubsample % choose size of sub sample 
        rng(j); % set seed 
        subsampleofsubjects = subsample(j); 
        for m = 1:subsamples % for each subsampling of subjects 
            sphere = getsphere(subsampleofsubjects);
            faval(m) = computeFA(sphere); 
        end
        %compute median abs deviation for sub samples 
        madvals(j) = mad(faval);
    end
end

end