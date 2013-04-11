%********************************************************************
%PERFORMS OMEN SIMULATION FOR ALL CMD FILES IN THE CURRENT DIRECTORY
%
%creates a folder (one level down) for each simulation, containing:
%Simulation Data created by OMEN
%Cmd File
%Logfile with console output of OMEN simulation
%********************************************************************

CMDFILE = 'cmd*';
QDOT = 'qdot*.mat'; 

%Get all cmd files from current directory
cmdfiles = dir(CMDFILE); 
qdots = dir(QDOT);

%get current dir name
[lowerPath, currentDir] = fileparts(pwd); 
cmdFileDir = currentDir;

N = length(cmdfiles);% N = number of cmd files
status = (-1)*ones(N,1); %status of each simulation. returned zero if sucessful

%log: Message for logfile of all simulations
logTimestamp = datestr(clock,'yy-mm-dd_HHMMSS');
log = sprintf( ['Logfile of Simulation ', logTimestamp, ' \n\n'] );




t1 = tic; %measure time of all simulations
for i = 1:N
    %Timestamp for this simulation
    simTimestamp = datestr(clock,'yy-mm-dd_HHMMSSFFF');
    
    
    %IMPORT QDOT FROM FILE 
    % comment this paragraph if no qdots are generated 
    
    load( eval('qdots(i).name') );
    eval('qdotname = qdots(i).name(1:end-4);'); % remove .mat from name
    eval('qdot = eval(qdotname);');     % save current dot in qdot.

    delete(qdots(i).name); %remove qdot mat file
    
    mat = qdot.mat_name;
    
    %CREATE DIRs, COPY CMDFILE 

    simDir = sprintf('sim_%s_%s', simTimestamp, mat);
    %todo: get mat out of cmdfile ('mat_name')

    oldCmdPath = [cmdFileDir '/' cmdfiles(i).name];
    NEWCMDFILE = 'cmd';     %['cmd_' simTimestamp];
    newCmdPath = [simDir '/' NEWCMDFILE];
    
    oldQdotPath = [cmdFileDir '/' qdots(i).name];
    NEWQDOTFILE = 'qdot';   %['qdot_' simTimestamp '.mat'];
    newQdotPath = [simDir '/' NEWQDOTFILE];
   
    
    cd ..;
    mkdir(simDir);
    movefile( oldCmdPath, newCmdPath ); %move cmd file to new dir
    cd(simDir);
    
    save(NEWQDOTFILE, 'qdot'); %save qdot in new dir
    
    %PERFORM SIMULATION
   
    t2 = tic;   %measure time of single simulation
     
    unixcommand = ['./', NEWCMDFILE]; %create command string
    [status(i), cmdout] = unix( unixcommand) ; %execute
     
    singleTime = toc(t2);
    
    %WRITE LOGFILE 
    
    simlogFile = 'simlog';  % ['simlog_', simTimestamp,'.txt'];
    simlogfid = fopen(simlogFile, 'w');
    
    if  status(i) == 0  %simulation 
        fprintf(simlogfid, 'Simulation SUCCESSFUL!\n');
    else
        fprintf(simlogfid, 'Simulation FAILED!\n');
    end
    
    fprintf(simlogfid, 'Console output for simulation %s \n elapsed time %f ',logTimestamp, singleTime);
    fwrite(simlogfid, cmdout);
    fclose(simlogfid);
    
    
    %return to cmdfile directory
    cd([ '../' cmdFileDir]);
    
    
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
