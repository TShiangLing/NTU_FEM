function Max_column = FindMaxStress(elemStress)
    % elemStress 是 3 x nelem 的矩陣

    % 對每一列的絕對值最大值進行搜索
    [max_values, ~] = max(abs(elemStress), [], 1);  % 找到每一列的絕對值最大值

    % 找到列的索引，該列包含全局絕對值最大元素
    [~, col_index] = max(max_values);

    % 找到包含全局最大值的列
    Max_column = elemStress(:, col_index);
end
