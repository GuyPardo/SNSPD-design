classdef SNSPD_lollipop < compound_element
    % lollipop shape for bosch layer in SNSPD
    % composed of a circular arc, a neck which is a short coplanar line and
    % then a long coplanar adiabatic opening, and a "stop" (a small
    % rectangle) at the end for easy breaking.
    %
    % ctor input arguments:
    % all optional parameters (use name-value paor syntax or input a struct)
%                 diameter - diameter of device  (default value: 2497)
%                 cut_w - width of cut around the lollipop shape (defualt: 200) 
%                 neck_w - (default value: 400)
%                 neck_l -  (default: 500);
%                 adiabatic_l - (default 2970 - gives a total length of 4700 from center to end);
%                 final_w - (default 900);
%                 stop_l -  (default=450); 
%
% ports: origin - center of the circle
    
   
    methods
        function obj = SNSPD_lollipop(varargin)  
            % input parsing
                % default values:
                diameter_def = 2497; %diameter of desired lolipop
                cut_w_def = 200; 
                neck_w_def = 400;
                neck_l_def = 500;
                adiabatic_l_def = 2970;
                final_w_def = 900;
                stop_l_def = final_w_def/2;
            
            p = inputParser;
            addParameter(p, 'diameter', diameter_def );
            addParameter(p, 'cut_w', cut_w_def );
            addParameter(p, 'neck_w', neck_w_def );
            addParameter(p, 'neck_l', neck_l_def );
            addParameter(p, 'adiabatic_l', adiabatic_l_def );
            addParameter(p, 'final_w', final_w_def );
            addParameter(p, 'stop_l', stop_l_def );
            parse(p, varargin{:})

            %read values    
            diameter = p.Results.diameter;
            cut_w = p.Results.cut_w; 
            neck_w = p.Results.neck_w;
            neck_l = p.Results.neck_l;
            adiabatic_l = p.Results.adiabatic_l;
            final_w = p.Results.final_w;
            stop_l = p.Results.stop_l; 

            
            
            % circular part
            Rin = 0.5*diameter;
            R_arc  = Rin + cut_w/2;
            opening_angle = 2*asin(neck_w/Rin/2);

            circ = arc(R_arc, 2*pi-opening_angle, cut_w).rotate(pi/2+opening_angle/2);

            % neck
            neck = coplanar_line(neck_l,neck_w, cut_w).rotate(pi/2);

            % adiabatic
            adiabatic = adiabatic_opening(adiabatic_l, neck_w, cut_w, final_w, cut_w).rotate(pi/2);
            
            % stop
            stop = rect(stop_l,cut_w);
            
            obj.elements.circ = circ;
            obj.elements.neck = neck.place('input',(obj.elements.circ.ports.input_inner+obj.elements.circ.ports.output_inner)/2 );
            obj.elements.adiabatic = adiabatic.place('input', obj.elements.neck.ports.output);
            obj.elements.stop = stop.place('bottom', obj.elements.adiabatic.ports.output);
        end
        
    end
end

