function Show_Simulation(phi,mesh,time,input_vp,fun_features)
%% Show the simulation

figure(1);
h1=pdecont(mesh.p,mesh.t,phi,[0 0]);
set(h1,'LineWidth',2.5);
set(gca,'FontSize',input_vp.FS);
set(h1,'Color','b');
grid on; xlabel 'x'; ylabel 'y'; zlabel('\phi','interpreter','tex');
title(['time: ', num2str(time)]);
view(2);

if (input_vp.camera=='F')
    hold on;
    h2=pdeplot(mesh.p,mesh.e,mesh.t,'flowdata',...
        [fun_features.cx fun_features.cy]);
    set(gca,'FontSize',input_vp.FS);
    set(h2,'Color',[34 139 34]/255,'LineWidth',2.0);
    xlabel 'x'; ylabel 'y';
    hold off;
    title(['time: ', num2str(time)]);
    axis([-1 1 -1 1]);
    
end
hold off;

figure(2); h2=pdecont(mesh.p,mesh.t,phi);
set(h2,'LineWidth',2.5);
set(gca,'FontSize',input_vp.FS);
grid on; xlabel 'x'; ylabel 'y'; zlabel('\phi','interpreter','tex');
title(['time: ', num2str(time)]);
view(2);
axis([-1 1 -1 1]);


figure(3); pdesurf(mesh.p,mesh.t,phi);
hold on; pdesurf(mesh.p,mesh.t,zeros(length(phi),1));
set(gca,'FontSize',input_vp.FS);
grid on; xlabel 'x'; ylabel 'y'; zlabel('\phi','interpreter','tex');
title(['time: ', num2str(time)]); colorbar;
view(input_vp.AZ,input_vp.EL);


end