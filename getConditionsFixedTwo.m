% Given
%   a. a list of n vectors and t TR's of the form(t*n).
%   b. a letter sequence
% This function returns the value for each one of the conditions, and a
% list of the labels, this funciton works not with the min and the max
% total but with the fixed points where the activation of the brains should
% happen.
function [data0, data1, data2, data3, data4, data5, data6] = getConditionsFixedTwo(voxelsData, seq)

data0 = single(zeros(length(find('1'==seq)),size(voxelsData,2))); % this just intiilized the matrix to the size we need
data1 = single(zeros(length(find('2'==seq)),size(voxelsData,2)));
data2 = single(zeros(length(find('3'==seq)),size(voxelsData,2)));
data3 = single(zeros(length(find('4'==seq)),size(voxelsData,2)));
data4 = single(zeros(length(find('5'==seq)),size(voxelsData,2)));
data5 = single(zeros(length(find('6'==seq)),size(voxelsData,2)));
data6=  single(zeros(length(find('7'==seq)),size(voxelsData,2)));
c0 = 1;
c1 = 1;
c2 = 1;
c3 = 1;
c4 = 1;
c5 = 1;
c6 = 1;

waitbar(0, 'getConditions run');
allData = zeros(size(seq,1), size(voxelsData,2)); % change 48 to # of trials total in experiment
curIndex = 7; % The first 7 samples are not used and the last 7 are not used.
for seqLet=1:length(seq)
    hWait= waitbar(seqLet/length(seq));
    % here you calculate the the percent signal change for each voxel
    % so here its the value - base / base so 6 is the first base. you need
    % to know what the block sequence is here.
    if curIndex+2 > size(voxelsData,1) % to take care of runs that end prematurally
        continue
    else
        allData(seqLet, :) = (voxelsData(curIndex+2,:)-voxelsData(curIndex,:))./voxelsData(curIndex,:);
        curIndex = curIndex + 5;
    end
end
close(hWait);

allData = zscore(allData); % important! must be on all trials regardless of conditions !

% go threw the trials and seperate them to conditions
for seqLet=1:length(seq)
    hWait=waitbar(seqLet/length(seq));
    if seq(seqLet) == '1'
        data0(c0,:) = allData(seqLet, :);
        c0 = c0 + 1;
    elseif seq(seqLet) == '2'
        data1(c1,:) = allData(seqLet, :);
        c1 = c1 + 1;
    elseif seq(seqLet) == '3'
        data2(c2,:) = allData(seqLet, :);
        c2 = c2 + 1;
    elseif seq(seqLet) == '4'
        data3(c3,:) = allData(seqLet, :);
        c3 = c3 + 1;
    elseif seq(seqLet) == '5'
        data4(c4,:) = allData(seqLet, :);
        c4 = c4 + 1;
    elseif seq(seqLet) == '6'
        data5(c5,:) = allData(seqLet, :);
        c5 = c5 + 1;
    elseif seq(seqLet) == '7'
        data6(c6,:) = allData(seqLet, :);
        c6 = c6 + 1;
    end
end

close(hWait);