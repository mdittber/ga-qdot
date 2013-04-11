/*********************************************************************************************************************************
Definition of a wire structure:

1) the order of the parameters must not be changed
2) the points in the structure mat_coord(i,j) and ox_coord(i,j) must follow the order described below
3) comments must remain on one line or start again with //

Commands:

CB_Bandstructure	= conduction bandstructure of contacts
VB_Bandstructure	= valence bandstructure of contacts
CB_Transmission_PWF	= conduction band transmission with PARDISO
VB_Transmission_PWF	= valence band transmission with PARDISO
CB_Transmission_UWF	= conduction band transmission with UMFPACK
VB_Transmission_UWF	= valence band transmission with UMFPACK
CB_Transmission_SWF	= conduction band transmission with SuperLU_DIST
VB_Transmission_SWF	= valence band transmission with SuperLU_DIST
CB_Transmission_MWF	= conduction band transmission with MUMPS
VB_Transmission_MWF	= valence band transmission with MUMPS
CB_Transmission_RGF	= conduction band transmission with recursive GF
VB_Transmission_RGF	= valence band transmission with recursive GF
EL_SC_PWF		= self-consistent electron simulation with PARDISO
HO_SC_PWF		= self-consistent hole simulation with PARDISO
EL_SC_UWF		= self-consistent electron simulation with UMFPACK
HO_SC_UWF		= self-consistent hole simulation with UMFPACK
EL_SC_SWF		= self-consistent electron simulation with SuperLU_DIST
HO_SC_SWF		= self-consistent hole simulation SuperLU_DIST
EL_SC_MWF		= self-consistent electron simulation with MUMPS
HO_SC_MWF		= self-consistent hole simulation MUMPS
EL_SC_RGF		= self-consistent electron simulation with recursive GF
HO_SC_RGF		= self-consistent hole simulation with recursive GF
Write_Layer_Matrix      = write file with atom positions + connections
Write_Grid_Matrix       = write file with grid points + file with index of atom position

*********************************************************************************************************************************/
/*Parameters*/

mat_name            	= ZnSe_CdSe;             	//Material (Si, GaAs, or Ge)
a0                      = 0.582;                	//lattice constant
mat_id			= 1;
first_atom              = anion;               		//atom situated at [0 0 0]

NDim			= 0;				//number of active dimensions in the device

tb			= 10;                   	//tight-binding order

max_bond_def		= 0.1;         			//maximum relative bond deformation (should only be changed if very large strain)

x                       = [1 0 0];			//transport direction
y                       = [0 1 0];			//direction of confinement
z     			= [0 0 1];              	//direction of confinement

//directory		= 

/*********************************************************************************************************************************/
/*Commands*/

command(1)		= Bulk_Bandstructure;
