
function [elemStress,elemEpsilon]=SolveElemStrain( nelem, coor, conn,mate,glob_u,thickness)
    elemEpsilon = zeros(3,nelem); % 初始化儲存應變的變量
    elemStress=zeros(3,nelem);

    for j = 1:nelem
        % 計算當前元素的Ke
        [kel ,Bel, Del] = ElemStif(j, mate, coor, conn,thickness);
        
        % 取得當前元素的節點編號
        node_ids = conn(:, j);
        
        % 根據節點編號從 glob_u 中取得對應的位移值
        elem_u = glob_u([2*node_ids(1)-1, 2*node_ids(1), ...
                         2*node_ids(2)-1, 2*node_ids(2), ...
                         2*node_ids(3)-1, 2*node_ids(3)]);

        % 計算當前元素的應變 
        elemEpsilon(:,j) = Bel*elem_u;
        elemStress(:,j)=Del*elemEpsilon(:,j);
    end
end
