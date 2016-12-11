function runGroup(justwriteres)
if ~justwriteres
runAnalysisGroupPrevelance();
end
ansMat = agregateResultsRuti(); 
writeVMP_percents(ansMat); 

end