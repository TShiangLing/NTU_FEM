clear;
clc;

addpath('C:/Users/user/Desktop/碩一上/FEM/HW3/distmesh');
% which distmesh2d

filename = 'q05';
fd = @q05_fd; % 定義幾何形狀的邊界 距離函數 fd
fh = @q05_fh; % 控制網格點的密度 密度函數 fh
h = 0.075; % 定義初始網格間距大小
meshbox = [-5, -5, -1; 5, 5, 1];
iteration_max = 300;
fixed = [ ];

[p,t] = distmesh_3d(fd,fh,h,meshbox,iteration_max,fixed);
% p 為節點座標矩陣，t 為元素的連接矩陣。輸入的參數為幾何函數
% 、密度函數、網格間距、邊界框、最大迭代次數以及固定節點。

% 顯示距離函數的圖
figure('color','w'); dist_plot(p,t,fd); axis equal on; box on; xlabel('X'); ylabel('Y');
colorbar; colormap jet; title('Signed distance function');
% 顯示網格密度變化
figure('color','w'); dist_plot(p,t,fh); axis equal on; box on; xlabel('X'); ylabel('Y');
colorbar; colormap jet; title('Mesh density function');
p = p';
t = t';
figure('color','w'); plotmesh(p,t,filename); title('Mesh');

% p 是一個三維點的集合，該函數返回每個點到幾何形狀邊界的最小距離。
% 這個距離函數會用於 distmesh 來生成符合這些幾何邊界的網格。
% 自定義的幾何距離函數，計算點 p 到邊界的最小距離
% 內部是負的，外部正的，輪廓=0
function d = q05_fd(p)
z1 = -(p(:,3)-(-0.5)); % 計算點 p 在 z 軸上距離 z = -0.5 平面的距離
z2 = -(0.5-p(:,3));    % 計算點 p 在 z 軸上距離 z = 0.5 平面的距離
% 兩者使用負號以確保在點位於幾何形狀內部時，距離值為負

% 定義三個圓的距離
% 計算點 p 到中心 (0,0) 和 (0,-1) 的圓的距離。
r1 = -(1-sqrt((p(:,1)-(0)).^2+(p(:,2)-(0)).^2));
r2 = -(0.5-sqrt((p(:,1)-(0)).^2+(p(:,2)-(0)).^2));
r3 = -(0.5-sqrt((p(:,1)-(0)).^2+(p(:,2)-(-1)).^2));
% d0 至 d5：通過取最大值和最小值來確定點 p 
% 與多個邊界的距離，最終得到最小的邊界距離 d。
d0 = max(z1,z2); % 確保點 p 在 z 軸範圍 [-0.5, 0.5] 內
d1 = max(d0,r1); % 確保點 p 同時滿足 z 軸範圍和第一個圓的邊界
d2 = max(d1,-r2);% 限制點 p 同時在 r1 邊界內且不超過 r2 (半徑更小的圓)
d3 = max(z1,z2); % 再次計算點 p 在 z 軸範圍內的限制
d4 = max(d3,r3); % 確保點 p 滿足第三個圓 r3 的邊界
d5 = min(d2,d4); % 確保點 p 同時滿足 (r2, r3) 和 z 軸的限制條件
d = d5;
end

% 根據點 p 距離圓心 (0,0) 的距離，來決定網格的密度。
% 越靠近圓心的區域網格越密集，根據公式調整密度。
function h = q05_fh(p)
h = 1*(sqrt((p(:,1)-(0)).^2+(p(:,2)-(0)).^2)-0.5+0.6);
end