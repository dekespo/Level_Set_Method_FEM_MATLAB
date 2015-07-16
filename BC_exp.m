function [fixed,free,g]=BC_exp(x,y,cx,cy,np,r,xc,yc,input_vp)

%% First Experiment
new_points=find(or((x==-ones(1,length(x))),...
    (y==-ones(1,length(y))))==1); % Choosing boundary points
fixed=new_points; %boundary nodes
free=setdiff(1:np,fixed); %interior nodes

switch input_vp.tvsd
    
    case 't' %Conersvative level set function
        
        g=@(x,y,t) ones(1,length(x)); %Value for the boundary conditions
        
    case 'd' %Standard level set function
        
        g=@(x,y,t) distance(x,y,r,xc+cx(1)*t,yc+cy(1)*t);
        
    otherwise
        
        error(['WRONG ENTRY! Please choose "d" or "t" for the'...
            ' variable "tvsd". The process is TERMINATED!']);
        
end


%% Second Experiment
% new_points=find(or((abs(x)==ones(1,length(x))),(abs(y)==ones(1,length(y))))==1);
% fixed=new_points; %boundary nodes
% % fixed=[];
% free=setdiff(1:np,fixed); %interior nodes
%
% switch input_vp.tvsd
%
%     case 't' %Conersvative level set function
%
%         g=@(x,y,t) ones(1,length(x)); %Value for the boundary conditions
%
%     case 'd' %Standard level set function
%
%         %         vx=@(x,y) -sin(pi*0.5*y/max(y));
%         % vy=@(x,y) sin(pi*0.5*x/max(x));
%         a=max(y); b=max(x);
%         g=@(x,y,t) distance(x,y,r,xc-sin(pi*0.5*yc/a)*0.1*t,yc...
%             +sin(pi*0.5*xc/b)*0.1*t);
%
%     otherwise
%
%         error(['WRONG ENTRY! Please choose "d" or "t" for the'...
%             ' variable "tvsd". The process is TERMINATED!']);
%
% end



end