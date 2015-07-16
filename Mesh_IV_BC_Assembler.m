function [err_area,err_level,measure_e]...
    =Mesh_IV_BC_Assembler(input_vp)

%% Mesh Generation, Initial Value for the Convection Equation and Boundary
%% Conditions and Matrices for FEM are assembled here

%% Geometry and Mesh
geom = square(-1,1,-1,1);
[p,e,t]=initmesh(geom,'hmax',input_vp.h);

%% Allocation
err_level=zeros(input_vp.nh,1);
err_area=zeros(input_vp.nh,1);
phi_norm=zeros(input_vp.nh,1);
measure_e=zeros(input_vp.nh,1);

%% For each MATLAB refinement(it is 1 for other methods)
for i=1:input_vp.nh
    
    pass_e=strcmp(input_vp.sim_case,'e') || strcmp(input_vp.sim_case,'ec')...
        || strcmp(input_vp.sim_case,'R_e');
    if(pass_e) % Experiment case is chosen
        [cx,cy,b_C0,C,M,SD,b_C1,A,np]=Assemble_matrix_vector_exp(p,t);
    else % Benchmark case is chosen
        [b_C0,M,b_C1,A,C,SD,cx,cy,np]=Assemble_matrix_vectors_bench(p,e,t);
    end
    
    %% Checking for the maximum positive eigenvalue (not recommended
    %% using this for plotting convergence)
    if input_vp.Eig_Val_Check=='y'
        Eigenvalue_Check(M,C,SD,input_vp.h,cx,cy,input_vp.cons);
        ans1=input('Do you want to continue? y to continue, else to stop:'...
            ,'s');
        if ans1~='y'
            error('The process is TERMINATED by the user');
        end
    end
    
    %% The Inital Value for the Level Set Function
    phi=distance(p(1,:),p(2,:),input_vp.r,input_vp.xc,input_vp.yc)';
    %Standard level set function
    if input_vp.tvsd=='t'
        phi=tanh(phi/(input_vp.epsilon*input_vp.h/2^(input_vp.nh-1)));
        %Conservative level set function
    end
    
    %% Boundary Conditions with corresponding points
    x=p(1,1:np); y=p(2,1:np); %Nodes
    
    r=input_vp.r;
    xc=input_vp.xc;
    yc=input_vp.yc;
    if(pass_e) % Experiment Case
        [fixed,free,g]=BC_exp(x,y,cx,cy,np,r,xc,yc,input_vp);
    else % Benchmark Case
        [fixed,free,g,xc,yc]=BC_bench(x,y,np,xc,yc,cx,cy,input_vp);
    end
    
    
    %% Packing data
    mesh=struct('p',p,'e',e,'t',t,'np',np,'fixed',fixed,'free',free,'g',g...
        ,'x',x,'y',y);
    matrix=struct('M',M,'C',C,'b_C0',b_C0,'phi',phi,'SD',SD,'b_C1',b_C1,...
        'A',A);
    fun_features=struct('r',r,'xc',xc,'yc',yc,...
        'epsilon',input_vp.epsilon,'cx',cx,'cy',cy);
    
    %% Simulation Error Run
    [err_area(i),err_level(i),phi_norm(i)]=Main_Calculation...
        (input_vp,mesh,matrix,fun_features);
    
    %% Area Measurement Error (EXTRA)
    measure_e(i)=Area_measurement_error(x,y,xc,yc,r,cx,cy,p,t,input_vp);
    
    %% MATLAB Refinement (EXTRA)
    if(i~=input_vp.nh)
        [p,e,t]=refinemesh(geom,p,e,t,'regular');
        disp(['REFINEMENT ',num2str(i)]);
    end
end

%% Show convergence rates using the article about convergence rates, they
%% are probably not correct, (EXTRA)
if(input_vp.nh>2)
    P_phinorm=log2((phi_norm(1)-phi_norm(2))/(phi_norm(2)-phi_norm(3))) %(EXTRA)
    P_level=log2((err_level(1)-err_level(2))/(err_level(2)-err_level(3)))
    P_area=log2((err_area(1)-err_area(2))/(err_area(2)-err_area(3)))
    P_measure=log2((measure_e(1)-measure_e(2))/(measure_e(2)-measure_e(3)))
end

end