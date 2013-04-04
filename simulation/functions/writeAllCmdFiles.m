function writeAllCmdFiles(def_dot, dir)
% wirtes commandfiles with all parameter combinations based on def_dot into directory dir
    
    currentdir = pwd;
    cd(dir)
    
    dots = sweep(def_dot); %perform sweep and create array of qdots with all parameters

    mat = def_dot.mat_name;

    for i = 1:length(dots)
        filename = ['cmd_', mat, '_', int2str(i)];%create filename
        
        writeCmdFile(dots(i), filename);%write the cmdfiles
    end
    
    cd(currentdir)
    
end