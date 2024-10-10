clear;
clc;

drectangle = @(p,x1,x2,y1,y2) -min(min(min(-y1+p(:,2),y2-p(:,2)),-x1+p(:,1)),x2-p(:,1));
fd = @(p) max( drectangle(p,-45,45,-45,45), -(sqrt(sum(p.^2,2))-9) ); % 矩形和圓形幾何定義
fh = @(p) 0.05 + 0.01*(sqrt(sum(p.^2,2))-9); % 在圓形邊界附近加密網格

[p,t] = distmesh(fd, fh, 1, [-45,-45;45,45], []); % 將初始網格間距設置為 1 增加點密度

% 檢查生成的點和三角形
disp(size(p)) % 顯示點集大小
disp(size(t)) % 顯示三角形索引大小

% 找最左和最右的邊界節點
x_coords = p(:, 1);
left_boundary_nodes = find(x_coords == min(x_coords));  % 最左邊節點
right_boundary_nodes = find(x_coords == max(x_coords)); % 最右邊節點

% 輸出最左和最右的邊界節點及其坐標
disp('Left Boundary Nodes:');
disp(left_boundary_nodes);
disp('Coordinates:');
disp(p(left_boundary_nodes, :));

disp('Right Boundary Nodes:');
disp(right_boundary_nodes);
disp('Coordinates:');
disp(p(right_boundary_nodes, :));

% 施加力
total_force = 1e3; 
num_left_nodes = length(left_boundary_nodes); % 最左邊節點的個數
num_right_nodes = length(right_boundary_nodes); % 最右邊節點的個數

% 計算每個節點施加的力
if num_left_nodes > 0
    left_force_per_node = -total_force / num_left_nodes;
else
    left_force_per_node = 0;
end

if num_right_nodes > 0
    right_force_per_node = total_force / num_right_nodes;
else
    right_force_per_node = 0;
end

% 输出施加的力
disp(['Force applied at each left boundary node: ', num2str(left_force_per_node), ' N']);
disp(['Force applied at each right boundary node: ', num2str(right_force_per_node), ' N']);

% 創建矩陣來儲存施加的力
left_force_matrix = left_force_per_node * ones(num_left_nodes, 1); % 左邊界節點施加的力
right_force_matrix = right_force_per_node * ones(num_right_nodes, 1); % 右邊界節點施加的力
% 
% % 輸出施加的力矩陣
% disp('Left Force Matrix:');
% disp(left_force_matrix);
% disp('Right Force Matrix:');
% disp(right_force_matrix);

% 左邊界節點數據
Node_load_coor_left = [left_boundary_nodes, left_force_matrix];

% 右邊界節點數據
Node_load_coor_right = [right_boundary_nodes, right_force_matrix];

% 將左右邊界的數據合併
Node_load_coor = [Node_load_coor_left; Node_load_coor_right];

% 列印結果
disp('Node, Force :');
disp(Node_load_coor);
%%
% 可視化網格
figure;
patch('vertices', p, 'faces', t, 'facecolor', [.9, .9, .9], 'edgecolor', 'black');
axis equal;
title('Rectangle with Circular Hole');

% 在每個節點位置標注節點編號
hold on;

for i = 1:size(p,1)
    text(p(i,1), p(i,2), num2str(i), 'FontSize', 10, 'Color', 'blue');
end

% 在每個三角形單元中心標注單元編號
for i = 1:size(t,1)
    % 計算三角形單元的中心
    center = mean(p(t(i,:), :), 1);
    text(center(1), center(2), num2str(i), 'FontSize', 10, 'Color', 'red');
end
hold off;

%% 將數據儲存為 .h5 文件
filename = 'circular_hole_mesh_data.h5';

% 如果檔案已經存在，先刪除它
if exist(filename, 'file') == 2
    delete(filename);
end

% 參數（num-dim)
num_dim = 2;
num_node = size(p, 1);         % 計算節點數量
num_elem = size(t, 1);         % 計算單元數量
num_elem_node = size(t, 2);    % 每個單元的節點數量
elem_conn = t';                % 單元節點連接
thickness=5;

h5create(filename, '/PARAMETER/num-dim', 1);  % 創建數據集
h5create(filename, '/PARAMETER/thickness', 1);

h5write(filename, '/PARAMETER/num-dim', num_dim);  % 寫入數據
h5write(filename, '/PARAMETER/thickness',thickness);

% 材料屬性（MATPROP)
b_plane_strain = 1;
young_modulus = 200e9;
poisson_ratio = 0.3;


h5create(filename, '/MATPROP/b-plane-strain', 1);
h5create(filename, '/MATPROP/young-modulus', 1);
h5create(filename, '/MATPROP/poisson-ratio', 1);

h5write(filename, '/MATPROP/b-plane-strain', b_plane_strain);
h5write(filename, '/MATPROP/young-modulus', young_modulus);
h5write(filename, '/MATPROP/poisson-ratio', poisson_ratio);

% 創建和寫入節點坐標 (p) 數據
h5create(filename, '/NODE/num-node', 1);
h5create(filename, '/NODE/nodal-coord', size(p'));
h5write(filename, '/NODE/num-node', num_node);
h5write(filename, '/NODE/nodal-coord', p'); % 寫入節點坐標

% （ELEMENT)
h5create(filename, '/ELEMENT/num-elem', 1);
h5create(filename, '/ELEMENT/num-elem-node', 1);
h5create(filename, '/ELEMENT/elem-conn', size(elem_conn));
h5write(filename, '/ELEMENT/num-elem', num_elem);
h5write(filename, '/ELEMENT/num-elem-node', num_elem_node);
h5write(filename, '/ELEMENT/elem-conn', elem_conn);


% 邊界條件（BOUNDARY）
num_prescribed_disp = 0;
num_prescribed_trac = 0;
num_prescribed_load = num_left_nodes+num_right_nodes;

h5create(filename, '/BOUNDARY/num-prescribed-disp', 1);
h5create(filename, '/BOUNDARY/num-prescribed-trac', 1);
h5create(filename, '/BOUNDARY/num-prescribed-load', 1);
h5create(filename, '/BOUNDARY/Node_load_coor', size(Node_load_coor)); 
h5create(filename,'/BOUNDARY/prescribed-disp',1);
h5create(filename,'/BOUNDARY/prescribed-trac',1);


h5write(filename, '/BOUNDARY/num-prescribed-disp', num_prescribed_disp);
h5write(filename, '/BOUNDARY/num-prescribed-trac', num_prescribed_trac);
h5write(filename, '/BOUNDARY/num-prescribed-load', num_prescribed_load);
h5write(filename, '/BOUNDARY/Node_load_coor', Node_load_coor);
h5write(filename,'/BOUNDARY/prescribed-disp',0);
h5write(filename,'/BOUNDARY/prescribed-trac',0);

disp(['Data successfully written to ', filename]);
