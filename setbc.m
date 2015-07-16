function [A,b]=setbc(p,e,t,A,b)
% Boundary conditions for the fluid mehcnics
np=size(p,2); nt=size(t,2);
for i=1:np
    x=p(1,i); y=p(2,i);
    if (x<-0.999 || x>0.999 || y<-0.999 || y>0.999) % cavity wall
        A(i,:)=0;
        A(i,i)=1; b(i)=0; % ux=0
        A(np+nt+i,:)=0;
        A(np+nt+i,np+nt+i)=1; b(np+nt+i)=0; % uy=0
    end
    if (y>0.999) % the lid of the cavity
        b(i)=1; % ux=1
    end
    if (y<-0.999)
        b(i)=0;
    end
end
end
