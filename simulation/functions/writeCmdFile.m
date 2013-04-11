function writeCmdFile(qdot, filename)
% writes the cmdfile for qdot into the current directory

    file = fopen(filename,'w');
        
    fprintf(file,'// Command file for OMEN \n \n');
            
    printVar(file, 'mat_name',qdot.mat_name, 'material_model');
    
    printVar(file, 'a0',qdot.a0, 'lattice constant');
    printVar(file, 'first_atom',qdot.first_atom, 'atom situated at [0 0 0]');
    
    
    printVar(file, 'open_system',qdot.open_system, ' ');
    printVar(file, 'tb',qdot.tb, 'tight-binding order');
    printVar(file, 'dsp3',qdot.dsp3, 'passivation energy [eV]');
    
    
    printVar(file, 'n_of_modes',qdot.n_of_modes, 'number of modes');
    printVar(file, 'max_bond_def',qdot.max_bond_def, 'maximum relative bond deformation (should only be changed if very large strain)');
    
    
    printVar(file, 'x',qdot.x, 'transport direction');
    printVar(file, 'y',qdot.y, 'direction of confinement');
    printVar(file, 'z',qdot.z, 'direction of confinement');
    
    printVar(file, 'CPU_per_vd_point',qdot.CPU_per_vd_point, '');
    
    printVar(file, 'NVD',qdot.NVD, 'nr of drain voltages Vd=Vdmin:(Vdmax-Vdmin)/(NVD-1):Vdmax');
    printVar(file, 'Vdmin',qdot.Vdmin, 'absolute minimum drain potential');
    printVar(file, 'Vdmax',qdot.Vdmax, 'absolute maximum drain potential');
    
%     printVar(file, 'default_directory',qdot.default_directory, '');

    printVar(file, 'no_mat',qdot.no_mat, 'nr of pieces that form the nanowire (channel+oxide0');
    printVar(file, 'no_channel_mat',qdot.no_channel_mat, 'nr of pieces that form the nanowire channel');
    printVar(file, 'no_oxide_mat',qdot.no_oxide_mat, 'nr of pieces that form the oxide around the wire');
    
    
    printGeometry(file,qdot);
    
    cmds = sprintf(['/* Commands */ \n\n'...
                'command(1) = Write_Layer_Matrix;\n'...
                'command(2) = Write_Hamiltonian_Matrix;\n'...
                'command(3) = CB_Closed;\n'...
                'command(4) = VB_Closed\n'...
                '//command(1) = Optial_Matrix_Element;\n']);

    fprintf(file, '%s', cmds);

    fclose(file);



end

function printVar(file, varname, value, comment)
    fprintf(file,'%s   =   %s;     // %s \n\n',varname, mat2str(value), comment);
end

function printGeometry(file, qdot)
    fprintf(file,'\n \n // Geometry \n \n');
        
    for i = 1:length(qdot.geometry);
        
        nr = int2str(i);
        nrbrack = ['(',nr,')'];
        
        
        printVar(file,['mat_type',nrbrack],qdot.geometry(i).type, 'type of material: square or circle');
        
        printVar(file,['mat_cs',nrbrack],qdot.geometry(i).cs, 'does the material determine the nanowire cross section');
        
        printVar(file,['mat_id',nrbrack],qdot.geometry(i).id, '');
        
        printVar(file,['mat_radius',nrbrack],qdot.geometry(i).radius, 'radius of circle');
        
        printVar(file,['mat_coord(',nr,',1)'],qdot.geometry(i).coord, 'type of material: square or circle');
        
    end
    
end








