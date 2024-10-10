clear;
clc;

% 定義矩形的距離函數
drectangle = @(p, x1, x2, y1, y2) ...
    -min(min(min(-y1 + p(:, 2), y2 - p(:, 2)), -x1 + p(:, 1)), x2 - p(:, 1));

% 定義圓形的距離函數
dcircle = @(p, xc, yc, r) sqrt((p(:, 1) - xc).^2 + (p(:, 2) - yc).^2) - r;

% 整體幾何形狀的距離函數
fd = @(p) min(min(max(max( ...
    drectangle(p, -90, 90, -45, 45), ...     % 大矩形
    -drectangle(p, 0, 91, 30, 46)), ...      % 小矩形 1
    -drectangle(p, 0, 91, -46, -30)), ...    % 小矩形 2
    drectangle(p, 0, 9, 30, 39)), ...        % 小矩形 3
    drectangle(p, 0, 9, -39, -30));          % 小矩形 4

% 定義圓形的距離計算
cir1 = @(p) dcircle(p, 9, 39, 9);               % 圓形 1
cir2 = @(p) dcircle(p, 9, -39, 9);              % 圓形 2

% 結合圓形的距離與幾何形狀的距離
d = @(p) max(fd(p), -cir1(p));                  % 定義新的距離函數
d = @(p) max(d(p), -cir2(p));                   % 更新距離函數

% 定義加密網格的距離函數
fh = @(p) 0.05 + 0.025*(sqrt((p(:, 1) - 9).^2 + (p(:, 2) - 39).^2) - 9); 

% 使用 distmesh 生成網格
[p, t] = distmesh(@(p) d(p), fh, 1, [-90, -45; 90, 45], []); % 初始網格間距為 1

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
    center = mean(p(t(i,:), :), 1);
    text(center(1), center(2), num2str(i), 'FontSize', 10, 'Color', 'red');
end
hold off;
