clear;
clc;

filename = 'Flat_bar_mesh.h5';
[ndime,thickness, nnode, nelem, nelnd, npres, nload, mate, coor, conn, pres, load, ntrac, trac] = ReadInput_3(filename);
kglob = GlobStif(ndime,nnode,nelem,nelnd,mate,coor,conn,thickness);
fglob = ForceStif(nnode,load);

glob_u=SolveGlobalu(kglob,fglob,npres,ndime,nnode);

[elemStress,elemEpsilon]=SolveElemStrain( nelem, coor, conn,mate,glob_u,thickness);

Max_column=zeros(3,1);
Max_column=FindMaxStress(elemStress)

function [ndime,thickness, nnode, nelem, nelnd, npres, nload, mate, coor, conn, pres, load, ntrac, trac] = ReadInput_3(filename)
    % 讀取參數
    ndime = h5read(filename, '/PARAMETER/num-dim');
    thickness = h5read(filename, '/PARAMETER/thickness');  

    % 讀取材料屬性
    b_plane_strain = h5read(filename, '/MATPROP/b-plane-strain');
    young_modulus = h5read(filename, '/MATPROP/young-modulus');
    poisson_ratio = h5read(filename, '/MATPROP/poisson-ratio');
    
    % 將材料屬性儲存為矩陣
    mate = [b_plane_strain; young_modulus; poisson_ratio];
        
    % 讀取節點資訊
    nnode = h5read(filename, '/NODE/num-node');
    coor = h5read(filename, '/NODE/nodal-coord');
    
    % 讀取元素資訊
    nelem = h5read(filename, '/ELEMENT/num-elem');
    nelnd = h5read(filename, '/ELEMENT/num-elem-node');
    conn = h5read(filename, '/ELEMENT/elem-conn');
    
    % 讀取邊界條件資訊
    npres = h5read(filename, '/BOUNDARY/num-prescribed-disp');
    pres = h5read(filename, '/BOUNDARY/prescribed-disp');
    
    ntrac = h5read(filename, '/BOUNDARY/num-prescribed-trac');
    trac = h5read(filename, '/BOUNDARY/prescribed-trac');
    
    nload = h5read(filename, '/BOUNDARY/num-prescribed-load');
    load = h5read(filename, '/BOUNDARY/Node_load_coor');

end
