classdef qdot
    properties
        mat_name
        
        a0
        first_atom
        open_system
        tb
        dsp3
        
        n_of_modes
        
        max_bond_def
        
        x
        y
        z
        
        CPU_per_vd_point
        
        NVD
        Vdmin
        Vdmax
        
        directory
        
        no_mat
        no_channel_mat
        no_oxide_mat
        
        geometry
    end
    
    
    methods
        
%       Constructor
        function obj = qdot()
        end
        
        %return selected parameters in a struct
        function params = getSelectedParam(obj)
            params = struct(...
                'mat_name', obj.mat_name,...
                'a0', obj.a0 ...
                );
            
            for i = 1: obj.no_mat
                
                params.Id(i) = obj.geometry(i).id;
                params.Radius(i) = obj.geometry(i).radius;
              
            end
        end
        
        %return all parameters in a struct
        function getAllParam()
            
        end

    end
    
    
% only path and filenames or load only when used    
%     properties
%         layer_matrix
%         CB_V
%         CB_E
%         VB_V
%         VB_E
%     end
    
end