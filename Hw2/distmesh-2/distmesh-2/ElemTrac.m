function rel = ElemTrac(itrac, coor, conn, trac)
    iel = trac(1, itrac);
    if(trac(2, itrac) == 1)
        x1a = coor(1, conn(1, iel));
        x2a = coor(2, conn(1, iel));
        x1b = coor(1, conn(2, iel));
        x2b = coor(2, conn(2, iel));
    elseif(trac(2, itrac) == 2)
        x1a = coor(1, conn(2, iel));
        x2a = coor(2, conn(2, iel));
        x1b = coor(1, conn(3, iel));
        x2b = coor(2, conn(3, iel));
    else
        x1a = coor(1, conn(3, iel));
        x2a = coor(2, conn(3, iel));
        x1b = coor(1, conn(1, iel));
        x2b = coor(2, conn(1, iel));
    end
    lel = sqrt((x2b-x2a)^2+(x1b-x1a)^2);
    rel = zeros(4, 1);
    rel(1) = trac(3,itrac)*lel / 2;
    rel(2) = trac(4,itrac)*lel / 2;
    rel(3) = trac(3,itrac)*lel / 2;
    rel(4) = trac(4,itrac)*lel / 2;
end
