function tempTemp()

wtd = 'D:\Cloud_Storage\GoogleDrive\LabRoee\codeForExperiments\MaskingExperiment\main';
ff = findFilesBVQX(wtd,'exp*.mat');


cntdbs = 1;
for i= 1:length(ff)
    load(ff{i});
    [pn,fn] = fileparts(ff{i});
    allsubs = [tracesToReplay.subject];
    unqsubs = unique(allsubs);
    for k = 1:length(unqsubs)
        cnt = 1; 
        prod = [];
        for j = 1:length(tracesToReplay)
            if tracesToReplay(j).subject == unqsubs(k)
                bpidx = find(tracesToReplay(j).button == 1);
                maxx = max(tracesToReplay(j).x(bpidx));
                minx = min(tracesToReplay(j).x(bpidx));
                deltx  = abs(maxx) + abs(minx);
                maxy = max(tracesToReplay(j).y(bpidx));
                miny = min(tracesToReplay(j).y(bpidx));
                delty  = abs(maxy) + abs(miny);
                prod(cnt) = deltx * delty;
                cnt = cnt + 1;
            end
        end
        data(cntdbs).prod = mean(prod);
        data(cntdbs).sub = unqsubs(k);
        data(cntdbs).fn = fn;
        data(cntdbs).trace = 'with traces';
        cntdbs = cntdbs + 1;
    end
end



wto = 'D:\Cloud_Storage\GoogleDrive\LabRoee\codeForExperiments\MaskingExperiment\main_no';
ff = findFilesBVQX(wto,'exp*.mat');

for i= 1:length(ff)
    load(ff{i});
    [pn,fn] = fileparts(ff{i});
    allsubs = [tracesToReplay.subject];
    unqsubs = unique(allsubs);
    for k = 1:length(unqsubs)
        cnt = 1; 
        prod = [];
        for j = 1:length(tracesToReplay)
            if tracesToReplay(j).subject == unqsubs(k)
                bpidx = find(tracesToReplay(j).button == 1);
                maxx = max(tracesToReplay(j).x(bpidx));
                minx = min(tracesToReplay(j).x(bpidx));
                deltx  = abs(maxx) + abs(minx);
                maxy = max(tracesToReplay(j).y(bpidx));
                miny = min(tracesToReplay(j).y(bpidx));
                delty  = abs(maxy) + abs(miny);
                prod(cnt) = deltx * delty;
                cnt = cnt + 1;
            end
        end
        data(cntdbs).prod = mean(prod);
        data(cntdbs).sub = unqsubs(k);
        data(cntdbs).fn = fn;
        data(cntdbs).trace = 'with out traces';
        cntdbs = cntdbs + 1;
    end
end
tbl = struct2table(data);
end