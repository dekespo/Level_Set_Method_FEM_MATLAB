function [measure_e]=Area_measurement_error(x,y,xc,yc,r,cx,cy,p,t,input_vp)
%% Area measurement (EXTRA),

pass_e=strcmp(input_vp.sim_case,'e') || strcmp(input_vp.sim_case,'ec');

N=input_vp.T/input_vp.dt;
%% Allocation
time=zeros(N+1,1);
diff=zeros(N+1,1);

%% Start Simulation
time(1)=0;
for i=1:N
    
    %% At which time step
    time(i+1)=time(i)+input_vp.dt;
    
    %% Analytical Solution
    if (pass_e) % Experiment case
        if(input_vp.tvsd=='d')
            anal=distance(p(1,:),p(2,:),r,xc+time(i+1)*cx,yc+time(i+1)*cy)';
        elseif(input_vp.tvsd=='t')
            anal=tanh(distance(p(1,:),p(2,:),r,xc+time(i+1)*cx,yc+time(i+1)*...
                cy)/(input_vp.epsilon*input_vp.h))';
        end
    else % Benchmark case
        [~,xc,yc]=Follow_V(x,y,xc,yc,r,cx,cy,input_vp.dt);
        if(input_vp.tvsd=='d')
            anal=distance(p(1,:),p(2,:),r,xc,yc)';
        elseif(input_vp.tvsd=='t')
            anal=tanh(distance(p(1,:),p(2,:),r,xc,yc)...
                /(input_vp.epsilon*input_vp.h))';
        end
    end
    
    
    %% Numerical Solution
    %tricontour.m , a ready file from 2006 for calculating area
    Con_nume=tricontour(p',t(1:3,:)',anal,[0 0]);
    
    nume=polyarea(Con_nume(1,2:end),Con_nume(2,2:end));
    diff(i+1)=abs(pi*r*r-nume);
    
    %     figure(99)
    %     plot(time(1:i+1),diff(1:i+1)/(pi*r*r));
    %     xlabel 'time'; ylabel 'Area Measurement error';
    
    
    
end

%% Write (or return) the result values
measure_e=mean(diff)/(pi*r*r); %normalised error

end