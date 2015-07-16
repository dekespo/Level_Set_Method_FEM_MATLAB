function geom = square(xmin,xmax,ymin,ymax)
%Domain-shaping
geom = [2 xmin xmax ymin ymin 1 0;
    2 xmax xmax ymin ymax 1 0;
    2 xmax xmin ymax ymax 1 0;
    2 xmin xmin ymax ymin 1 0]';
end
