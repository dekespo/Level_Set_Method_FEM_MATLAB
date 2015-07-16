function Eigenvalue_Check(M,C,SD,h,v_x,v_y,c)
% Checking positive eigenvalues and returning the maximum positive
% eigenvalue.

delta=c*h/norm([v_x;v_y],inf); % Stability paramter
lam=-M\(C+delta*SD); % Semi-discretised form
max_eig_val=max(real(eig(full(lam)))); %
disp(['The given c value is ',num2str(c)])
disp(['The maximum velocity is ', num2str(norm([v_x;v_y],inf))]);
disp(['The stabilization parameter is ', num2str(delta)]);
if ( max_eig_val >0 )
    disp('EIGENVALUES ARE NOT SATISFIED!');
    disp(['Maximum positive eigenvalue is: ', num2str(max_eig_val)]);
else
    disp('IT PASSED, NO POSITIVE EIGENVALUES.');
end

end