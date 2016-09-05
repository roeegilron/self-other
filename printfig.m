function printfig(fold2save,fnmsv,hfig)
fullfnmsv = fullfile(fold2save,fnmsv);
hfig.PaperPositionMode = 'auto';
hfig.Units = 'inches';
hfig.PaperOrientation = 'landscape';
hfig.PaperPosition = [.01 .01 [11 8.5]-0.01];
print(hfig,'-dpdf',fullfnmsv,'-opengl');
end