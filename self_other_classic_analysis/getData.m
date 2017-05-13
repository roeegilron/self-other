function data = getData() % get Data 
dataLocation = '/Users/Roee/ROEE/Poldrack_RFX/code/wetransfer-467e01';
dataFn = 'ALLzstatsmergedRealPumpvRealCashout.nii.gz';
niftiDAta = load_nii(fullfile(dataLocation,dataFn));
data = niftiDAta.img;
