delta = data;

for i = 2:1000
    % shuffle?
if params.shuffleData
    if ndims(shufMatrix) ==2 % this is regular shuffle without replacement
        % each sbuject gets chosen only once and gets / doesn't get a sign
        % flip
        shufMatrixToUse = shufMatrix(:,i-1);
        shufMatToMultiply = repmat(shufMatrixToUse,1,size(realDelta,2));
        %     shufIdx = randperm(size(delta,2), floor(size(delta,2)/2));
        %     delta(shufIdx,:) = delta(shufIdx,:).*(-1);
        meanShuffDeltaFFX(i,:) = mean(realDelta.*shufMatToMultiply,1);
    elseif ndims(shufMatrix) ==3 % shufflingwith replacement
        shufMatrixToUse = shufMatrix(:,i-1,1);
        shufMatToMultiply = repmat(shufMatrixToUse,1,size(delta,2));
        delta = delta(sort(shufMatrix(:,i-1,2)),:).*shufMatToMultiply;
    end
end
end