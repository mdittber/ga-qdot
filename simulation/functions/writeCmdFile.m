function writeCmdFile(qdot, filename)
% writes the cmdfile for qdot into the current directory

    file = fopen(filename,'w');
    
    %str allocate enough mem
    
    str = sprintf('// Command file for OMEN \n \n');
    
    str = [str, printVar('mat_name',qdot.mat_name, 'material_model')];
    
    str = [str, printVar('a0',qdot.a0, 'lattice constant')];
    str = [str, printVar('first_atom',qdot.first_atom, 'atom situated at [0 0 0]')];
    
    
    str = [str, printVar('open_system',qdot.open_system, ' ')];
    str = [str, printVar('tb',qdot.tb, 'tight-binding order')];
    str = [str, printVar('dsp3',qdot.dsp3, 'passivation energy [eV]')];
    
    
    str = [str, printVar('n_of_modes',qdot.n_of_modes, 'number of modes')];
    str = [str, printVar('max_bond_def',qdot.max_bond_def, 'maximum relative bond deformation (should only be changed if very large strain)')];
    
    
    str = [str, printVar('x',qdot.x, 'transport direction')];
    str = [str, printVar('y',qdot.y, 'direction of confinement')];
    str = [str, printVar('z',qdot.z, 'direction of confinement')];
    
    str = [str, printVar('CPU_per_vd_point',qdot.CPU_per_vd_point, '')];
    
    str = [str, printVar('NVD',qdot.NVD, 'nr of drain voltages Vd=Vdmin:(Vdmax-Vdmin)/(NVD-1):Vdmax')];
    str = [str, printVar('Vdmin',qdot.Vdmin, 'absolute minimum drain potential')];
    str = [str, printVar('Vdmax',qdot.Vdmax, 'absolute maximum drain potential')];
    
%     str = [str, printVar('default_directory',qdot.default_directory, '')];

    str = [str, printVar('no_mat',qdot.no_mat, 'nr of pieces that form the nanowire (channel+oxide0')];
    str = [str, printVar('no_channel_mat',qdot.no_channel_mat, 'nr of pieces that form the nanowire channel')];
    str = [str, printVar('no_oxide_mat',qdot.no_oxide_mat, 'nr of pieces that form the oxide around the wire')];
    
    
    str = [str, printGeometry(qdot)];
    
    cmds = sprintf(['/* Commands */ \n\n'...
                'command(1) = Write_Layer_Matrix;\n'...
                'command(2) = Write_Hamiltonian_Matrix;\n'...
                'command(3) = CB_Closed;\n'...
                'command(4) = VB_Closed\n'...
                '//command(1) = Optial_Matrix_Element;\n']);
    
    str = [str, cmds];
    
    
    fwrite(file, str);
    fclose(file);



end



function str =  printVar(varname, value, comment)
    str = sprintf('%s   =   %s;     // %s \n\n',varname, mat2str(value), comment);
end


function str = printGeometry(qdot)
    str = sprintf('\n \n // Geometry \n \n');
        
    for i = 1:length(qdot.geometry);
        
        nr = int2str(i);
        nrbrack = ['(',nr,')'];
        
        
        str = [str, printVar(['mat_type',nrbrack],qdot.geometry(i).type, 'type of material: square or circle')];
        
        str = [str, printVar(['mat_cs',nrbrack],qdot.geometry(i).cs, 'does the material determine the nanowire cross section')];
        
        str = [str, printVar(['mat_id',nrbrack],qdot.geometry(i).id, '')];
        
        str = [str, printVar(['mat_radius',nrbrack],qdot.geometry(i).radius, 'radius of circle')];
        
        str = [str, printVar(['mat_coord(',nr,',1)'],qdot.geometry(i).coord, 'type of material: square or circle')];
        
        str = [str, sprintf('\n')];
    end
    
end








