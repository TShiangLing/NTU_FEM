%  The "kel" matrix is element stiffness matrix of each Element.
function kel = ElemStif(iel, mate, coor, conn)
    x1a = coor(1,conn(1,iel));
    x2a = coor(2,conn(1,iel));
    x1b = coor(1,conn(2,iel));
    x2b = coor(2,conn(2,iel));
    x1c = coor(1,conn(3,iel));
    x2c = coor(2,conn(3,iel));


    % dif Na/x1 Nb/x1 Nc/x1 Na/x2 Nb/x2 Nc/x2
    d_Na_x1 = -(x2c-x2b)/((x2a-x2b)*(x1c-x1b)-(x1a-x1b)*(x2c-x2b));
    d_Nb_x1 = -(x2a-x2c)/((x2b-x2c)*(x1a-x1c)-(x1b-x1c)*(x2a-x2c));
    d_Nc_x1 = -(x2b-x2a)/((x2c-x2a)*(x1b-x1a)-(x1c-x1a)*(x2b-x2a));
    d_Na_x2 = (x1c-x1b)/((x2a-x2b)*(x1c-x1b)-(x1a-x1b)*(x2c-x2b));
    d_Nb_x2 = (x1a-x1c)/((x2b-x2c)*(x1a-x1c)-(x1b-x1c)*(x2a-x2c));
    d_Nc_x2 = (x1b-x1a)/((x2c-x2a)*(x1b-x1a)-(x1c-x1a)*(x2b-x2a));

    % B:Shape function derivations (constant strain elements) 
    B = zeros(3,6);
    B(1, 1) = d_Na_x1;
    B(1, 2) = 0;
    B(1, 3) = d_Nb_x1;
    B(1, 4) = 0;
    B(1, 5) = d_Nc_x1;
    B(1, 6) = 0;

    B(2, 1) = 0;
    B(2, 2) = d_Na_x2;
    B(2, 3) = 0;
    B(2, 4) = d_Nb_x2;
    B(2, 5) = 0;
    B(2, 6) = d_Nc_x2;

    B(3, 1) = d_Na_x2;
    B(3, 2) = d_Na_x1;
    B(3, 3) = d_Nb_x2;
    B(3, 4) = d_Nb_x1;
    B(3, 5) = d_Nc_x2;
    B(3, 6) = d_Nc_x1;
    
    % Area of element
    
    ael = (1/2)*abs((x1b-x1a)*(x2c-x2a)-(x1c-x1a)*(x2b-x2a));
%     la = ((x1a-x1b)^2+(x2a-x2b)^2)^0.5;
%     lb = ((x1b-x1c)^2+(x2b-x2c)^2)^0.5;
%     lc = ((x1c-x1a)^2+(x2c-x2a)^2)^0.5;
%     ls = (la + lb + lc)/2;
%     ael = (ls*(ls-la)*(ls-lb)*(ls-lc))^0.5;
    % D: material property matrix
    if (mate(1) == 1)
        D = [1-mate(3) mate(3) 0; mate(3) 1-mate(3) 0; 0 0 (1-2*mate(3)) / 2];
        D = D*mate(2)/(1+mate(3))/(1-2*mate(3));
    else
        D = [1 mate(3) 0; mate(3) 1 0; 0 0 (1-mate(3)) / 2];
        D = D*mate(2)/(1-mate(3)*mate(3));
    end

    % K: element stiffness matrix
    kel = ael*B.'*D*B;
end

