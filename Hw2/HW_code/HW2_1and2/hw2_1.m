clear;
clc;

% 讀取 .h5 檔案中的資料
coor = h5read('Data_hw2_2.h5', '/coor');
conn = h5read('Data_hw2_2.h5', '/conn');

% 顯示讀取的資料
% disp(conn);

plot_mesh(coor,conn);

% Input:
% coor, 2 by nnd
% conn, 3 by nel for a mesh of triangular elements or
% 4 by nel for a mesh of quadrilateral elements
% Test:
% 1. Commands:
% >> coor = [0 1 1 0; 0 0 1 1]; conn= [1 2; 2 3; 4 4];
% >> plot_mesh(coor,conn);
% 2. Commands:
% >> coor = [0 1 2 2 1 0; 0 0 0 1 1 1]; conn= [1 2; 2 3; 5 4; 6 5];
% >> plot_mesh(coor,conn);

function plot_mesh(coor,conn)
 nel = size(conn,2);
 scatter(coor(1,:),coor(2,:),'MarkerFaceColor','r');
 hold on;
 
 if(size(conn,1) == 3)
 x = zeros(3,2);
 it3 = [1 2 3];
    
    for iel = 1:nel
        for i = 1:3
            for j = 1:2
                x(i,j) = coor(j,conn(i,iel));
            end
        end
     patch('Vertices',x,'Faces',it3,'FaceColor','none','EdgeColor','b');
     end
 end

 if(size(conn,1) == 4)
 x = zeros(4,2);
 iq4 = [1 2 3 4];

    for iel = 1:nel
        for i = 1:4
            for j = 1:2
                x(i,j) = coor(j,conn(i,iel));
            end
        end
        patch('Vertices',x,'Faces',iq4,'FaceColor','none','EdgeColor','b');
     end
 end

 axis equal;
 box on;
 grid on;
 hold off
end