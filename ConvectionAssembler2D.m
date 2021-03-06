function C=ConvectionAssembler2D(p,t,bx,by)
%Convection matrix for
%integral(b(x,y)*Dphi1*phi2)dxdy
% with center of gravity value
% for b(x,y), b(x,y) is a function
np=size(p,2); %# of nodes
nt=size(t,2); %# of elements
C=sparse(np,np); %allocate mass matrix
for K=1:nt %loop over elements
    loc2glb=t(1:3,K); %local-to-global map
    x=p(1,loc2glb); %node x-coordinates
    y=p(2,loc2glb); %node y-coordinates
    area=polyarea(x,y); %triangle area
    b=[y(2)-y(3); y(3)-y(1); y(1)-y(2)]*0.5/area; %Hat Gradients
    c=[x(3)-x(2); x(1)-x(3); x(2)-x(1)]*0.5/area; %Hat Gradients
    bxmid=mean(bx(loc2glb));
    bymid=mean(by(loc2glb));
    CK=ones(3,1)*(bxmid*b+bymid*c)'*area/3; %element convection matrix 3x3
    C(loc2glb,loc2glb)=C(loc2glb,loc2glb)+CK; %add element convection to A
end