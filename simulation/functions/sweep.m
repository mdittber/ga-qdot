function dots = sweep(def_dot)
	
	% Takes a default qdot object with normal parameters 
	% and sweep parameters entered in the form [min,max,steps].
	% returns array of qdots with all parameter combinations
	% supportes sweep parameters: radius(1), radius(2), NVD
	%********************************************************************


    r1 = paramSweep( def_dot.geometry(1).radius );
    r2 = paramSweep( def_dot.geometry(2).radius );
    nvd = paramSweep( def_dot.NVD );


    p1 = lock(r1,r2);
    p2 = nvd;
    
	% Create Permutation Matrix with all parameter combinations
    
	psize = size(p1) + size(p2);
    permMatrix = zeros( psize(1), length(p1) * length(p2) );
    
	% Assign values to the permutation matrix 
    
	l = 1;
    for i = 1:length(p1)
        for k = 1:length(p2)
        permMatrix(:,l) = [ p1(:,i); p2(:,k)];
        l=l+1;
        end
    end
    
    [~, N] = size(permMatrix); %Number of permutations
   
    dots( N ) = qdot; %initialize N qdots
    
	% Assign Values to the new dots
    
	for i = 1:N
        
        dots(i) = def_dot;
        
        dots(i).geometry(1).radius = permMatrix(1,i);
        dots(i).geometry(2).radius = permMatrix(2,i);
        dots(i).NVD = permMatrix(3,i);

    end
end


function p = paramSweep(a)
% create all parameter values using linspace
    if(length(a) == 3)
        p = linspace(a(1),a(2),a(3));
    elseif(length(a) ==1)
%         do not use linspace if only single value
        p=a;
    else
%         only acceptable input: scalar or vector of length 3
        warning('radius1: incorrect values');
        p=a(1);
    end
end


function p12 = lock(a1,a2)
% lock two parameters: they will not be permutated later
    if length(a1) ~= length(a2)
        if length(a1) == 1
            a1 = a1 * ones(1,length(a2));
        elseif length(a2) ==1
            a2 = a2 * ones(1,length(a1));
        else
            warning(['dimensions of lock parameters do not match. \n' ...
                            'they will be reset to their first value']);
            a1 = a1(1);
            a2 = a2(1);
        end
    end
    p12 = [a1;a2];
end