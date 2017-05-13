function writeToVmpTAL_multipleMaps(fileName, fmrMatrix, map, res) 
% fmrMatrx is structure with fields: data and mapName (map is fmrMatrix -,
% lowerThresh and upperThresh
% res is the resoultion of the map and vtc (2, or 3) e.g. 2x2x2 or 3x3x3
% .e.g 128x128x128 data.

% map is the size of fmrMatrix
% fmrMatrix 3d 126*126*126
numberOfMaps = length(fmrMatrix);
zStart = 59;
zEnd = 197;
xStart = 57;
xEnd = 231;
yStart = 52;
yEnd = 172;
clusterSizeThresh = 4;
resolution = res; %% was 2 
TypeOfMap=5;%1 -> t-values, 2 -> correlation values, 3 -> cross-correlation values, 4 -> F-values, 11 -> percent signal change values, 12 -> ICA z values.

fdrTABLE = [0.10000000149011612, 18.308273315429688, 18.308273315429688, 0.05000000074505806, 18.308273315429688, 18.308273315429688, 0.03999999910593033, 18.308273315429688, 18.308273315429688, 0.029999999329447746, 18.308273315429688, 18.308273315429688, 0.019999999552965164, 18.308273315429688, 18.308273315429688, 0.009999999776482582, 18.308273315429688, 18.308273315429688, 0.004999999888241291, 18.308273315429688, 18.308273315429688, 0.0010000000474974513, 18.308273315429688, 18.308273315429688];

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
fwrite(fid, resolution, 'int'); % Resolution
fwrite(fid, 256, 'int'); % dimension in X
fwrite(fid, 256, 'int'); % dimension in Y
fwrite(fid, 256, 'int'); % dimension in Z
printToFile(fid, ''); % vtc file name
printToFile(fid, ''); % prt file name
printToFile(fid, ''); % voi name

for i=1:numberOfMaps
    fwrite(fid, TypeOfMap, 'int'); % Type of map
    fwrite(fid, fmrMatrix(i).lowerThresh, 'float'); % Map Threshold
    fwrite(fid, fmrMatrix(i).upperThresh, 'float'); % Map Upper Threshold
    
    %     mapName = ['Map' , num2str(i)];
    printToFile(fid, fmrMatrix(i).mapName);
    
    printColorToFile(fid, 255, 0, 0); % Positive min value
    printColorToFile(fid, 255, 255, 0); % Positive max value
    printColorToFile(fid, 0, 0, 255); % Negative min value
    printColorToFile(fid, 0, 255, 0); % Negative max value
    
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
handle = waitbar(0, 'Writing VMP');
for z=1:numberOfMaps
    singleData = single(fmrMatrix(z).data);
    set(handle,'name',['Writing VMP ' num2str(z)])
    for i=1:(zEnd - zStart) / resolution
        waitbar(i * resolution /(zEnd - zStart),handle,['Writing VMP ' num2str(z)]);
        for j=1:(yEnd - yStart) / resolution
            for k=1:(xEnd - xStart) /resolution
                if ~map(k,j,i)
                    fwrite(fid, 0, 'float');
                else
                    fwrite(fid, singleData(k,j,i), 'float'); % [removed * 10 ] previous version had type 'single'
                end
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