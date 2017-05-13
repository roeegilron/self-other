function  avgacc = calcSVM(datax,datay)
%if i ==1 
%    labls2use = labels;
%else
%    labls2use = shuffMatSVM(:,i-1);
%end
% create 5 fold CV:
labels = [repmat(1,size(datax,1),1); repmat(2,size(datay,1),1)];
data = [datax ; datay];
folds=createCVforSVM(labels,5);
labls2use = labels;

% folds(2:2:end,2) = 1;

%% muni meng sanitylabls2use
% idxA = find(labls2use==1);
% idxB = find(labls2use==2);
% delta = data(idxA,:)- data(idxB,:);
% fprintf('muni meng together %f\n',calcTmuniMeng(delta));
%%


acc=[];
for k = 1:size(folds,2)
    % train 
    trainlabels = labls2use(folds(:,k)==0);
    train = data(folds(:,k)==0,:);
    %% muni meng sanity 
%     idxA = find(trainlabels==1);
%     idxB = find(trainlabels==2);
%     delta = train(idxA,:)- train(idxB,:);
%     fprintf('muni meng train %f\n',calcTmuniMeng(delta));
    %% 
    model = svmtrainwrapper(trainlabels(:),double(train));
    % test
    testlabels = labls2use(folds(:,k)==1);
    test = data(folds(:,k)==1,:);
    [predicted_label, acc, third] = ...
    svmpredictwrapper(testlabels(:), double(test), model);
    accuracy(k) = acc(1)/100;
    %% muni meng sanity 
%     idxA = find(testlabels==1);
%     idxB = find(testlabels==2);
%     delta = test(idxA,:)- test(idxB,:);
%     fprintf('muni meng test %f\n',calcTmuniMeng(delta));
    %% 
end
avgacc =  mean(accuracy);
end
