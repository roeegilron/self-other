function [ data,locations, mask, labels ] = loadData()
load('flattenedData.mat','flattenedData','locations','mask','labels')
data = flattenedData;
end
