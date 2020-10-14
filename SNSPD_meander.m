classdef SNSPD_meander < compound_element
    % written by Guy 2020_09_30
    % a tight square (approximately) meander 
    %
    % input arguments for ctor:
    %
    % trace_w - width of metal
    % gap_w - width of gaps 
    % segment_l  - length of the line segments that make the meander
    % boundaries (optional) - a 2 vector indicating the coundariy
    % conditions. e.g [1,0] for close-open. default value - [0,0]
    %
    % ports:
    % input
    % output
    % origin (center of meander)
    properties
        trace_w
        gap_w
        length
        boundaries
    end
    
    methods
        function obj = SNSPD_meander(trace_w, gap_w, segment_l, boundaries )
            
            if nargin < 4
                boundaries = [0,0];
            end
            obj.trace_w = trace_w;
            obj.gap_w = gap_w;
            obj.boundaries = boundaries;
                        
            distance = trace_w + gap_w;
            params.trace_w = trace_w; params.gap_w = gap_w; params.segment_l = segment_l; params.distance = distance; 

            N = round((segment_l - trace_w)/(trace_w + gap_w)) + 2;
            obj.elements.meander = coplanar_meander(N, params);
            obj.elements.in_cap = coplanar_line(gap_w/2, trace_w, gap_w,[boundaries(1),0]).place('output', obj.elements.meander.ports.input);
            obj.elements.out_cap = coplanar_line(gap_w/2, trace_w, gap_w, [0,boundaries(2)]).place('input', obj.elements.meander.ports.output);
            
            obj.length = obj.elements.meander.length + obj.elements.in_cap.length + obj.elements.out_cap.length;
            
            
            %ports
            
            obj.ports.input = obj.elements.in_cap.ports.input;
            obj.ports.output = obj.elements.out_cap.ports.output;
            
        end

    end
end

