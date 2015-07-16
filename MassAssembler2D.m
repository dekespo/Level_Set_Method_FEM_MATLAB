function M=MassAssembler2D(p,t)
%Mass matrix for integral(phi1*phi2)dx
np=size(p,2); %# of nodes
nt=size(t,2); %# of elements
M=sparse(np,np); %allocate mass matrix
for K=1:nt %loop over elements
    loc2glb=t(1:3,K); %local-to-global map
    x=p(1,loc2glb); %node x-coordinates
    y=p(2,loc2glb); %node y-coordinates
    area=polyarea(x,y); %triangle area
    MK=[2 1 1; 1 2 1; 1 1 2]*area/12; %element mass matrix 3x3
    M(loc2glb,loc2glb)=M(loc2glb,loc2glb)+MK; %add element masses to M
end