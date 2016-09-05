function [avgAnsMat,stlzerPerms] = createPermsShufWithoutReplacement(ansMatOut)
% this function takes as input ansMat structure collated across several
% subject
% the structure is voxels x shuffles x subjects. 
% the first row in shuffels is always the real data 

% since each subject underwent same shuffle, we will avaerage the shuffle 
% maps from each subject such that each subjects map is shuffeled with a
% random other subjects map. This is sampling WITH OUT replacement, unlike
% stelzer, every shuffle map is only used once.
shufAnsMat = zeros(size(ansMatOut));
for j = 1:size(ansMatOut,3)
    mpidxs = [1 randperm(1000) + 1]';
    stlzerPerms(j,:) = mpidxs;
    shufAnsMat(:,:,j) = ansMatOut(:,mpidxs,j);
end
%stlzerPerms(k,j) = idxMap; % save this for Directioanl analysis 
% k is subjs, j is maps 
% take the mean across subjects. 
avgAnsMat = mean(shufAnsMat,3);
end