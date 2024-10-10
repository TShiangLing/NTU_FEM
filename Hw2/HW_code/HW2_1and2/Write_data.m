clear;
clc;

% 創建一個 .h5 檔案，並創建資料集
filename = 'Data_hw2_2.h5';

% 生成一些資料
% coor=[0 2 4 1 3 2; 0 0 0 sqrt(3) sqrt(3) 2*sqrt(3)];
% conn=[1 2 2 4; 2 5 3 5; 4 4 5 6];

coor=[0 2 4 6 8 0 2 4 6 8 0 2 4 6 8; 0 0 0 0 0 2 2 2 2 2 4 4 4 4 4];
conn=[1 2 3 4 6 7 8 9; 2 3 4 5 7 8 9 10; 7 8 9 10 12 13 14 15; 6 7 8 9 11 12 13 14];

% 如果檔案已經存在，先刪除它
if exist(filename, 'file') == 2
    delete(filename);
end

%創建資料集
h5create(filename, '/coor', size(coor));
h5create(filename, '/conn', size(conn));

% 將資料寫入
h5write(filename, '/coor', coor);
h5write(filename, '/conn', conn);

% 確認檔案內容
info = h5info(filename);
disp(info);