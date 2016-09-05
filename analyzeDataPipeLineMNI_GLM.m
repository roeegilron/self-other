function analyzeDataPipeLineMNI_GLM()
% preprocessing 
convertDicom2Nii() % this function converts data to .nii so can do SPM preproc.
spm5_preprojobs() % open up GUI that controls pre proc. and creates VTC
performLTRandTHPonVTC() % remove linear trends and perform high pass filtering 
cleanupBVQXmemory() % clean memory from all files created

% create design files
createPRTforExp2000s() % create prts from log file for this experiment
createSDMsfromPrt() %% create design files from the prts  
attachPRTtoVTC() %attach created prts to VTCs
createMDM() % create mdm for all subjects all runs 
createMDMforEachSubjects() % create one mdm for each subject 
cleanupBVQXmemory() % clean memory from all files created

% compute the glm
computGLM() % compute the GLM for each MDM generated in steps above. 

% creat a VMR from the .NII anatomical file 
convertNIIanatomicalMNItoVMR()

%open BV with and load all computed GLMs 
openBVwithComputedGLMs()

end