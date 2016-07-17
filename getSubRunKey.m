function sub = getSubRunKey()
sub.AvEl.subn = 3000;
sub.AvEl.run1 = 9;
sub.AvEl.run2 = 13;
sub.AvEl.run3 = 17;
sub.AvEl.run4 = 21;

sub.OfNi.subn = 3001;
sub.OfNi.run1 = 25;
sub.OfNi.run2 = 29;
sub.OfNi.run3 = 17;
sub.OfNi.run4 = 21; % XXX check 


sub.IsBo.subn = 3002;
sub.IsBo.run1 = 10;
sub.IsBo.run2 = 14;
sub.IsBo.run3 = 18;
sub.IsBo.run4 = 22; 


sub.FiYa.subn = 3003;
sub.FiYa.run1 = 4;
sub.FiYa.run2 = 9;
sub.FiYa.run3 = 14;
sub.FiYa.run4 = 19;

sub.CoGi.subn = 3004;
sub.CoGi.run1 = 5;
sub.CoGi.run2 = 10;
sub.CoGi.run3 = 15;
sub.CoGi.run4 = 20; 

sub.MaLa.subn = 3005;
sub.MaLa.run1 = 5;
sub.MaLa.run2 = 10;
sub.MaLa.run3 = 15;
sub.MaLa.run4 = 20; 

sub.AHIT.subn = 3006;
sub.AHIT.run1 = 4;
sub.AHIT.run2 = 8;
sub.AHIT.run3 = 14;

sub.MOIT.subn = 3007;
sub.MOIT.run1 = 4;
sub.MOIT.run2 = 8;
sub.MOIT.run3 = 13;
sub.MOIT.run4 = 17; 

sub.BaOf.subn = 3008;
sub.BaOf.run1 = 2;
sub.BaOf.run2 = 6;
sub.BaOf.run3 = 13;
sub.BaOf.run4 = 17; 

sub.SlTa.subn = 3009;
sub.SlTa.run1 = 5;
sub.SlTa.run2 = 9;
sub.SlTa.run3 = 14;
sub.SlTa.run4 = 18; 

sub.KrNo.subn = 3010;
sub.KrNo.run1 = 3;
sub.KrNo.run2 = 7;
sub.KrNo.run3 = 14;
sub.KrNo.run4 = 18; 

sub.ShLi.subn = 3011;
sub.ShLi.run1 = 13;
sub.ShLi.run2 = 17;
sub.ShLi.run3 = 22;
sub.ShLi.run4 = 29; 

sub.MaRo.subn = 3012;
sub.MaRo.run1 = 2;
sub.MaRo.run2 = 3;
sub.MaRo.run3 = 6;
sub.MaRo.run4 = 7; 

sub.SaBi.subn = 3013;
sub.SaBi.run1 = 5;
sub.SaBi.run2 = 6;
sub.SaBi.run3 = 9;
sub.SaBi.run4 = 10; 

sub.MaEs.subn = 3014;
sub.MaEs.run1 = 2;
sub.MaEs.run2 = 3;
sub.MaEs.run3 = 6;
sub.MaEs.run4 = 8; 

sub.ShSt.subn = 3015;
sub.ShSt.run1 = 4;
sub.ShSt.run2 = 5;
sub.ShSt.run3 = 8; % run ended early - subject retarted (for real)

sub.BeSa.subn = 3016;
sub.BeSa.run1 = 2;
sub.BeSa.run2 = 3;
sub.BeSa.run3 = 6;
sub.BeSa.run4 = 7; 

sub.BeYa.subn = 3017;
sub.BeYa.run1 = 2;
sub.BeYa.run2 = 3;
sub.BeYa.run3 = 6;
sub.BeYa.run4 = 7; 

sub.KaHa.subn = 3018;
sub.KaHa.run1 = 3;
sub.KaHa.run2 = 4;
sub.KaHa.run3 = 7;
sub.KaHa.run4 = 8; 

sub.ZiCh.subn = 3019;
sub.ZiCh.run1 = 2;
sub.ZiCh.run2 = 3;
sub.ZiCh.run3 = 6;
sub.ZiCh.run4 = 7; 

sub.StOh.subn = 3020;
sub.StOh.run1 = 2;
sub.StOh.run2 = 3;
sub.StOh.run3 = 6;
sub.StOh.run4 = 7; 

sub.EfAv.subn = 3021;
sub.EfAv.run1 = 2;
sub.EfAv.run2 = 3;
sub.EfAv.run3 = 6;
sub.EfAv.run4 = 7; 

sub.ShYi.subn = 3022;
sub.ShYi.run1 = 2;
sub.ShYi.run2 = 3;
sub.ShYi.run3 = 5;
sub.ShYi.run4 = 6; 


return; 

%% find all FMR's first run file.
% find all subs
rawdir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study';
subs = 3000:3022;
runs = 1:4;
for i = 1:length(subs);
    for j = 1:length(runs);
        subdir = sprintf('%d',subs(i));
        fundir = sprintf('run%d',runs(j));
        fmrnam = sprintf('%d_run%d.fmr',subs(i),runs(j));
        fmrname = fullfile(rawdir,subdir,'functional',fundir,fmrnam);
        try
            fmr = BVQXfile(fmrname);
            rawsessnums = regexp(fmr.FirstDataSourceFile,'-[0-9]+','match');
            fmr.ClearObject;
            sessnum = str2num(rawsessnums{1}(end-3:end));
            fprintf('sub %d run %d sess %d\n',subs(i),runs(j),sessnum);
        catch
            fprintf('sub %d run %d XXXX missing XXXX\n',subs(i),runs(j));
        end
    end
    fprintf('\n');
end
end