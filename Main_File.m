%% Main_File.m
%% Use only this file by changing the input values in the section *****
%%

close all;clear; clc; % Close all plots and clear memory and terminal

%% Make sure that all m files are in the same directory
% cd ~/Master' Thesis_MATLAB'/MATLAB/Level-Set' Method'/2D/error' analysis'/ALL_BCs/Code/
% cd /Users\TOSHIBA\Desktop\Master' Thesis'\Master' Thesis_MATLAB'\MATLAB\Level-Set' Method'\2D\error' analysis'\ALL_BCs\Real_Case\

%% *****  Input values and parameters *****

sim_case='e';% 'e' for the experiment case, 'ec' for the constant
% convergence rate of the experiment, 'b' for the benchmark case,
% 'bc' for the constant convergence rate of the benchmark case, 'R_e'
% for the refinement of the experiment and 'R_b' for the refinement of the
% benchmark case

% Initial position and circle
r=0.1; xc=-0.5; yc=-0.5; % Radius and the centre point of the circle
epsilon=2; % Epsilon for numerical conservative level-set function

% Type of level set method
tvsd='t'; % The level set function: 'd'=standard and 't'=conservative

%GLS parameter
cons=0.03*1; % Constant for GLS method or stabilization parameter
% (c in the paper)

% Time and mesh size
nh=2; % Number of refinement for(R_e and R_b, nh=1 for the others)
h=0.05; % Mesh size (for only one)
% h=0.10:-0.01:0.05; % Mesh size (for more than one)
dt=0.01; % Time Step
ct=100; % Number of time step
T=ct*dt; % Total time step (change only dt and ct, please)

% Include reinitialization method
re_method='y'; % The renitialization method: 'y'=include and 'n'=
%don't include

% Reinitialization parameters
iter=2; % Number of iteration for reinitialization method
dtor=0.01*dt*0.1; % Pseduo time step the reinitailization method
eps=0.001*ones(1,length(h)); % Epsilon for diffusion in the
% conservative level set function

% Check eigenvalue
Eig_Val_Check='n'; % For checking positive eigenvalues for given one mesh
% size h, to check write 'y', else it won't check

% Types of reuslts and calculation
sim='1'; % '1'=Show the simulation, '2'= show the results in plots,
% '3'=Just calculate (the fastest method)
AZ=-45; EL=5; % Camera View for sim='1' AZ=-45; EL=0;
camera='n'; % F:Fixed axis, else not fixed axis for sim='1'
FS=16; % Font size for the figures' axes
ps=0.0; % Seconds pause for the simulation


pass_R=strcmp(sim_case,'R_e') || strcmp(sim_case,'R_b');
if (pass_R) % For MATLAB reinitiailizatoion (EXTRA)
    h=0.1; % Mesh size
    eps = 0.001; %Epsilon for diffusion in the
    % conservative level set function
else % Default
    nh=1; % Number of refinement
    pass_c=strcmp(sim_case,'e') || strcmp(sim_case,'b');
    if (~pass_c) %Constant convergence rate
        a=0.1; % Constant parameter in convergence rate (dt/dx=a)
        h=[0.1 0.05 0.025]; % Mesh size
        dt=a*h; % Time Step
        ct=1./h/a; % Number of time step
        dtor=0.01*dt*0.1; % Pseduo time step the reinitailization method
        eps=0.001*ones(1,length(h)); % Epsilon for diffusion in the
        % conservative level set function
    end
end


%% Input Information and Checking

switch sim_case
    case 'e'
        disp('Experiment case is CHOSEN.')
    case 'b'
        disp('Benchmark case is CHOSEN.');
    case 'ec'
        disp('Experiment case with constant convergence rate is CHOSEN.');
    case 'bc'
        disp('Benchmark case with constant convergence rate is CHOSEN.');
    case 'R_e'
        disp('Experiment case with refinement is CHOSEN.');
    case 'R_b'
        disp('Benchmkar case with refinement is CHOSEN.');
    otherwise
        error(['WRONG ENTRY! Please choose "e", "b", "ec", "bc", "R_e"'...
            'or "R_b" for the variable "sim_case". The process is TERMINATED!']);
end


switch sim
    case '1'
        disp('The simulation of the bubble is being shown.')
        disp(['AZ=',num2str(AZ),' and EL=',num2str(EL),'.']);
        if camera=='F'
            disp('The axes are fixed.');
        else
            disp('The axes are NOT fixed.');
        end
    case '2'
        disp('The error plots are being shown.');
        disp('AZ, EL, and the axes are OMITTED.');
    case '3'
        disp('The simulation is NOT being shown.');
        disp('AZ, EL, and the axes are OMITTED.');
    otherwise
        error(['WRONG ENTRY! Please choose "1", "2" or "3" for the'...
            ' variable "sim". The process is TERMINATED!']);
end

disp(['Time step=',num2str(dt)]);
disp(['Number of time steps=',num2str(ct)]);
if (pass_R || pass_c)
    disp(['Total time=',num2str(T)]);
end

switch tvsd
    case 't'
        disp('The CONSERVATIVE level set function is chosen.');
    case 'd'
        disp('The STANDARD level set function is chosen.');
    otherwise
        error(['WRONG ENTRY! Please choose "d" or "t" for the'...
            ' variable "tvsd". The process is TERMINATED!']);
end

switch re_method
    case 'y'
        disp('The reinitialization method is included');
        disp('The parameters:');
        disp(['Number of iteration:',num2str(iter)]);
        disp(['Pseduo-time step:',num2str(dtor)]);
    case 'n'
        disp('The reinitialization method is NOT included');
        disp('The parameters are OMITTED.');
    otherwise
        error(['WRONG ENTRY! Please choose "y" or "n" for the'...
            ' variable "method_name". The process is TERMINATED!']);
end

if Eig_Val_Check=='y'
    disp('The eigenvalues are being checked.');
else
    disp('The eigenvalues are NOT being checked.');
end

disp('Press ENTER to start the simulation');
disp('or CRTL+C to terminate it');
pause;

%% Positioing the convergence plot
fig1=figure(10);
set(0,'Units','pixels')
scnsize = get(0,'ScreenSize');
position = get(fig1,'Position');
outerpos = get(fig1,'OuterPosition');
borders = outerpos - position;
edge = -borders(1)/2;
pos1 = [edge,...
    edge,...
    scnsize(3)/2 - edge,...
    scnsize(4)/2 - edge];
set(fig1,'OuterPosition',pos1)

%% Allocation
area_e=zeros(1,length(h));
levelset_e=zeros(1,length(h));
measure_e=zeros(1,length(h));

%% Start plotting the Convergence plot
if(pass_R)
    %% Packing the input data
    input_vp=struct('h',h,'sim',sim,'dt',dt,'tvsd',tvsd,'T',T,...
        'cons',cons,'iter',iter,'dtor',dtor,...
        'eps',eps,'Eig_Val_Check',Eig_Val_Check,...
        're_method',re_method,'AZ',AZ,'EL',EL,'camera',camera,...
        'nh',nh,'r',r,'xc',xc,'yc',yc,'epsilon',epsilon,...
        'sim_case',sim_case,'ps',ps,'FS',FS);
    
    %% Calculate
    disp('REFINEMENT 0');
    [area_e,levelset_e,measure_e]=Mesh_IV_BC_Assembler(input_vp);
    
    %% Plot
    figure(10);
    h=h./2.^(0:nh-1);
    p1=loglog(h,area_e,'-*',h,...
        levelset_e,'-*',h,measure_e,...
        '--k',[min(h) max(h)],[1 1],'-k');
    set(gca,'FontSize',FS);
    set(p1,'LineWidth',2.5);
    xlabel 'h';  ylabel 'Relative error'; xlim([min(h) max(h)]);
    legend('area error','level set function error','Location',...
        'NorthWest');
    grid on; title 'The convergence';
else
    for i=1:length(h)
        %% Show the current parameters
        disp(['h=',num2str(h(i))]);
        disp(['cons=',num2str(cons)]);
        disp(['eps=',num2str(eps(i))]);
        
        %% Packing the input data
        if(pass_c) % Default convergence
            input_vp=struct('h',h(i),'sim',sim,'dt',dt,'tvsd',tvsd,'T',T,...
                'cons',cons,'iter',iter,'dtor',dtor,...
                'eps',eps(i),'Eig_Val_Check',Eig_Val_Check,...
                're_method',re_method,'AZ',AZ,'EL',EL,'camera',camera,...
                'nh',nh,'r',r,'xc',xc,'yc',yc,'epsilon',epsilon,...
                'sim_case',sim_case,'ps',ps,'FS',FS);
        else % Constant convergence rate
            T=ct(i)*dt(i); % Total time step
            disp(['Time step=',num2str(dt(i))]);
            disp(['Number of time steps=',num2str(ct(i))]);
            disp(['Total time=',num2str(T)]);
            input_vp=struct('h',h(i),'sim',sim,'dt',dt(i),'tvsd',tvsd,'T',T,...
                'cons',cons,'iter',iter,'dtor',dtor(i),...
                'eps',eps(i),'Eig_Val_Check',Eig_Val_Check,...
                're_method',re_method,'AZ',AZ,'EL',EL,'camera',camera,...
                'nh',nh,'r',r,'xc',xc,'yc',yc,'epsilon',epsilon,...
                'sim_case',sim_case,'ps',ps,'FS',FS);
        end
        
        %% Calculate
        [area_e(i),levelset_e(i),measure_e(i)]=...
            Mesh_IV_BC_Assembler(input_vp);
        
        %% Plot
        figure(10);
        p1=loglog(h(1:i),area_e(1:i),'-*',h(1:i),...
            levelset_e(1:i),'-*',h(1:i),measure_e(1:i),...
            '--k',[min(h) max(h)],[1 1],'-k');
        set(gca,'FontSize',FS);
        set(p1,'LineWidth',2.5);
        xlabel 'h';  ylabel 'Relative error'; xlim([min(h) max(h)]);
        legend('area error','level set function error',...
            'Location','NorthWest');
        grid on; title 'The convergence';
        
    end
    
end


%% Convergence Rate Calculation
if(pass_R)
    area_rate=polyfit(log10(h),log10(area_e)',1)
    levelset_rate=polyfit(log10(h),log10(levelset_e)',1)
    measure_rate=polyfit(log10(h),log10(measure_e)',1)
else
    area_rate=polyfit(log10(h),log10(area_e),1)
    levelset_rate=polyfit(log10(h),log10(levelset_e),1)
    measure_rate=polyfit(log10(h),log10(measure_e),1)
end

%% Save the result
ans1=input('Do you want to save the results? \n(y or n):','s');
if ans1=='y'
    name=input('Enter the name:','s');
    save([name,'.mat']);
    disp('The file is saved and the simulation is DONE.');
else
    disp('The experiment is DONE.');
end
