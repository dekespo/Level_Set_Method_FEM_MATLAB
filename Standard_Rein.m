function [LHS2,RHS2] = Standard_Rein(phi,phi_prev,h,M,dtor,b_C1,p,t)
%% Reinitialization Method: Distance Full Explicit

[phix,phiy]=pdegrad(p,t,phi);
phix = pdeprtni(p,t,phix);
phiy = pdeprtni(p,t,phiy);

Seps=phi_prev./sqrt(phi_prev.^2+h.^2);
F=b_C1.*Seps;

%Backward or forward euler
LHS2=M;
RHS2=M*phi+dtor*F.*(1-sqrt(phix.^2+phiy.^2));

end
