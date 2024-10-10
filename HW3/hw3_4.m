clear;
clc;

% 定義函數
f = @(x) 6 + 12 * x.^3 + 4 * x.^6;

% 直接積分
direct_integral = integral(f, -1, 1);

% 高斯積分
n = 3;
[xi, wi] = gauss_points(n);

gauss_integral = sum(wi .* f(xi));

% 輸出結果
fprintf('直接積分結果: %.6f\n', direct_integral);
fprintf('高斯積分結果: %.6f\n', gauss_integral);

% 高斯點和權重計算函數
function [etai, wi] = gauss_points(n)
    if n == 1
        wi = 2;
        etai = 0;
    elseif n == 2
        wi = [1, 1];
        etai = [-1/sqrt(3), 1/sqrt(3)];
    elseif n == 3
        wi = [5/9, 8/9, 5/9];
        etai = [-sqrt(3/5), 0, sqrt(3/5)];
    else
        error('目前只支持 1, 2 和 3 點高斯積分');
    end
end
