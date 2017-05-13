function meanimg = averageNII(fnms)
blankidxs = ...
    [1     2     3     4     5     6    12    17    22    23    24    25    26    32    37    38    39    40    41    47    48    49    50    51    57    62    67    72    77    78    79,...
    80    81    87    88    89    90    91    97    98    99   100   101   107   108   109   110   111   117   122   127   128   129   130   131   137   138   139   140   141   147   148,...
    149   150   151   157   162   167   168   169   170   171   177   182   183   184   185   186   192   197   198   199   200   201   207   208   209   210   211   217   222   227   228,...
    229   230   231   237   242   247   248   249   250   251   257   262   267   268   269   270   271   277   282   283   284   285   286   292   293   294   295   296];
           
for i = 1:length(blankidxs)
    niit = load_nii(fnms{blankidxs(i)});
    niidat(:,:,:,i) = niit.img;
end
meanimg  = mean(niidat,4);
[pn,fn] = fileparts(fnms{1});
niit.fileprefix = fullfile(pn,['mean_blanks' fn(1:9)]); 
niit.img = meanimg;
save_nii(niit,fullfile(pn,['mean_blanks' fn(1:9) '.nii']));

end