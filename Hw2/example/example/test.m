clc;
clear;
infile = fopen("test.txt");
[ndime,nnode,nelem,nelnd,npres,nload,mate,coor,conn,pres,load,ntrac,trac] = ReadInput(infile);
kglob = GlobStif(ndime,nnode,nelem,nelnd,mate,coor,conn);