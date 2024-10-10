% ducmentation
%{
    input file paradigm:
    *PARAMETER
    num-dim: 2
    *MATPROP
    b-plane-strain: 1
    young's-modulus: 100.0
    poisson's-ratio: 0.3
    *NODE
    num-node: 4
    nodal-coord:
    0.0 0.0
    1.0 0.0
    1.0 1.0
    0.0 1.0
    *ELEMENT
    num-elem: 2
    num-elem-node: 3
    elem-conn:
    1 2 4
    2 3 4
    *BOUNDARY
    num-prescribed-disp: 3
    node#-dof#-disp:
    1 1 0.0
    1 2 0.0
    4 1 0.0
    num-prescribed-load: 1
    elem#-face#-trac:
    2 1 10.0 0.0

    input: infile, the input file path
    output: ndime,nnode,nelem,nelnd,npres,ntrac,mate,coor,conn,pres,trac
        ndime:
        nnode:
        nelem:
        nelnd:
        npres:
        ntrac:
        mate:
        coor:
        conn:
        pres:
        load:
        trac:
    Among the program, you'll see the 'ind' valuable.
    It represents the index of the data. If there are datas which need loop
    inputing, the 'ind' can change automatically in order to fit the index.
%}
function [ndime,nnode,nelem,nelnd,npres,nload,ntrac,mate,coor,conn,pres,load,trac] = ReadInput(infile)
    file = fopen(infile);
    cellarray = textscan(file,'%s'); % Read the ipt file into cellarray (cell) 
    fclose(file);
    ndime = str2num(cellarray{1}{3}); % dimension
    mate = zeros(3,1); % create 3 by 1 matrix
    mate(1) = str2num(cellarray{1}{6}); % if plane strain
    mate(2) = str2num(cellarray{1}{8}); % E
    mate(3) = str2num(cellarray{1}{10}); % nu
    nnode = str2num(cellarray{1}{13}); % num-node
    ind = 14; % Because its index is begin from 14
    coor = zeros(ndime,nnode); % nodl coordinate ndime: dimension, nnde: nodes in an element
    for i = 1:nnode
        for j = 1:ndime
            ind = ind+1;
            coor(j,i) = str2num(cellarray{1}{ind});
        end
    end
    
    ind = ind + 3;
    nelem = str2num(cellarray{1}{ind});
    
    ind = ind + 2;
    nelnd = str2num(cellarray{1}{ind});
    
    ind = ind + 1;
    conn = zeros(nelnd, nelem);
    
    for i = 1:nelem % nodes in one element
        for j = 1:nelnd % numbers of element
            ind = ind+1;
            conn(j, i) = str2num(cellarray{1}{ind}); 
        end
    end
    
    ind = ind +3;
    npres = str2num(cellarray{1}{ind});
    ind = ind + 1;
    pres = zeros(3, npres);
    for i = 1:npres % numbers of prescribe displacements
        for j = 1:3 % node# - dof# - disp 
            ind = ind+1;
            pres(j, i) = str2num(cellarray{1}{ind});
        end
    end
    
    ind = ind + 2;
    nload = str2num(cellarray{1}{ind});
    ind = ind + 1;
    load = zeros(1 + ndime, nload);
    for i = 1:nload % numbers of prescribe displacements
        for j = 1:(1 + ndime) % node# - dof# - disp 
            ind = ind+1;
            load(j, i) = str2num(cellarray{1}{ind});
        end
    end

    ind = ind + 2;
    ntrac = str2num(cellarray{1}{ind});
    ind = ind + 1;
    trac = zeros(2 + ndime, ntrac);
    for i = 1:ntrac % numbers of prescribe trac
        for j = 1:(2 + ndime) % node# - dof# - disp 
            ind = ind+1;
            trac(j, i) = str2num(cellarray{1}{ind});
        end
    end
    
end