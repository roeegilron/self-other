function Tstat = calcTstat(params,delta)
switch params.TstatToUse
    case 'muniMeng'
        Tstat = calcTmuniMeng(delta);
    case 'Dempster'
        Tstat = calcTdempster(delta);        
end

end