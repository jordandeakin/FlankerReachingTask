function [ pixpos, visang_deg, pix_pervisang ] = angle2pix( display, x,y )

% Converts visual angle into pixels

visang_rad = 2*atan(display.width/2/display.dist);
visang_deg = visang_rad * (180/pi);

pix_pervisang = display.resolution(1) / visang_deg;

% pixpos.x = round(dots.x.*pix_pervisang);
pixpos.x = (x.*pix_pervisang);

if nargin > 1
%    pixpos.y = round(dots.y.*pix_pervisang);
        pixpos.y = (y.*pix_pervisang);

end

end

