% ===================================================
% *** FUNCTION cieplot
% ***
% *** function = cieplot()
% *** colour representation of chromaticity diagram
% ===================================================
function [] = cieplot2(formulary)

[lambda, xFcn, yFcn, zFcn] = colorMatchFcn(formulary);
s=xFcn+yFcn+zFcn;
k1=length(lambda);
for i=1:k1
    x(i)=xFcn(i)/s(i);
    y(i)=yFcn(i)/s(i);
end

N = length(x);
i = 1;
e = 1/3;
steps = 25;
xy4rgb = zeros(N*steps*4,5,'double');
for w = 1:N                                     % wavelength
    w2 = mod(w,N)+1;
    a1 = atan2(y(w)  -e,x(w)  -e);              % start angle
    a2 = atan2(y(w2) -e,x(w2) -e);              % end angle
    r1 = ((x(w)  - e)^2 + (y(w)  - e)^2)^0.5;   % start radius
    r2 = ((x(w2) - e)^2 + (y(w2) - e)^2)^0.5;   % end radius
    for c = 1:steps                               % colourfulness
        % patch polygon
        xyz(1,1) = e+r1*cos(a1)*c/steps;
        xyz(1,2) = e+r1*sin(a1)*c/steps;
        xyz(1,3) = 1 - xyz(1,1) - xyz(1,2);
        xyz(2,1) = e+r1*cos(a1)*(c-1)/steps;
        xyz(2,2) = e+r1*sin(a1)*(c-1)/steps;
        xyz(2,3) = 1 - xyz(2,1) - xyz(2,2);
        xyz(3,1) = e+r2*cos(a2)*(c-1)/steps;
        xyz(3,2) = e+r2*sin(a2)*(c-1)/steps;
        xyz(3,3) = 1 - xyz(3,1) - xyz(3,2);
        xyz(4,1) = e+r2*cos(a2)*c/steps;
        xyz(4,2) = e+r2*sin(a2)*c/steps;
        xyz(4,3) = 1 - xyz(4,1) - xyz(4,2);
        % compute sRGB for vertices
        rgb = xyz2srgb(xyz');
        % store the results
        xy4rgb(i:i+3,1:2) = xyz(:,1:2);
        xy4rgb(i:i+3,3:5) = rgb';
        i = i + 4;
    end
end
[rows cols] = size(xy4rgb);
f = [1 2 3 4];
v = zeros(4,3,'double');
for i = 1:4:rows
    v(:,1:2) = xy4rgb(i:i+3,1:2);
    patch('Vertices',v, 'Faces',f, 'EdgeColor','none', ...
    'FaceVertexCData',xy4rgb(i:i+3,3:5),'FaceColor','interp')
end
end
function [rgb] = xyz2srgb(xyz)
    M = [ 3.2406 -1.5372 -0.4986; -0.9689 1.8758 0.0415; 0.0557 -0.2040 1.0570 ];
    [rows cols ] = size(xyz);
    rgb = M*xyz;
    for c = 1:cols
        for ch = 1:3
            if rgb(ch,c) <= 0.0031308
                rgb(ch,c) = 12.92*rgb(ch,c);
            else
                rgb(ch,c) = 1.055*(rgb(ch,c)^(1.0/2.4)) - 0.055;
            end
            % clip RGB
            if rgb(ch,c) < 0
                rgb(ch,c) = 0;
            elseif rgb(ch,c) > 1
                rgb(ch,c) = 1;
            end
        end
    end
end
% ====================================================
% *** END FUNCTION cieplot
% ==================================================== 