function [cx,cy,b_C0,C,M,SD,b_C1,A,np]=Assemble_matrix_vector_exp(p,t)
%% Assembling Matrices and Vectors

%% First experiment set
np=size(p,2); %number of nodes
cx=0.05*ones(np,1); cy=0.05*ones(np,1); %convection field
b_C0=LoadAssembler2D(p,t,@(x,y) 0); %load vector constant b=0
C=ConvectionAssembler2D(p,t,cx,cy); %convection matrix
M=MassAssembler2D(p,t); %mass matrix
SD=SDAssembler2D(p,t,cx,cy); %Streamline-diffusion matrix
b_C1=LoadAssembler2D(p,t,@(x,y) 1); %load vector constant b=1
A=StiffnessAssembler2D(p,t,@(x,y) 1); %stiffness matrix


%% Second experiment set
% np=size(p,2); %number of nodes
% b_C0=LoadAssembler2D(p,t,@(x,y) 0); %load vector constant b=0
% M=MassAssembler2D(p,t); %mass matrix
% b_C1=LoadAssembler2D(p,t,@(x,y) 1); %load vector constant b=1
% A=StiffnessAssembler2D(p,t,@(x,y) 1); %stiffness matrix
% x=p(1,:); y=p(2,:);
% vx=@(x,y) -sin(pi*0.5*y/max(y))*0.1;
% vy=@(x,y) sin(pi*0.5*x/max(x))*0.1;
% vx_all=vx(x,y);
% vy_all=vy(x,y);
% cx=vx_all';
% cy=vy_all';
% % pdeplot(p,e,t,'flowdata',[cx cy])
% % xlabel('x','FontSize',14), ylabel('y','FontSize',14), hold off;
% % axis([-1 1 -1 1]);
% C=ConvectionAssembler2D(p,t,cx,cy); %convection matrix
% SD=SDAssembler2D(p,t,cx,cy); %Streamline-diffusion matrix

end