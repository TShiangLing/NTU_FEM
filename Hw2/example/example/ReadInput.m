function  [ndime,nnode,nelem,nelnd,npres,nload,mate,coor,conn,pres,load,ntrac,trac]  = ReadInput_3(infile)
cellarray = textscan(infile,'%s');
ndime = str2num(cellarray{1}{3});
mate = zeros(3,1);
mate(1) = str2num(cellarray{1}{6});
mate(2) = str2num(cellarray{1}{8});
mate(3) = str2num(cellarray{1}{10});
nnode = str2num(cellarray{1}{13});
ind = 14;%nodal-coord:
coor = zeros(ndime,nnode);
for i = 1:nnode
    for j = 1:ndime
        ind = ind+1;
        coor(j,i) = str2num(cellarray{1}{ind});
    end
end
ind = ind+3;%num-elem: 8
nelem = str2num(cellarray{1}{ind});
ind = ind+2;%num-elem-node: 3
nelnd = str2num(cellarray{1}{ind});
ind = ind+1;
conn = zeros(nelnd,nelem);
for i = 1:nelem
    for j = 1:nelnd
        ind = ind+1;
        conn(j,i) = str2num(cellarray{1}{ind});
    end
end
ind= ind+3;%num-prescribed-disp: 3
npres = str2num(cellarray{1}{ind});
ind = ind+1;%n-d-d
pres = zeros(3,npres);
for i = 1:npres
    for j = 1:3
        ind = ind+1;
        pres(j,i) = str2num(cellarray{1}{ind});
    end
end
ind = ind+2;%num-prescribed-trac
ntrac = str2num(cellarray{1}{ind});
ind = ind+1;
if ntrac == 0
    trac =0;
else
    trac = zeros(2+ndime,ntrac);
    for i = 1:ntrac
        for j = 1:(2+ndime)
            ind = ind+1;
            trac(j,i) = str2num(cellarray{1}{ind});
        end
    end
end
ind = ind+2;%num-prescribed-load
nload = str2num(cellarray{1}{ind});
ind = ind+1;
if nload == 0
    load = 0;
else
    load = zeros(1+ndime,nload);% 1+ndime=node+2 dimmention force
    for i = 1:nload
        for j = 1:(1+ndime)
            ind = ind+1;
            load(j,i) = str2num(cellarray{1}{ind});
        end
    end
end
end
