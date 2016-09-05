function generateMapForAllSubjectsTAL(subjects)
hWait=waitbar(0,'Starting map creation....');
for i = 1: length( subjects)
    params = initParamsTAL(subjects(i));
    if i == 1; %  calculate time only on the first run
        start = tic;
        map1 = relevantLocationsMapTAL(params.vtc1);
        timeForOneMap=toc(start);
        totalTime=timeForOneMap * 4 * length(subjects);
        waitbar(timeForOneMap/totalTime,hWait,['map 1 subject ' num2str(subjects(i)) ' completed'])
    else
        map1 = relevantLocationsMapTAL(params.vtc1);
        waitbar(timeForOneMap*i/totalTime,hWait,['map 1 subject ' num2str(subjects(i)) ' completed'])
    end
    
    map2 = relevantLocationsMapTAL(params.vtc2);
    waitbar(timeForOneMap*(i+1)/totalTime,hWait,['map 2 subject ' num2str(subjects(i)) ' completed'])
    map3 = relevantLocationsMapTAL(params.vtc3);
    waitbar(timeForOneMap*(i+2)/totalTime,hWait,['map 3 subject ' num2str(subjects(i)) ' completed'])
    map4 = relevantLocationsMapTAL(params.vtc4);
    waitbar(timeForOneMap*(i+3)/totalTime,hWait,['map 4 subject ' num2str(subjects(i)) ' completed'])
    map = map1 & map2 & map3 & map4;
    save(['outStringsTAL_Subject_' num2str(subjects(i)) '.mat'],'map','-append')
end
close(hWait);

end