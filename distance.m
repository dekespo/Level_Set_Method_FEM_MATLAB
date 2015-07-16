function V=distance(pxs,pys,r,xc,yc)
%Distance Function
cen=[xc yc];
R=sqrt((pxs-cen(1)).^2+(pys-cen(2)).^2);
V=R-r;
end