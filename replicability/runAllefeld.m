function runAllefeld(justwriteres)
if ~justwriteres
ansMat = runAnalysisBoundedPrevelanceAllefeld();
end
writeVMP_percents(ansMat, 'allefeld prevelance'); 

end
