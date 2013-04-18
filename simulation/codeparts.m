%variante 1: alle eigenschaften, enthaelt qdot objekt

qdotDB = cell(0,3)

timestamp
user
qdotobj

%variante 1b: array von qdots, zusaetzliche eigenschaften wie timestamp in
%die klasse qdot aufnehmen.

%Variante 2: nur ausgewaelte,relevante eigenschaften

qdotDB = cell(0,15);

timestamp
user

material
lattice_type
a0
% first_atom
% open_system
tb
dsp3
n_of_modes
% max_bond_def
% x
% y
% z
% CPU_per_vd_point
NVD
Vdmin
Vdmax
% directory
% no_mat
% no_channel_mat
% no_oxide_mat


% as array:
mat_type(i)
% mat_cs(i)
mat_id(i)
mat_radius(i)
mat_choord(i,1)