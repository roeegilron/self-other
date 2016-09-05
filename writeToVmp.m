function writeToVmp (fileName, fmrMatrix, map)
numberOfMaps = 1;
xStart = 1;
xEnd = 255;
yStart = 1;
yEnd = 255;
zStart = 1;
zEnd = 255;
clusterSizeThresh = 4;
TypeOfMap=5;%1 -> t-values, 2 -> correlation values, 3 -> cross-correlation values, 4 -> F-values, 11 -> percent signal change values, 12 -> ICA z values.
load fdrTABle.mat %loads variable fdrTABLE with that info 

fid=fopen(fileName, 'w');
fwrite(fid, 2712847316, 'uint'); % Magic num
fwrite(fid, 6, 'short'); % Version num
fwrite(fid, 1, 'short'); % document type
fwrite(fid, numberOfMaps, 'int'); % Number of maps
fwrite(fid, 0, 'int'); % # of time points
fwrite(fid, 0, 'int'); % # component params
fwrite(fid, 0, 'int'); % Show params range from
fwrite(fid, 0, 'int'); % Show params range to
fwrite(fid, 0, 'int'); % Use for fingerprint params range from
fwrite(fid, 0, 'int'); % Use for fingerprint params range to
fwrite(fid, xStart, 'int');
fwrite(fid, xEnd, 'int');
fwrite(fid, yStart, 'int');
fwrite(fid, yEnd, 'int');
fwrite(fid, zStart, 'int');
fwrite(fid, zEnd, 'int');
fwrite(fid, 2, 'int'); % Resolution
fwrite(fid, 256, 'int'); % dimension in X
fwrite(fid, 256, 'int'); % dimension in Y
fwrite(fid, 256, 'int'); % dimension in Z
printToFile(fid, ''); % vtc file name
printToFile(fid, ''); % prt file name
printToFile(fid, ''); % voi name
for i=1:numberOfMaps
    fwrite(fid, TypeOfMap, 'int'); % Type of map
    fwrite(fid, 1, 'float'); % Map Threshold
    fwrite(fid, 10.0, 'float'); % Map Upper Threshold
    
    mapName = ['Map' , num2str(i)];
    printToFile(fid, mapName);
    
    printColorToFile(fid, 100, 0, 0); % Positive min value
    printColorToFile(fid, 255, 0, 0); % Positive max value
    printColorToFile(fid, 100, 100, 50); % Negative min value
    printColorToFile(fid, 200, 200, 100); % Negative max value
    
    fwrite(fid, 1, 'uint8'); % Use VMP color
    
    printToFile(fid, '<default>'); % LUT file name
    
    fwrite(fid, 1.0, 'float'); % Transparent color factor
    %{
    this is only stored if map type is 3 , currently all are 1
    fwrite(fid, 1.0, 'int'); % Nr of Lage
    fwrite(fid, 1.0, 'int'); % disp min lage
    fwrite(fid, 1.0, 'int'); % disp max lag
    fwrite(fid, 1.0, 'int'); % show correlatin or lag
    %}
    fwrite(fid, clusterSizeThresh, 'int'); % cluster size threshold 
    fwrite(fid, 0, 'uint8'); % Enable cluster size thereshold
    fwrite(fid, 1, 'int'); % Show values above threshold
    fwrite(fid, 6, 'int'); % Degrees freedom 1
    fwrite(fid, 0, 'int'); % Degrees freedom 2
    fwrite(fid, 3, 'uint8'); % Show positive+negative
    fwrite(fid, size(fmrMatrix,1), 'int'); % Number of used voxels
    fwrite(fid, 8, 'int'); % Size of FDRTable
    for j=1:length(fdrTABLE)
        fwrite(fid, fdrTABLE(j), 'float'); % FDR Table info 
    end
    fwrite(fid, 1, 'int'); % Use FDRTableIndex
end

% Write the data!
% this is the fmrMatrix
singleData = single(fmrMatrix);
handle = waitbar(0, 'Writing VMP');
for i=2:size(fmrMatrix,1)% 
    waitbar(i/size(fmrMatrix,1));
    for j=2:size(fmrMatrix,2) % 
        for k=2:size(fmrMatrix,3) % 
            if (i > 126 || j > 126 || k > 126 || ~map(k,j,i))
                fwrite(fid, 0, 'float');
            else
                fwrite(fid, singleData(k,j,i)*20-10, 'float'); % previous version had type 'single'
            end
        end
    end
end
close(handle);
fclose(fid);
end

function printToFile(fid, str)
fwrite(fid, str, 'char');
fwrite(fid, 0, 'uint8');
end

function printColorToFile(fid, R, G, B)
fwrite(fid, R, 'uint8');
fwrite(fid, G, 'uint8');
fwrite(fid, B, 'uint8');
end