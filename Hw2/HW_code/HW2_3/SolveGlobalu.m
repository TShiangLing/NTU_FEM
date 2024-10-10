function glob_u=SolveGlobalu(kglob,fglob,npres,ndime,nnode)

% 位移計算
kpres= kglob;
rpres= fglob;

for i = 1:npres
 idof = ndime*(pres(1,i)-1)+pres(2,i);
 for ir = 1:ndime*nnode
 kpres(ir,idof) = 0;
 rpres(ir) = rpres(ir) - kglob(ir,idof)*pres(3,i);
 end
end

for i = 1:npres
 idof = ndime*(pres(1,i)-1)+pres(2,i);
 kpres(idof,:) = 0;
 kpres(idof,idof) = 1;
 rpres(idof) = pres(3,i);
end

% 計算位移
glob_u = kpres\rpres;

end