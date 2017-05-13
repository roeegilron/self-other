function joinAndSaveVMPS(VMPS,pn,fn,vmp)
baseVMP = VMPS(1).vmp;
baseVMP.NrOfMaps = length(VMPS);
for i = 2:length(VMPS)
    baseVMP.Map(i) = VMPS(i).vmp.Map;
end
% save the vmp
baseVMP.SaveAs(fullfile(pn,[fn '.vmp']));



end