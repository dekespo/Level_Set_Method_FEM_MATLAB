function [b_C0,M,b_C1,A,C,SD,cx,cy,np]=Assemble_matrix_vectors_bench(p,e,t)
%% To see the mesh
% figure;
% subplot(2,1,1);
% pdemesh(p,e,t);

%% Assembling Matrices and Vectors

b_C0=LoadAssembler2D(p,t,@(x,y) 0); %load vector constant b=0
M=MassAssembler2D(p,t); %mass matrix
b_C1=LoadAssembler2D(p,t,@(x,y) 1); %load vector constant b=1
A=StiffnessAssembler2D(p,t,@(x,y) 1); %stiffness matrix


%% Stoke Lid-Driven Cavity
np=size(p,2); %number of nodes
nt=size(t,2); %number of elements
z=zeros(np+nt,1);
[AA,Bx,By,a] = assemble(p,e,t);
A_tot=[1*AA 0*AA Bx z;
    0*AA 1*AA By z;
    Bx' By' sparse(np,np) a;
    z' z' a' 0]; %Fluid Mechanics
b_tot = zeros(size(A_tot,1),1);
[A_tot,b_tot]=setbc(p,e,t,A_tot,b_tot);
x_tot=A_tot\b_tot;
xi=x_tot(1:np); eta=x_tot(np+nt+1:2*np+nt); %Convection field (solutions)
% theta=x_tot(2*(np+nt)+1:end-1); %Pressure (Solution)

cx=xi; cy=eta; %Convection field
C=ConvectionAssembler2D(p,t,cx,cy); %convection matrix
SD=SDAssembler2D(p,t,cx,cy); %Streamline-diffusion matrix
end