classdef DButils 
    properties (Constant) %define structure of DB for reference...
        ROWS = 3;
    end
    
    methods(Static)
        
        function newDB = add(DB,DBpart)
            newDB = [DB;DBpart];
        end
        
        function newDB = delete(DB, index)
        end
        
        function index = get(DB, row, value)
        end
        
        function index = getRange(DB, row, from, to)
        end
            
        function entry = getEntry(DB, index)
        end
        
        function partDB = getEntries(DB, indices)
        end
        
        function new = newEntry(index, dot, timestamp)
    
            new = cell(1,3);
            new{1,1} = index;
            new{1,2} = timestamp;
            new{1,3} = dot.mat_name;

        end
        
    end
    
end