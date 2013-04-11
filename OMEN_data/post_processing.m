number_of_modes=1;
number_of_elec_field=1;
no_orbital=5;

Layer_Matrix=load('Layer_Matrix.dat');

NA=length(Layer_Matrix(:,1));

for IE=1:number_of_elec_field,
    
    filename=['CB_E_' num2str(IE-1) '_0.dat'];
    CB_E=load(filename);
    
    filename=['CB_V_' num2str(IE-1) '_0.dat'];
    CB_V=load(filename);
    CB_V=CB_V(:,1:2:2*number_of_modes)+1i*CB_V(:,2:2:2*number_of_modes);
    
    filename=['VB_E_' num2str(IE-1) '_0.dat'];
    VB_E=load(filename);
    
    filename=['VB_V_' num2str(IE-1) '_0.dat'];
    VB_V=load(filename);
    VB_V=VB_V(:,1:2:2*number_of_modes)+1i*VB_V(:,2:2:2*number_of_modes);
    
    psiCB2=zeros(NA,number_of_modes);
    psiVB2=zeros(NA,number_of_modes);
    for IM=1:number_of_modes,
        psiCB2(:,IM)=sum(reshape(abs(CB_V(:,IM)).^2,no_orbital,NA))';
        psiVB2(:,IM)=sum(reshape(abs(VB_V(:,IM)).^2,no_orbital,NA))';
        plot_3D_unit_cell(Layer_Matrix,psiCB2(:,IM),2*(IE-1)*number_of_modes+2*(IM-1))
        plot_3D_unit_cell(Layer_Matrix,psiVB2(:,IM),2*(IE-1)*number_of_modes+2*(IM-1)+1)
    end
    
    data(IE).CB_E=CB_E;
    data(IE).VB_E=VB_E;
    data(IE).psiCB2=psiCB2;
    data(IE).psiVB2=psiVB2;
    
end