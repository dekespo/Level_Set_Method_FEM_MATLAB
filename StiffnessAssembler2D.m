function A=StiffnessAssembler2D(p,t,a)
%Stiffnes matrix for
%integral(a(x,y)*Dphi1*Dphi2)dxdy
% with center of gravity value
% for a(x,y), a(x,y) is a function
np=size(p,2); %# of nodes
nt=size(t,2); %# of elements
A=sparse(np,np); %allocate mass matrix
for K=1:nt %loop over elements
    loc2glb=t(1:3,K); %local-to-global map
    x=p(1,loc2glb); %node x-coordinates
    y=p(2,loc2glb); %node y-coordinates
    area=polyarea(x,y); %triangle area
    b=[y(2)-y(3); y(3)-y(1); y(1)-y(2)]*0.5/area; %Hat Gradients
    c=[x(3)-x(2); x(1)-x(3); x(2)-x(1)]*0.5/area; %Hat Gradients
    xc=mean(x);yc=mean(y); %element centroid
    abar=a(xc,yc).^2; %value of a(x,y) at centroid
    AK=abar*(b*b'+c*c')*area; %element stiffnes matrix 3x3
    A(loc2glb,loc2glb)=A(loc2glb,loc2glb)+AK; %add element stiffnesses to A
end