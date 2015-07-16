function [err_area,err_level]=Error_calculation...
    (input_vp,mesh,fun_features,phi,time,plot)
% Measuring area for the given time step

%% Level set function
switch input_vp.tvsd
    
    case 'd' %Standard level set function
        
        % Analytical Solution
        anal=distance(mesh.p(1,:),mesh.p(2,:),fun_features.r,...
            fun_features.xc,...
            fun_features.yc)';
        
    case 't' % Conservative level set function
        
        % Analytical Solution
        anal=tanh(distance(mesh.p(1,:),mesh.p(2,:),fun_features.r,...
            fun_features.xc,...
            fun_features.yc)...
            /(fun_features.epsilon*input_vp.h))';
        
    otherwise
        
        error(['WRONG ENTRY! Please choose "d" or "t" for the'...
            ' variable "tvsd". The process is TERMINATED!']);
        
end

%% Plot the result
if plot=='y'
    figure(1); hold on;
    h1=pdeplot(mesh.p,[],mesh.t,'xydata',anal,'xystyle','off',...
        'contour','on','colormap',[1 0 0],'colorbar','off',...
        'levels',[0 0]); title(['time: ',num2str(time)]);
    set(h1,'LineWidth',2.5);
end

%% Numerical Solution
% tricontour.m , a ready file from 2006 for calculating area
Con_nume=tricontour(mesh.p',mesh.t(1:3,:)',phi,[0 0]);


%% Calculate the error in the area and mass error
% ana=polyarea(Con_anal(1,2:end),Con_anal(2,2:end));
if isempty(Con_nume)
    num=0;
else
    num=polyarea(Con_nume(1,2:end),Con_nume(2,2:end));
end


%% Errors

err_level=norm(phi-anal)/norm(anal); %normalised error (vector)
err_area=abs(num-fun_features.r^2*pi)/(fun_features.r^2*pi); %normalised
%error


end