function DBpart = simAll(def_dot)

% CREATE OMEN CMD FILE FOR EVERY PARAMETER COMBINATION
% PERFORMS OMEN SIMULATION FOR ALL CMD FILES
%
% returns cell matrix with entries for DB
%
% creates a folder for each simulation, containing:
% Simulation Data created by OMEN
% Cmd File
% Logfile with console output of OMEN simulation
% qdot object containing the parameters
%********************************************************************
	
        
% PERFORM SWEEP
%********************************************************************
		    
    dots = sweep(def_dot); %create array of qdots with all parameters
    N = length(dots);

    
% DEFINITIONS
%********************************************************************
		
    mat = def_dot.mat_name; %matrial
    
    status = (-1)*ones(N,1); %status of each simulation. returned zero if sucessful
    
    consoleOconsoleOutut = cell(N,1); %console output for each sim will be saved here
    
    simTimestamp = cell(N,1); %Timestamp for each simulation
    logTimestamp = datestr(clock,'yy-mm-dd_HHMMSS'); %Timestamp for all simulations
    
    DBpart = cell(N,3);


% WRITE CMD FILE AND SIMULATE 
%********************************************************************

    t1 = tic; %measure time of all simulations

    for i = 1:N
		
        %timestamp for this simulation
        simTimestamp{i} = datestr(clock,'yy-mm-dd_HHMMSSFFF');
	
    % CREATE AND CHANGE DIR
		
        SIMDIR = sprintf('%s_%s', simTimestamp{i}, mat);
        mkdir(SIMDIR);
        cd(SIMDIR);
        
	% SAVE QDOT
        
        QDOTNAME = 'qdotObj';  %name of mat-file in which the current qdot is saved
        	%QDOTNAME = ['qdot_' simTimestamp '.mat'];
        qdotObj = dots(i);
        save( QDOTNAME, 'qdotObj');
        
        
	% WRITE CMD FILE
            
        CMDFILENAME = 'qdot_cmd'; 
        % CMDFILENAME =['cmd_' simTimestamp];
        
        writeCmdFile(dots(i), CMDFILENAME); %write the cmdfiles
			
	% SIMULATE WITH OMEN
        
        t2 = tic;   %measure time of single simulation
        
        UNIXCOMMAND = ['../../../OMEN_ethz-amd64 ', CMDFILENAME]; %create command string
        [status(i), consoleOut{i}] = unix( UNIXCOMMAND) ; %execute

        singleTime = toc(t2);
		
		simSuccess = checkSuccess( status(i), consolOut{i} )
		
	%WRITE LOGFILE OF THIS SIMULATIONS

        simlogFile = 'simlog.txt';  % ['simlog_', simTimestamp,'.txt'];
        simlogfid = fopen(simlogFile, 'w');

        if  simSuccess ==1  %simulation successful 
            fprintf(simlogfid, 'Simulation successful.\n');
        else
            fprintf(simlogfid, 'Simulation FAILED.\n');
        end

        fprintf(simlogfid, 'elapsed time %f \n\nConsole output for simulation: %s \n\n' , singleTime, simTimestamp{i});
        fwrite(simlogfid, consoleOut{i});
        fclose(simlogfid);
        
	%WRITE DB ENTRY
        
		if simSuccess == 1
			DBpart(i,:)= DButils.newEntry(i, dot, simTimestamp{i});
		end
        
		cd ..;
   
    end
    
    totalTime = toc(t1);
    

    
% WRITE LOGFILE OF ALL SIMULATIONS
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
        fprintf(logfid, 'SIMULATION %s :\n\n%s \n\n-------------------- \n\n', simTimestamp{i}, consoleOut{i});
    end
    
    fclose(logfid);
    
    cd ..;


end


function bool = checkSuccess(status, consoleOut)

% check if the OMEN simulation was successful, returns 1 or 0
% consoleOut: console output of OMEN
% status: status returned by unix function


	% TODO	
	% exist('filename.m', 'file') returns 0 if not existing
		
	if status == 0 
		bool = 1;
	else
		bool = 0; 
end
