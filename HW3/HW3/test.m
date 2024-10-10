clear;
clc;

addpath('C:/Users/user/Desktop/碩一上/FEM/HW3/distmesh');
% which distmesh2d

filename = 'q01';
fd = @q01_fd; % 定義幾何形狀的邊界 距離函數 fd
fh = @q01_fh; % 控制網格點的密度 密度函數 fh
h = 0.2; % 初始網格尺寸為 0.2
meshbox = [0.0, 0.0, 0.0; 3.0, 1.0, 1.0]; % 3D 計算域的範圍（長方體框）
iteration_max = 2000;
fixed = [0.0,0.0,0.0; 0.0,0.0,1.0; 0.0,1.0,0.0; 0.0,1.0,1.0; 3.0,0.0,0.0; 3.0,0.0,1.0;
3.0,1.0,0.0; 3.0,1.0,1.0]; % 設定固定的網格點坐標，用來強制某些點固定在網格的特定位置。

[p,t] = distmesh_3d(fd,fh,h,meshbox,iteration_max,fixed);
% 
% % dist_plot 函數繪製網格，基於距離函數 fd
% figure('color','w'); dist_plot(p,t,fd); axis equal on; box on; xlabel('X'); ylabel('Y');
% colorbar; colormap jet; title('Signed distance function');
% % dist_plot 函數基於密度函數 fh 繪製網格
% figure('color','w'); dist_plot(p,t,fh); axis equal on; box on; xlabel('X'); ylabel('Y');
% colorbar; colormap jet; title('Mesh density function');

p = p';
t = t';
% figure('color','w'); plotmesh(p,t,filename); title('Mesh');
%%
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

% 這個函數的輸入 p 是點的坐標矩陣，並返回這些點到邊界的最小距離。
function d = q01_fd(p)
d = -min(min(min(min(min( ...
-0.0+p(:,3),1.0-p(:,3)),-0.0+p(:,2)),1.0-p(:,2)),-0.0+p(:,1)),3.0-p(:,1));
end
% 定義了一個簡單的網格密度函數，所有點的密度都設為 1，表示均勻的網格點分佈
function h = q01_fh(p)
h = ones(size(p,1),1);
end