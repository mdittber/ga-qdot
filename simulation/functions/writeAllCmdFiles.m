function endIndice = writeAllCmdFiles(def_dot, dir, startIndice )
% wirtes commandfiles with all parameter combinations based on def_dot into directory dir
    
    currentdir = pwd;
    cd(dir)
    
    dots = sweep(def_dot); %perform sweep and create array of qdots with all parameters

    mat = def_dot.mat_name; %matrial
    
    endIndice = startIndice + length(dots);
    
    for i = 1:length(dots)

        contIndice = startIndice +i;
        
        CMDFILENAME = ['cmd_' int2str(contIndice) '_' mat];%create filename
        
        writeCmdFile(dots(i), CMDFILENAME);%write the cmdfiles
        
        %SAVE THE DOT
        dotname = [ 'qdot_' int2str(contIndice) '_' mat];
        eval([dotname '=dots(i);']);
        save(dotname, dotname);
   
    end
    
    cd(currentdir)
    
end