classdef SNSPD_full < compound_element
    %SNSPD_FULL a full (single) detector design
    %   made out of an SNSPD_detector in layer 2, an SNSPD_feedline in
    %   layer 0 , a window in layer 1 and a lollipop in layer 3
    % 
    % input arguments for constructor: 4 elements: an SNSPD_detector,an
    % SNSPD_feedline,an SNSPD_lollipop, and some element for the shape of
    % the window in Al.
    % if run without argumets: SNSPD_full() : uses default
    % elements.
    %
    % ports:
    % origin : the center of the detector
    % pad : the center of contact pad
    % center : geometric cencter of the whole element
    %
    %TODO - consider turning this into a script instead of a class 
    
    methods
        function obj = SNSPD_full(detector, feedline, lollipop, window)
            %SNSPD_FULL Construct an instance of this class
            
            if nargin<1
                detector  = SNSPD_detector();
                feedline = SNSPD_feedline();
                lollipop = SNSPD_lollipop();
                
                %  window in al
                a = 10; b = 28;
                nodes = [-a -a;
                          a -a;
                          a a
                          b b;
                         -b b;
                         -a a];
                window = polygon_element(nodes);
                
            end
            
            % layers:
            L0 = layer(0,'etch Al + WSi - LW');
            L1 = layer(1, 'etch Al - LW');
            L2 = layer(2, 'etch WSi - eLine');
            L3 = layer(3,'Bosch - Mask');
            
            % define sub elements
            obj.elements.detector = detector.set_layer(L2);
            obj.elements.feedline = feedline.set_layer(L0).place('input',obj.elements.detector.ports.input - [0,10] ); % the shift is for tolerance
            obj.elements.lollipop = lollipop.set_layer(L3);
            obj.elements.window = window.set_layer(L1);
            
            % define ports
            obj.ports.pad = obj.elements.feedline.ports.pad;
            % define center
            %   find boundnding box
                    [x,y ] = boundingbox(obj.convert2pol);
            obj.ports.center = [mean(x), mean(y)];
            
        end
        
    end
end

