function tout= ttest2_roee_fast(x,y)
tout = (mean(x)-mean(y))  /   sqrt(    (   (var(x)+var(y))/2  ) );
end