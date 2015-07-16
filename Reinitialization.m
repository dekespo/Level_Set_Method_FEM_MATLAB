function [phi,err_mass,err_area,err_level]=Reinitialization(input_vp,...
    mesh,matrix,fun_features,phi,i,time)
% Reinitialization Method both for the standard and conservative
% level set functions.

%% Save the previous level set function
phi_prev=phi;

%% Allocation (EXTRA)
err_mass=zeros(input_vp.iter,1);
err_area=zeros(input_vp.iter,1);
err_level=zeros(input_vp.iter,1);

%% Start Reinitialization Method
for l=1:input_vp.iter % Usually a few steps %iter IS NEEDED HERE
    
    
    %% Choosing the right reinitialization method
    %dtor and eps ARE NEEDED HERE
    switch input_vp.tvsd
        
        case 'd' %Standard level set function
            
            %Explicit method
            [LHS2,RHS2] = Standard_Rein(phi,phi_prev,input_vp.h,...
                matrix.M,input_vp.dtor,matrix.b_C1,mesh.p,mesh.t);
            
        case 't' %Conservative level set function
            
            %Martin without n
            [LHS2,RHS2] = Conservative_Rein(phi,mesh.p,...
                mesh.t,matrix.b_C1,matrix.M,...
                input_vp.dtor,matrix.A,input_vp.eps);
            
    end
    
    %% Find the solution considering boundary conditions
    RHS2=RHS2(mesh.free)-LHS2(mesh.free,mesh.fixed)*...
        mesh.g(mesh.p(1,mesh.fixed),mesh.p(2,mesh.fixed),time(i+1))';
    LHS2=LHS2(mesh.free,mesh.free);
    phi(mesh.fixed)=mesh.g(mesh.p(1,mesh.fixed),...
        mesh.p(2,mesh.fixed),time(i+1))';
    phi(mesh.free)=LHS2\RHS2; %solve for free node values for the level
    %set function
    
    
    %% Calculate the errors (EXTRA)
    [err_area(l),err_level(l)]=Error_calculation...
        (input_vp,mesh,fun_features,phi,time(i+1),'n');
    
end

end
