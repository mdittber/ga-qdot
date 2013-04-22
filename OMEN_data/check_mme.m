no_orbital=5;

load H.dat
load Layer_Matrix.dat
load CB_V_0.dat
load VB_V_0.dat

n_of_modes=length(CB_V_0(1,:))/2;
CB_V=CB_V_0(:,1:2:2*n_of_modes)+1i*CB_V_0(:,2:2:2*n_of_modes);
VB_V=VB_V_0(:,1:2:2*n_of_modes)+1i*VB_V_0(:,2:2:2*n_of_modes);

H=sparse(H(:,1),H(:,2),H(:,3)+1i*H(:,4),max(H(:,1)),max(H(:,2)));
msize=length(H(:,1));

Rx=Layer_Matrix(:,1);
Rx=reshape(ones(no_orbital,1)*Rx',msize,1)*ones(1,n_of_modes);
Ry=Layer_Matrix(:,2);
Ry=reshape(ones(no_orbital,1)*Ry',msize,1)*ones(1,n_of_modes);
Rz=Layer_Matrix(:,3);
Rz=reshape(ones(no_orbital,1)*Rz',msize,1)*ones(1,n_of_modes);

Px=abs((CB_V.*Rx)'*H*VB_V-CB_V'*H*(VB_V.*Rx)).^2;
Py=abs((CB_V.*Ry)'*H*VB_V-CB_V'*H*(VB_V.*Ry)).^2;
Pz=abs((CB_V.*Rz)'*H*VB_V-CB_V'*H*(VB_V.*Rz)).^2;