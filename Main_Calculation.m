function [area_final,level_final,phi_norm_final]...
    =Main_Calculation(input_vp,mesh,matrix,fun_features)
%The main function for the whole simulation

%% The initial value
phi=matrix.phi;

%% Initial Simulation
Simulation_Position(input_vp,mesh,phi,fun_features);

%% Necessary Parameters
N=input_vp.T/input_vp.dt; % # of time steps %T and dt IS NEEDED HERE
% delta=input_vp.cons*input_vp.h/...
%     norm([fun_features.cx;fun_features.cy],inf); % Stabilization
%     parameter for GLS
delta = 2*input_vp.cons*input_vp.h*...
    norm([fun_features.cx;fun_features.cy],inf); % Stabilization parameter 
% for Residual based artifical viscoisity method


%% Start Simulation
time=zeros(N+1,1);
err_area=zeros(N+1,1);
err_level=zeros(N+1,1);
phi_norm=zeros(N+1,1);

% For time=0
phi_norm(1)=norm(phi(mesh.free)); %(EXTRA)
[err_area(1),err_level(1)]=Error_calculation(input_vp,...
    mesh,fun_features,phi,time(1),input_vp.sim);

% For time>0
for i=1:N
    
    %% At which time step
    time(i+1)=i*input_vp.dt;
    
    %% Choose one of stabilization and time integration method
    [LHS,RHS] = convection(matrix.M,matrix.C,input_vp.dt,matrix.b_C0,...
        phi,delta,matrix.SD, matrix.A);
    
    pass_e=strcmp(input_vp.sim_case,'e') || strcmp(input_vp.sim_case,'ec');
    if (pass_e) % For experiment case
        
        
        %% Find the solution considering boundary conditions
        RHS=RHS(mesh.free)-LHS(mesh.free,mesh.fixed)*mesh.g(mesh.p(1,...
            mesh.fixed),mesh.p(2,mesh.fixed),time(i+1))';
        LHS=LHS(mesh.free,mesh.free);
        phi(mesh.fixed)=mesh.g(mesh.p(1,mesh.fixed),mesh.p(2,mesh.fixed),...
            time(i+1))';
        phi(mesh.free)=LHS\RHS; %solve for free node values for the
        %% First experiment
        vx=fun_features.cx(1);
        vy=fun_features.cy(1);
        fun_features.xc=fun_features.xc+input_vp.dt*vx;
        fun_features.yc=fun_features.yc+input_vp.dt*vy;
        %% Second Experiment
        %         vx=(-sin(pi*0.5*fun_features.yc/max(mesh.y)))*0.1;
        %         vy=sin(pi*0.5*fun_features.xc/max(mesh.x))*0.1;
        %         fun_features.xc=fun_features.xc+input_vp.dt*vx;
        %         fun_features.yc=fun_features.yc+input_vp.dt*vy;
        
    else % For benchmark case
        %% Find the solution considering boundary conditions
        RHS=RHS(mesh.free)-LHS(mesh.free,mesh.fixed)*mesh.g(mesh.p(1,...
            mesh.fixed),mesh.p(2,mesh.fixed),input_vp.dt)';
        LHS=LHS(mesh.free,mesh.free);
        phi(mesh.fixed)=mesh.g(mesh.p(1,mesh.fixed),mesh.p(2,mesh.fixed),...
            input_vp.dt)';
        phi(mesh.free)=LHS\RHS; %solve for free node values for the
        
        %% If it is the standard level set function
        if input_vp.tvsd=='d'
            [mesh.g,fun_features.xc,fun_features.yc]=Follow_V(mesh.p(1,:),...
                mesh.p(2,:),fun_features.xc,fun_features.yc,fun_features.r...
                ,fun_features.cx,fun_features.cy,input_vp.dt);
        else
            [~,fun_features.xc,fun_features.yc]=Follow_V(mesh.p(1,:),...
                mesh.p(2,:),fun_features.xc,fun_features.yc,fun_features.r...
                ,fun_features.cx,fun_features.cy,input_vp.dt);
        end
    end
    
    
    
    %% and Norm of the free nodes (EXTRA)
    phi_norm(i+1)=norm(phi(mesh.free));
    
    %% Reinitialization method
    if input_vp.re_method=='y'
        [phi,~,~,~]=Reinitialization(input_vp,...
            mesh,matrix,fun_features,phi,i,time);
    end
    
    %% Plot the results (EXTRA)
    %     figure;
    %     plot(0:input.iter,[err_mass_0 err_mass],'-*',0:input.iter,...
    %         [err_area_0 err_area],'-*',...
    %         0:input.iter,[err_level_0 err_level],'-*');
    %     xlabel '# of iteration'; ylabel 'error';
    %     title(['h=',num2str(input.h)]);
    %     legend('area error','mass conservative error',...
    %         'level set function error'); grid on;
    %     pause;
    
    %% Show the results
    switch input_vp.sim
        
        case '1' % Show the simulation
            Show_Simulation(phi,mesh,time(i+1),input_vp,fun_features);
            [err_area(i+1),err_level(i+1)]...
                =Error_calculation(input_vp,mesh,fun_features,phi,time(i+1),...
                'y');
            % Calculate the errors in the simulation
            pause(input_vp.ps);
            
        case '2' %Show the plot results
            [err_area(i+1),err_level(i+1)]...
                =Error_calculation(input_vp,mesh,fun_features,phi,time(i+1),...
                input_vp.sim);
            % Calculate the errors in the simulation
            figure(1); % Plot Simulation Error
            h1=plot(time(1:i+1),err_area(1:i+1),'-*',time(1:i+1),...
                err_level(1:i+1),'-*');
            set(h1,'LineWidth',2.5);
            set(gca,'FontSize',input_vp.FS);
            xlabel 'time';  ylabel 'Relative error'; ylim([0 1]);
            legend('area error','mass conservative error',...
                'level set function error','Location','NorthWest');
            grid on; title 'Simulation Error';
            
            figure(2); % Plot Norm (EXTRA)
            h2=plot(time(1:i+1),phi_norm(1:i+1),'-*');
            set(h2,'LineWidth',2.5);
            set(gca,'FontSize',input_vp.FS);
            xlabel 'time';  ylabel 'Norm';
            grid on; title(['Norm for free nodes of U (',input_vp.tvsd,')']);
            
        case '3' %Just calculate
            [err_area(i+1),err_level(i+1)]...
                =Error_calculation(input_vp,mesh,fun_features,phi,time(i+1),...
                'n');
            
    end
    
end

%% Return the final error results
level_final=err_level(end);
area_final=err_area(end);
phi_norm_final=phi_norm(end); %(EXTRA)

end
