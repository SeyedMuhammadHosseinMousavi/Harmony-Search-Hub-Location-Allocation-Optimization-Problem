function PlotSol(sol,model)
N=model.N;
X=model.X;
Y=model.Y;
x=sol.x;
h=sol.h;
xii=diag(x)';
Hubs=find(xii==1);
nHubs = numel(Hubs);
Clients=find(xii==0);

Colors = hsv(nHubs)*0.85;
for i=1:N
ColorIndex = find(Hubs==h(i));
Color = Colors(ColorIndex,:); 
plot([X(i) X(h(i))],[Y(i) Y(h(i))],'y','LineWidth',2,'Color',Color);
hold on;
end
plot(X(Hubs),Y(Hubs),'r^',...
'MarkerFaceColor','#77AC30',...
'MarkerSize',17);
plot(X(Clients),Y(Clients),'bp',...
'MarkerFaceColor','g',...
'MarkerSize',12);
    hold on;
hold off;
axis equal;
end
