clear;
clc;

addpath('../distmesh'); %這邊要換成自己電腦的絕對路徑 用助教程式碼 % 改為相對路徑 
% ./ 當前資料夾 ../ 上一層資料夾
% which distmesh2d

filename = 'hw33';
fd = @q05_fd; % 定義幾何形狀的邊界距離函數 fd
fh = @q05_fh; % 定義網格點的密度函數 fh
h = 0.1; % 定義初始網格間距大小

meshbox = [0, 0, 0; 5, 5, 1];
iteration_max = 300;
fixed = [0.5,0,0 ; 1.5,0,0; 2.5,0,0 ; 3.5,0,0 ];

[p,t] = distmesh_3d(fd,fh,h,meshbox,iteration_max,fixed);
% p 為節點座標矩陣，t 為元素的連接矩陣

% 顯示距離函數的圖
figure('color','w'); dist_plot(p,t,fd); axis equal on; box on; xlabel('X'); ylabel('Y');
colorbar; colormap jet; title('Signed distance function');
% 顯示網格密度變化
figure('color','w'); dist_plot(p,t,fh); axis equal on; box on; xlabel('X'); ylabel('Y');
colorbar; colormap jet; title('Mesh density function');

p = p';
t = t';
figure('color','w'); plotmesh(p,t,filename); title('Mesh');

%% 這邊是轉成.h5檔 此次不用做 或是老師是轉成.txt檔
% 節點和元素數據 (p 為節點, t 為元素)
% 將節點和元素數據保存為 HDF5 檔案
h5_filename = 'q01.h5';

% 如果 .h5 檔案存在，刪除該檔案
if isfile(h5_filename)
    delete(h5_filename);
    disp(['Existing file ', h5_filename, ' deleted.']);
end

% 儲存節點數據到 "Nodes" 資料集
h5create(h5_filename, '/Mesh/Nodes', size(p));
h5write(h5_filename, '/Mesh/Nodes', p);

% 儲存元素數據到 "Elements" 資料集
h5create(h5_filename, '/Mesh/Elements', size(t));
h5write(h5_filename, '/Mesh/Elements', t);

disp(['Nodes and Elements saved as ', h5_filename]);

% 從 HDF5 文件中讀取節點和元素數據
p_loaded = h5read(h5_filename, '/Mesh/Nodes');
t_loaded = h5read(h5_filename, '/Mesh/Elements');

% 顯示讀取結果

fprintf('The size of p_loaded: [%d, %d]\n', size(p_loaded,1), size(p_loaded,2));
fprintf('The size of t_loaded: [%d, %d]\n', size(t_loaded,1), size(t_loaded,2));

%%

% 自定義的幾何距離函數，計算點 p 到邊界的最小距離
% 內部是負的，外部正的，輪廓=0
function d = q05_fd(p)
    x1 = -(p(:,1) - 0); % 計算到 x = 0 的距離
    x2 = -(4 - p(:,1)); % 計算到 x = 4 的距離
    y1 = -(p(:,2) - 0); % 計算到 y = 0 的距離
    y2 = -(1 - p(:,2)); % 計算到 y = 1 的距離
    z1 = -(p(:,3) - 0); % 計算到 z = 0 的距離
    z2 = -(1 - p(:,3)); % 計算到 z = 1 的距離
    % 兩者使用負號以確保在點位於幾何形狀內部時，距離值為負

    % 定義兩個孔的距離
    r1 = -(0.5-sqrt((p(:,1)-(1)).^2+(p(:,3)-(0)).^2)); %半徑 0.5 圓心 (1,0,0)
    r2 = -(0.5-sqrt((p(:,1)-(3)).^2+(p(:,3)-(0)).^2)); %半徑 0.5 圓心 (3,0,0)
    
    % 計算 X, Y, Z 軸的邊界限制
    d0=max(x1, x2);
    d1=max(y1,y2);
    d2=max(z1,z2);
    d3=max(d0,d1);
    d4=max(d3,d2); %P在x,y,z 範圍內
    % 強調孔的影響，確保網格不會進入這些孔
    d5 = max(d4, -r1); % P 是否在第一個孔的範圍內
    d =  max(d5, -r2); % P 是否在第二個孔的範圍內
end

% 根據點 p 距離圓心的距離，來決定網格的密度
function h = q05_fh(p)
    % 計算點 p 到第一個圓心 (1,0,0) 的距離
    dist1 = sqrt((p(:,1)-(1)).^2 + (p(:,3)-(0)).^2);
    
    % 計算點 p 到第二個圓心 (3,0,0) 的距離
    dist2 = sqrt((p(:,1)-(3)).^2 + (p(:,3)-(0)).^2);
    
    dist_min = min(dist1,dist2);
    % 距離圓心越近，網格越密集；越遠，網格越稀疏
    h = 0.1+ (dist_min+0.1).^2; 
end