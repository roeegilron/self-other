function  partsDivision = randomDivideToParts(num_samples ,numberOfParts)
    %partsDivision = randomDivideToParts(num_samples ,numberOfParts)
    %This function returns a logical matrix of size  (num_samples x numberOfParts)
    %
    %For example if you want to use this for dividing the data to 5 non
    %overlapping parts.
    %partsDivision =randomDivideToParts(num_samples ,5)
    %Then for the first part use featureVector( partsDivision(:,1) )
    %for the second featureVector( partsDivision(:,2) )  and so on...
    %This function uses randperm so if you can adjust the seed before
    
    if (numberOfParts < 1 || num_samples < numberOfParts)
        error('error using randomDivideToParts numberOfParts <1 or featureVectorSize < numberOfParts');
    end
    
    partsDivision = false(num_samples , numberOfParts);
    randomizedVector = randperm(num_samples);
    beginIndex = 0;
    for i=1:numberOfParts
        endIndex = ceil(num_samples  *i / numberOfParts);
        partsDivision(:,i) =  beginIndex < randomizedVector & randomizedVector <=endIndex;
        beginIndex = endIndex;
    end
end