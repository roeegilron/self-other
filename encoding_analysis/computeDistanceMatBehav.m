function distances = computeDistanceMatBehav(fname)
load(fname);
[~,fn] = fileparts(fname);
subnm = str2num(fn(17:20));

% 600 = aronit , 601 = rashamkol, 602 = traklin 
conds = [ 600, 601, 602]; 
labelsc = ['a','r','t'];
dataTable = struct2table(testData);

% compute distnace mat 
cnt = 1; 
x = []; 
gr = []; 
grnpb = [] ; 
for s = 1:2 % 1 = self , 2 = other
    for c = 1:length(conds) % conds
        label(2) = labelsc(c);
        idxcond = dataTable.cond == conds(c);
         if s == 1 
             idxsub = dataTable.subject == subnm; 
             label(1) = 'S'; 
         else 
             idxsub = dataTable.subject ~= subnm; 
             label(1) = 'O';
         end 
         datadd = dataTable.sub_resp(idxcond & idxsub);
         x = [x; datadd];
         gr = [gr ;repmat(label,length(datadd),1)];
         grnpb = [grnpb ;repmat(cnt,length(datadd),1)];
         results.Raw.(label) = dataTable.sub_resp(idxcond & idxsub); 
         results.Mean(cnt) = mean(dataTable.sub_resp(idxcond & idxsub)); 
         results.Median(cnt) = median(dataTable.sub_resp(idxcond & idxsub)); 
         results.medianrt(cnt) = median(dataTable.response_time(idxcond & idxsub)); 
         results.Variance(cnt) = std(dataTable.sub_resp(idxcond & idxsub))/sqrt(sum(idxcond & idxsub)); 
         results.labels{cnt} = label; 
         labelsUse{cnt} = label; 
         cnt = cnt + 1; 
     end
end
distances.mean     = pdist(results.Mean');
distances.median   = pdist(results.Median');
distances.variance = pdist(results.medianrt');
distances.medianrt = pdist(results.Variance');
distances.labels   = labelsUse;
distances.subnum   = subnm;
end