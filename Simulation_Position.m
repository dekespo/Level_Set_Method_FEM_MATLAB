function Simulation_Position(input,mesh,U,fun_features)
% Prepositioning the plots

switch input.sim
    
    case '1' %Show the simulation
        
        %% Initial Plots
        time=0;
        Show_Simulation(U,mesh,time,input,fun_features);
        
        %% Positioning the figures
        fig1=figure(1);fig2=figure(2);fig3=figure(3);
        set(0,'Units','pixels');
        scnsize = get(0,'ScreenSize');
        position = get(fig1,'Position');
        outerpos = get(fig1,'OuterPosition');
        borders = outerpos - position;
        edge = -borders(1)/2;
        pos1 = [edge,...
            scnsize(4)/2 - edge,...
            scnsize(3)/2 - edge,...
            scnsize(4)/2 - edge];
        pos2 = [scnsize(3)/2 + edge,...
            scnsize(4)/2 - edge,...
            scnsize(3)/2 - edge,...
            scnsize(4)/2 - edge];
        pos3 = [edge,...
            edge,...
            scnsize(3)/2 - edge,...
            scnsize(4)/2 - edge];
        
        set(fig1,'OuterPosition',pos1)
        set(fig2,'OuterPosition',pos2)
        set(fig3,'OuterPosition',pos3)
        
    case '2' %Show the plot results
        
        %% Positioning the figures
        fig1=figure(1);fig2=figure(2);
        set(0,'Units','pixels')
        scnsize = get(0,'ScreenSize');
        position = get(fig1,'Position');
        outerpos = get(fig1,'OuterPosition');
        borders = outerpos - position;
        edge = -borders(1)/2;
        pos1 = [edge,...
            scnsize(4)/2 - edge,...
            scnsize(3)/2 - edge,...
            scnsize(4)/2 - edge];
        pos2 = [scnsize(3)/2 + edge,...
            scnsize(4)/2 - edge,...
            scnsize(3)/2 - edge,...
            scnsize(4)/2 - edge];
        
        set(fig1,'OuterPosition',pos1)
        set(fig2,'OuterPosition',pos2)
        
    case '3'
        % Just continue, the fastest method
        
        
end

end