function spatially_smooth_all_vtcs(settings,params)



bvqx = actxserver('BrainVoyagerQX.BrainVoyagerQXScriptAccess.1') ;

% bvqx.ShowLogTab;
% bvqx.PrintToLog('Preprocessing VTC files from Matlab...');
% doc = bvqx.ActiveDocument;
% if (isempty(doc))
% [FileName,PathName] = uigetfile(’*.vmr’, ’Please select the VMR file ’);
% vmr = bvqx.OpenDocument([PathName FileName]);
% end
% vtc = vmr.FileNameOfCurrentVTC;
% if (isempty(vtc))
% [FileName,PathName] = uigetfile(’*.vtc’, ’Please select the VTC file ’);
% vmr.LinkVTC([PathName FileName]);
% end
% % now smooth VTC with a large kernel of 10 mm:
% vmr.SpatialGaussianSmoothing(10, ’mm’ ); % FWHM value and unit (’mm’ or ’vx’)
% bvqx.PrintToLog([’Name of spatially smoothed VTC file: ’ vmr.FileNameOfCurrentVTC]);


end