function [LHS2,RHS2] = Conservative_Rein(phi,p,t,b_C1,M,dtor,A,eps)
%% Reinitialization Method: Martin's paper WITHOUT n in the diffusion part

F=b_C1;

[phix,~]=pdegrad(p,t,phi);
phix=pdeprtni(p,t,phix);
[~,phiy]=pdegrad(p,t,phi);
phiy=pdeprtni(p,t,phiy);
[phixx,~]=pdegrad(p,t,phix);
phixx = pdeprtni(p,t,phixx);
[~,phiyy]=pdegrad(p,t,phiy);
phiyy = pdeprtni(p,t,phiyy);

%% First (for very small mesh size, use this)
% ADD=1e-6;
%
% B=2*sqrt(phix.^2+phiy.^2).*phi-(1-phi.^2).*(phixx+phiyy)...
%     ./(sqrt(phix.^2+phiy.^2)+ADD);
% F=F.*B;
%
% %Backward Euler
% LHS2=M+dtor*eps*A;
% RHS2=M*phi+dtor*F;


%% First-b (default)

B=2*sqrt(phix.^2+phiy.^2).^2.*phi-(1-phi.^2).*(phixx+phiyy);
F=F.*B;

%Backward Euler
LHS2=(M+dtor*eps*A).*repmat(sqrt(phix.^2+phiy.^2),1,length(phi));
RHS2=M*phi.*sqrt(phix.^2+phiy.^2)+dtor*F;


end
