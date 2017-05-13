function scaledvec = scaleVector(vec,optns)
scalingoptions = {'no-scaling','log-scaling','zscore-scaling','centering','0-1 scaling'};
switch optns
    case 'no-scaling'
        scaledvec = vec;
    case 'log-scaling'
        scaledvec = log(vec);
    case 'zscore-scaling'
        scaledvec = zscore(vec);
    case 'centering'
        scaledvec = vec-mean(vec);
    case '0-1 scaling'
        scaledvec = (vec-min(vec(:))) ./ (max(vec(:)-min(vec(:))));
end
        
        
end