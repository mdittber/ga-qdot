function plot_3D_unit_cell(Matrix_Atom,V,index)

h=colormap;

V=V/max(V)*length(h);

figure(100+index)
hold on
IA=1;
while Matrix_Atom(IA,1)<1e-8,
    plot3(Matrix_Atom(IA,1),Matrix_Atom(IA,2),Matrix_Atom(IA,3),'ko','MarkerSize',8,'MarkerFaceColor',h(ceil(V(IA)),:))
    IA=IA+1;
end
xlabel('x')
ylabel('y')
zlabel('z')

figure(200+index)
hold on
for IA=1:length(Matrix_Atom(:,1)),
    if Matrix_Atom(IA,3)<1e-8,
        plot3(Matrix_Atom(IA,1),Matrix_Atom(IA,2),Matrix_Atom(IA,3),'ko','MarkerSize',8,'MarkerFaceColor',h(ceil(V(IA)),:))
    end
end
xlabel('x')
ylabel('y')
zlabel('z')