function b=LoadAssembler2D(p,t,f)
% for integral(f*phi)dx with node
% quadrature for f, f does not
% have to be considered as
% a vector
np=size(p,2); %# of nodes
nt=size(t,2); %# of elements
b=zeros(np,1); %allocate mass matrix
for K=1:nt %loop over elements
    loc2glb=t(1:3,K); %local-to-global map
    x=p(1,loc2glb); %node x-coordinates
    y=p(2,loc2glb); %node y-coordinates
    area=polyarea(x,y); %triangle area
    bK=[f(x(1),y(1)); f(x(2),y(2));f(x(3),y(3))]*area/3;
    %element load vector 3x1
    b(loc2glb)=b(loc2glb)+bK;...
        %add element loads to b
end