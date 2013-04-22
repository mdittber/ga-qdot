%function to generate a ZnxCd1-xSe qdot from a ZnSe structure

x=0.4;

load Layer_Matrix.dat

atom_pos_dat=Layer_Matrix(:,1:4);

indZn=find(atom_pos_dat(:,4)==2);

rand_number=rand(1,length(indZn));

indCd=find(rand_number<=(1-x));

atom_pos_dat(indZn(indCd),4)=4;

save atom_pos_dat atom_pos_dat -ascii