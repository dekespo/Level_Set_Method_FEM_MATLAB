function [fixed,free,g,xc,yc]=BC_bench(x,y,np,xc,yc,cx,cy,input_vp)
new_points=find(or((abs(x)==ones(1,length(x))),...
    (abs(y)==ones(1,length(y))))==1); % Choosing boundary points
% new_points=[];
fixed=new_points; %boundary nodes
free=setdiff(1:np,fixed); %interior nodes
switch input_vp.tvsd
    
    case 't' %Conersvative level set function
        
        g=@(x,y,t) ones(1,length(x)); %Value for the boundary conditions
        
    case 'd' %Standard level set function
        
        [g,xc,yc]=Follow_V(x,y,input_vp.xc,...
            input_vp.yc,input_vp.r,cx,cy,0);
        
    otherwise
        
        error(['WRONG ENTRY! Please choose "d" or "t" for the'...
            ' variable "tvsd". The process is TERMINATED!']);
end
end