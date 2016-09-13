function MAIN_do_svm_on_connectivity(  )
% do svm on functional connectivity 
load('self_data.mat','h'); 
hself = h; 
load('other_data.mat','h'); 
hother = h; 
huse = hself | hother; 

% load('self_data.mat','h'); 
% hself = h; 
% load('other_data.mat','h'); 
% hother = h; 
% huse = hself | hother; 
% 
% load('self_data_1k-v3.mat','h'); 
% huse = hself;

datadir = fullfile('..','..','results','Functional_Connectivity');
fnuse = 'FC_self_vs_other_runs1-4_not-smoothed'; %'Real_R_FC.mat';
%'Real_R_FC.mat'; 'FC_self_vs_other_runs1-4_not-smoothed' ,
%'FC_self_vs_other_runs1-4_smoothed.mat'; 
load(fullfile(datadir,fnuse)); % 1 is self  2 is other  

% arrange data 
% R_FC_d is [self/other x subjects x voxels] 
sublist = [3000:3022]; 
% 3002 - larger number of slcies 
% 3015 - retarted 
% 3005 - didn't pay attention to task 
% 3012 - big right ventricle 
subexclude = [ ]; % exclude subjects with only 3 runs... 
[subsuse ia] = setdiff(sublist,subexclude);
R_FC_d = R_FC_d(:,ia,:);
labels = [ones(size(R_FC_d,2),1)*1 ; ones(size(R_FC_d,2),1)*2];
C = cvpartition(size(R_FC_d,2),'LeaveOut'); 
% C = cvpartition(size(R_FC_d,2),'KFold',5); 
numberOfShufs = 1e2;
R_FC_d = R_FC_d(:,:,huse);

%% pca 
%{
rawR_FC_d = R_FC_d;
R_FC_d = [] ; 
% pca_input - your input
% thresholdPercents - the percent of the variance you want to explain
thresholdPercents = 95;
pca_input = [squeeze(rawR_FC_d(1,:,:)) ; squeeze(rawR_FC_d(1,:,:))];
[~, scores, ~, ~, explainedVar, ~] = pca(pca_input);
IX = (cumsum(explainedVar) >= thresholdPercents);
num_PC = find(IX, 1, 'first');
pcad_r = scores(:, 1:num_PC);
R_FC_d(1,:,:) = pcad_r(1:23,:); 
R_FC_d(2,:,:) = pcad_r(24:end,:); 
%}
%% use only sig connection 
%% TO DO - split the data to part of the data for connection defintion, and part for SVM. 

for s = 1:numberOfShufs
    for i = 1:C.NumTestSets % leave one subject out.
        % train
        data_self_train = squeeze(R_FC_d(1,C.training(i),:));
        data_othr_train = squeeze(R_FC_d(2,C.training(i),:));
        data_train = [data_self_train ; data_othr_train];
        labels_train = [ones(size(data_self_train,1),1)*1 ; ones(size(data_othr_train,1),1)*2];
        % test
        data_self_test = squeeze(R_FC_d(1,C.test(i),:))';
        data_othr_test = squeeze(R_FC_d(2,C.test(i),:))';
        data_test = [data_self_test ; data_othr_test];
        labels_test = [ones(size(data_self_test,1),1)*1 ; ones(size(data_othr_test,1),1)*2];
        % do svm
        if s ~= 1 
            labels_train = labels_train(randperm(length(labels_train))); 
            labels_test = labels_test(randperm(length(labels_test))); 
        end
        model = svmtrainwrapper(labels_train,data_train);
        [a, b , c] = svmpredictwrapper(labels_test,data_test,model);
        acc(i) = b(1);
    end
    ansMat(s) = mean(acc);
end
pval = calcPvalVoxelWise(ansMat);
fprintf('real - %f p val -%f range %f - %f\n',ansMat(1),pval,min(ansMat(2:end)),max(ansMat(2:end)));

end

