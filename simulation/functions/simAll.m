%********************************************************************
%CREATE CMD FILE FOR EVERY PARAMETER COMBINATION
%PERFORMS OMEN SIMULATION FOR ALL CMD FILES
%
%creates a folder for each simulation, containing:
%Simulation Data created by OMEN
%Cmd File
%Logfile with console output of OMEN simulation
%********************************************************************
function simAll(def_dot)

    mat = def_dot.mat_name; %matrial
    
    
    %PERFORM SWEEP
    
    dots = sweep(def_dot); %create array of qdots with all parameters
    N = length(dots);

    %WRITE CMD FILE AND SIMULATE EVERY DOT
    
    status = (-1)*ones(N,1); %status of each simulation. returned zero if sucessful
   
    %log: Message for logfile of all simulations
    logTimestamp = datestr(clock,'yy-mm-dd_HHMMSS');
    log = sprintf( ['Logfile of Simulation ', logTimestamp, ' \n\n'] );

    
    t1 = tic; %measure time of all simulations

    for i = 1:N
        %Timestamp for this simulation
        simTimestamp = datestr(clock,'yy-mm-dd_HHMMSSFFF');
    
        simDir = sprintf('%s_%s', simTimestamp, mat);
        mkdir(simDir);
        cd(simDir);
        
        %SAVE QDOT
        
        QDOTNAME = 'qdot';  %name of mat-file in which the current qdot is saved
        %QDOTNAME = ['qdot_' simTimestamp '.mat'];
        qdot = dots(i);
        save( QDOTNAME, 'qdot');
        
        
        %WRITE CMD FILE
        
        CMDFILENAME = 'cmd'; 
        % CMDFILENAME =['cmd_' simTimestamp];
        
        writeCmdFile(dots(i), CMDFILENAME); %write the cmdfiles
        
        %PERFORM SIMULATION
        
        t2 = tic;   %measure time of single simulation
        
        UNIXCOMMAND = ['../../../OMEN_ethz-amd64 ', CMDFILENAME] %create command string
        [status(i), cmdout] = unix( UNIXCOMMAND) ; %execute

        singleTime = toc(t2);

        %WRITE LOGFILE FOR THIS SIMULATION

        simlogFile = 'simlog.txt';  % ['simlog_', simTimestamp,'.txt'];
        simlogfid = fopen(simlogFile, 'w');

        if  status(i) == 0  %simulation 
            fprintf(simlogfid, 'Simulation SUCCESSFUL!\n');
        else
            fprintf(simlogfid, 'Simulation FAILED!\n');
        end

        fprintf(simlogfid, 'elapsed time %f \n Console output for simulation %s \n\n' , singleTime, logTimestamp);
        fwrite(simlogfid, cmdout);
        fclose(simlogfid);
        cd ..;
   
    end
    
    totalTime = toc(t1);



    %WRITE LOGFILE OF ALL SIMULATIONS

    logfid = fopen(['log_',logTimestamp,'.txt'],'w');

    fprintf(logfid, 'elapsed time %f sec.\n',totalTime);

    %Check for failed simulations
    if( sum(status) ~= 0 )
        failed = find(status);
        fprintf(logfid, 'Attempt to simulate %i qdots. \n', N);
        fprintf(logfid, 'Simulation failed for indices %s', sprintf('%d, ',failed));

    else 
        fprintf(logfid, 'All %i simulations terminated successfully!', N);
    end

    fclose(logfid);


end