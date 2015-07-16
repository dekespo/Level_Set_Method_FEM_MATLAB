function [LHS,RHS] = convection(M,C,dt,b,phi,delta,SD, A)
%% Crank-Nicolson time integration with GLS

% LHS=2*M+dt*(C+delta*SD);
% RHS=b+(2*M-dt*(C+delta*SD))*phi;

%% Residual Based Artificial Viscosity Method

LHS=2*M+dt*(C+delta*A);
RHS=b+(2*M-dt*(C+delta*A))*phi;
end