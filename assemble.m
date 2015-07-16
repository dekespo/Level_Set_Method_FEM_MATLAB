function [A,Bx,By,a] = assemble(p,e,t)
% Assembler for the fluid mechanics
np=size(p,2); nt=size(t,2);
A=sparse(np+nt,np+nt);
Bx=sparse(np+nt,np);
By=sparse(np+nt,np);
a=zeros(np,1);
for i=1:nt
    % nodes, node coordinates, triangle area
    nodes=t(1:3,i);
    x=p(1,nodes); y=p(2,nodes);
    dx=polyarea(x,y);
    % velocity degrees of freedom
    dofs=[nodes; np+i];
    % hat function gradients
    b=[y(2)-y(3); y(3)-y(1); y(1)-y(2)]/2/dx;
    c=[x(3)-x(2); x(1)-x(3); x(2)-x(1)]/2/dx;
    % element stiffness matrix
    AK=zeros(4,4);
    AK(1:3,1:3)=(b*b'+c*c')*dx;
    AK(4,4)=sum(sum((b*b'+c*c').*[2 1 1; 1 2 1; 1 1 2]*dx/180));
    A(dofs,dofs)=A(dofs,dofs)+AK;
    % element divergence matrix
    BK=zeros(4,3);
    BK(1:3,1:3)=-b*ones(1,3)*dx/3;
    BK(4,:)=(-[1 2 2; 2 1 2; 2 2 1]/60*dx*b)';
    Bx(dofs,nodes)=Bx(dofs,nodes)+BK;
    BK(1:3,1:3)=-c*ones(1,3)*dx/3;
    BK(4,:)=(-[1 2 2; 2 1 2; 2 2 1]/60*dx*c)';
    By(dofs,nodes)=By(dofs,nodes)+BK;
    % constraints to enforce mean value zero for the pressure
    a(nodes)=a(nodes)+ones(3,1)*dx/3;
end
end
