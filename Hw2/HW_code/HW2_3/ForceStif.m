function fglob=ForceStif(nnode,load)
fglob = zeros(nnode*2,1);

% 遍歷 load 矩陣的每一行
for i = 1:size(load, 1)
    node_position = load(i, 1);  % 取得節點索引
    force_value = load(i, 2);    % 取得對應的力值

    % 將 force_value 放入對應的 fglob 位置
    fglob(2*node_position-1) = force_value; % x 方向的力
end
end