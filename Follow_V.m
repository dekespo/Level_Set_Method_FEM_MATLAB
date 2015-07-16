function [g,xc,yc]=Follow_V(x,y,xc,yc,r,cx,cy,t)
% Create new boundary values for the standard level set method

F_x=scatteredInterpolant(x',y',cx);
F_x.Method='natural';
F_y=scatteredInterpolant(x',y',cy);
F_y.Method='natural';
cvx=F_x(xc,yc);
cvy=F_y(xc,yc);

g=@(x,y,ti) distance(x,y,r,xc+cvx*ti,yc+cvy*ti);
xc=xc+cvx*t;
yc=yc+cvy*t;

end