function Sd=SDAssembler2D(p,t,bx,by)
%SD (Streamline-Diffusion) stabilization matrix for
%integral(b(x,y)*Dphi1*b(x,y)*Dphi2)dxdy
% with center of gravity value
% for b(x,y), b(x,y) is a function
% it is more stable than standard
% galerkin method. It is least-
% square galerkin (GLS)
np=size(p,2); %# of nodes
nt=size(t,2); %# of elements
Sd=sparse(np,np); %allocate mass matrix
for K=1:nt %loop over elements
    loc2glb=t(1:3,K); %local-to-global map
    x=p(1,loc2glb); %node x-coordinates
    y=p(2,loc2glb); %node y-coordinates
    area=polyarea(x,y); %triangle area
    b=[y(2)-y(3); y(3)-y(1); y(1)-y(2)]*0.5/area; %Hat Gradients
    c=[x(3)-x(2); x(1)-x(3); x(2)-x(1)]*0.5/area; %Hat Gradients
    bxmid=mean(bx(loc2glb));
    bymid=mean(by(loc2glb));
    SdK=(bxmid*b+bymid*c)*(bxmid*b+bymid*c)'*area; %element SD matrix 3x3
    Sd(loc2glb,loc2glb)=Sd(loc2glb,loc2glb)+SdK; %add element SD to A
end