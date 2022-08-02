classdef rdk < handle
    properties
        nDots
        direction
        speed
        centre
        coherence
        dotX
        dotY
        radius
        lifetime
        age
        itemApertureSize
        colour
        dotSize
    end
    
    methods
        function obj = rdk(varargin)
            
            % Defaults
            obj.colour = [255 255 255];
            obj.coherence = 100;
            obj.direction = 90;
            obj.speed = 3;
            obj.dotSize = 3;
            obj.centre = [0;0];
            obj.itemApertureSize = 3;
            obj.lifetime = 20;
            obj.nDots = 50;
            
            args = varargin;
            nargs = length(args);
            i = 1;
            while i <= nargs
                if ischar(args{i})
                    switch args{i}
                        case 'display', display = args{i+1}; i = i + 2;
                        case 'dotSize', obj.dotSize = args{i+1}; i = i + 2;
                        case 'colour', obj.colour = args{i+1}; i = i + 2;
                        case 'nDots', obj.nDots = args{i+1} ;  i = i + 2 ;
                        case 'coherence', obj.coherence = args{i+1} ; i = i + 2 ;
                        case 'direction', direction = args{i+1} ; i = i + 2 ;
                        case  'speed', obj.speed = args{i+1}; i = i + 2;
                        case 'centre', obj.centre = args{i+1}; i = i + 2;
                        case 'lifetime', obj.lifetime = args{i+1}; i = i + 2;
                        case 'itemApertureSize', obj.itemApertureSize = args{i+1}; i = i + 2;
                        otherwise
                            %                 error('Unknown switch "%s"!',args{i}) ;
                            i = i + 1;
                    end
                else
                    i = i + 1;
                end
            end
            
            
            radius_temp = angle2pix(display, obj.itemApertureSize,obj.itemApertureSize);
            radius = struct2cell(radius_temp(1));
            obj.radius = cell2mat(radius(1))/2;
            
            
            r = obj.radius * sqrt(rand(1,obj.nDots));
            theta = rand(1,obj.nDots) * 2 * pi;        
            obj.dotX = obj.centre(1) + r .* sin(theta);
            obj.dotY = obj.centre(2) + r .* cos(theta);
            obj.age = round(randi(round(obj.lifetime),1,obj.nDots));
            
            obj.direction = randsample(0:360,obj.nDots);
            nCoherent = round(obj.nDots*(obj.coherence/100));
            coherentDots = randsample(1:obj.nDots,nCoherent);
            obj.direction(coherentDots) = direction;
        end
        
        
        
        function moveDots(obj)
            
            obj.dotX = obj.dotX + cosd(obj.direction) .* obj.speed;
            obj.dotY = obj.dotY + sind(obj.direction) .* -obj.speed;
            obj.age = obj.age + 1;
            
        end
        
        function checkIfDead(obj)
            
            
            isDead = find(obj.age > obj.lifetime);
            
            
            if ~isempty(isDead)
                
                
                r = obj.radius * sqrt(rand(1,obj.nDots));
                theta = rand(1,obj.nDots) * 2 * pi;
                
                
                x = obj.centre(1) + r .* cos(theta);
                y = obj.centre(2) + r .* sin(theta);
                
                
                
                obj.dotX(isDead) = x(isDead);
                obj.dotY(isDead) = y(isDead);
                
                
                
                obj.age(isDead) = 0;
            end
            
            
        end
        
        function checkIfOut(obj)
            
            deltaX = obj.dotX - obj.centre(1);
            deltaY = obj.dotY - obj.centre(2);
            
            idx = deltaX.^2 + deltaY.^2 > obj.radius.^2;
            
            obj.dotX(idx) =obj.dotX(idx) - (deltaX(idx)*2);
            obj.dotY(idx) =obj.dotY(idx) - (deltaY(idx)*2);
            
            
        end
        
    end
end
