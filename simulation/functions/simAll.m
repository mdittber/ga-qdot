%********************************************************************
%CREATE CMD FILE FOR EVERY PARAMETER COMBINATION
%PERFORMS OMEN SIMULATION FOR ALL CMD FILES
%
%returns cell matrix with entries for DB
%
%creates a folder for each simulation, containing:
%Simulation Data created by OMEN
%Cmd File
%Logfile with console output of OMEN simulation
%qdot
%********************************************************************
function DBpart = simAll(def_dot)
    
    %PERFORM SWEEP
    
    dots = sweep(def_dot); %create array of qdots with all parameters
    N = length(dots);

    %DEFINITIONS
    
    mat = def_dot.mat_name; %matrial
    
    status = (-1)*ones(N,1); %status of each simulation. returned zero if sucessful
    
    cmdout = cell(N,1); %console output for each sim will be saved here
    
    simTimestamp = cell(N,1); %Timestamp for each simulation
    logTimestamp = datestr(clock,'yy-mm-dd_HHMMSS'); %Timestamp for all simulations
    
    DBpart = cell(N,3);


    %********************************************************************
    % WRITE CMD FILE AND SIMULATE 
    %********************************************************************

    t1 = tic; %measure time of all simulations

    for i = 1:N
        %Timestamp for this simulation
        simTimestamp{i} = datestr(clock,'yy-mm-dd_HHMMSSFFF');
    
        SIMDIR = sprintf('%s_%s', simTimestamp{i}, mat);
        mkdir(SIMDIR);
        cd(SIMDIR);
        
        %SAVE QDOT
        
        QDOTNAME = 'qdot';  %name of mat-file in which the current qdot is saved
        %QDOTNAME = ['qdot_' simTimestamp '.mat'];
        dot = dots(i);
        save( QDOTNAME, 'dot');
        
        
        % WRITE CMD FILE
            
        CMDFILENAME = 'cmd'; 
        % CMDFILENAME =['cmd_' simTimestamp];
        
        writeCmdFile(dots(i), CMDFILENAME); %write the cmdfiles
        
        % SIMULATE WITH OMEN
        
        t2 = tic;   %measure time of single simulation
        
        UNIXCOMMAND = ['../../../OMEN_ethz-amd64 ', CMDFILENAME]; %create command string
        [status(i), cmdout{i}] = unix( UNIXCOMMAND) ; %execute

        singleTime = toc(t2);

        %WRITE LOGFILE OF THIS SIMULATIONS

        simlogFile = 'simlog.txt';  % ['simlog_', simTimestamp,'.txt'];
        simlogfid = fopen(simlogFile, 'w');

        if  status(i) == 0  %simulation 
            fprintf(simlogfid, 'Simulation terminated normally.\n');
        else
            fprintf(simlogfid, 'Simulation FAILED.\n');
        end

        fprintf(simlogfid, 'elapsed time %f \n\nConsole output for simulation: %s \n\n' , singleTime, simTimestamp{i});
        fwrite(simlogfid, cmdout{i});
        fclose(simlogfid);
        
        %WRITE DB ENTRY
        
        DBpart(i,:)= DButils.newEntry(i, dot, simTimestamp{i});
        
        cd ..;
   
    end
    
    totalTime = toc(t1);
    

    %********************************************************************
    %WRITE LOGFILE OF ALL SIMULATIONS
    %********************************************************************
    
    LOGDIR = ['log_' logTimestamp '_' mat];
    mkdir(LOGDIR);
    cd(LOGDIR);

    LOGNAME = ['log_' logTimestamp '_' mat '.txt'];
    logfid = fopen(LOGNAME,'w');

    fprintf(logfid, 'Simulation %s %s \nTotal time: %f sec.\n\n',logTimestamp, mat, totalTime);

    %Check for failed simulations
    if( sum(status) ~= 0 )
        failed = find(status);
        fprintf(logfid, 'Attempt to simulate %i qdots. \n', N);
        fprintf(logfid, 'Simulation failed for indices %s \n\n', sprintf('%d, ',failed));

    else 
        fprintf(logfid, 'All %i simulations terminated normally! \n\n', N);
    end
    
    fprintf(logfid, 'CONSOLE OUTPUT OF EVERY SIMULATION: \n\n');
    for i =1:N
        fprintf(logfid, 'SIMULATION %s :\n\n%s \n\n-------------------- \n\n', simTimestamp{i}, cmdout{i});
    end
    
    fclose(logfid);
    
    cd ..;


end