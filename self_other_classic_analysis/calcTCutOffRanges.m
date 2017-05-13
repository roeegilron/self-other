function tCutOff = calcTCutOffRanges(ansMat, fn)
if ~isempty(regexp(fn,'MuniMeng'))
    tCutOff = [0.2 0.3, 0.4, 0.5 , 0.6, 0.7, 0.8];
elseif ~isempty(regexp(fn,'Demp'))
    tCutOff = [5 , 7, 9, 11];
else
    tCutOff = [0.05 , 0.1];
    
end

end