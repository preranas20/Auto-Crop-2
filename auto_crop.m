function [x0, y0, x1, y1, x2, y2, x3, y3] = auto_crop ( f )

%%%IMPORTANT%%%
% x0,y0 are the x, y coordinates of the top left corner of image
% x1,y1 are the x, y coordinates of the top right corner of image
% x2,y2 are the x, y coordinates of the bottom right corner of image
% x3,y3 are the x, y coordinates of the bottom left corner of image

%getting size of the input image
Ro = size(f,1);
Co = size(f,2);

%Taking blue component of the image
g = f(:,:,3);

%applying gaussian filter 
h=imgaussfilt(g,10);

%applying thershold of the image
level = graythresh(h);
segmented = imbinarize(h,level);

%performing canny edge detection on the image
BW = edge(segmented,'Canny');


%intializing the variables
x0 = double(Co*.25);
y0 = double(Ro*.25);

x1 = double(Co*.75);
y1 = double(Ro*.25);

x2 = double(Co*.75);
y2 = double(Ro*.75);

x3 = double(Co*.25);
y3 = double(Ro*.75);


%Hough transform of the image
[H,T,R] = hough(BW);
 
%calculations of hough peaks of the image
P  = houghpeaks(H,4,'threshold',0);
x = T(P(:,2)); y = R(P(:,1));

%calculating the lines detected through hough transform
lines = houghlines(BW,T,R,P,'FillGap',100,'MinLength',5);
%getting unique values of rho from the structure
[~, idx] = unique([lines.rho].', 'rows', 'stable');  
lines = lines(idx);
%figure, imshow(f), hold on


%calculation the end points of each hough lines 
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   xs1(k) = xy(1,1);
   ys1(k) = xy(1,2);
   xs2(k) = xy(2,1);
   ys2(k) = xy(2,2);
   slope(k) = (ys2(k)-ys1(k))/(xs2(k)-xs1(k));
   xLeft(k) = 1; 
   yLeft(k) = slope(k) * (xLeft(k) - xs1(k)) + ys1(k);
   xRight(k) = size(BW,2); % x is on the reight edge.
   yRight(k) = slope(k) * (xRight(k) - xs1(k)) + ys1(k);
  % plot([xLeft(k), xRight(k)], [yLeft(k), yRight(k)], 'LineWidth',2,'Color','blue');
  % plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

  if k==1
      line1x=[xLeft(k) xRight(k)];
      line1y=[yLeft(k) yRight(k)];
  elseif k==2
      line2x=[xLeft(k) xRight(k)];
      line2y=[yLeft(k) yRight(k)];
  elseif k==3
      line3x=[xLeft(k) xRight(k)];
      line3y=[yLeft(k) yRight(k)];
  elseif k==4
      line4x=[xLeft(k) xRight(k)];
      line4y=[yLeft(k) yRight(k)]; 
  end
      
end

%dividing the image into four quadrants
r1=1;
r4=Ro;
r2=floor((r1+r4)/2);
r3=r2 + 1;
c1=1;
c4=Co;
c2=floor((c1+c4)/2);
c3=c2 + 1;

%caclculating the intersection points of each combination of line
[x12,y12] = polyxpoly(line1x,line1y,line2x,line2y);
[x13,y13] = polyxpoly(line1x,line1y,line3x,line3y);
[x14,y14] = polyxpoly(line1x,line1y,line4x,line4y);
[x23,y23] = polyxpoly(line2x,line2y,line3x,line3y);
[x24,y24] = polyxpoly(line2x,line2y,line4x,line4y);
[x34,y34] = polyxpoly(line3x,line3y,line4x,line4y);

if isempty(x12)
    x12=0;
    y12=0;
end
if isempty(x13)
    x13=0;
    y13=0;
end

if isempty(x14)
    x14=0;
    y14=0;
end

if isempty(x23)
    x23=0;
    y23=0;
end

if isempty(x24)
    x24=0;
    y24=0;
end

if isempty(x34)
    x34=0;
    y34=0;
end


%sorting the intersected coordinates
intersectpts=[x12,y12;x13,y13;x14,y14;x23,y23;x24,y24;x34,y34];

sortpts = sortrows(intersectpts,1,'descend');
sortintersectpts=sortpts(1:4,:);
   

%getting the corner points of document as per the order 
if sortintersectpts(1,1)~=0
    if sortintersectpts(1,1)>=c1 && sortintersectpts(1,1)<=c2
        if sortintersectpts(1,2)>=r1 && sortintersectpts(1,2)<=r2
            x0=sortintersectpts(1,1);
            y0=sortintersectpts(1,2);
        elseif sortintersectpts(1,2)>=r3 && sortintersectpts(1,2)<=r4
            x3=sortintersectpts(1,1);
            y3=sortintersectpts(1,2);
        end
    elseif sortintersectpts(1,1)>=c3 && sortintersectpts(1,1)<=c4
        if sortintersectpts(1,2)>=r1 && sortintersectpts(1,2)<=r2
            x1=sortintersectpts(1,1);
            y1=sortintersectpts(1,2);
        elseif sortintersectpts(1,2)>=r3 && sortintersectpts(1,2)<=r4
            x2=sortintersectpts(1,1);
            y2=sortintersectpts(1,2);
        end
    end
end


if sortintersectpts(2,1)~=0
    if sortintersectpts(2,1)>=c1 && sortintersectpts(2,1)<=c2
        if sortintersectpts(2,2)>=r1 && sortintersectpts(2,2)<=r2
            x0=sortintersectpts(2,1);
            y0=sortintersectpts(2,2);
        elseif sortintersectpts(2,2)>=r3 && sortintersectpts(2,2)<=r4
            x3=sortintersectpts(2,1);
            y3=sortintersectpts(2,2);
        end
    elseif sortintersectpts(2,1)>=c3 && sortintersectpts(2,1)<=c4
        if sortintersectpts(2,2)>=r1 && sortintersectpts(2,2)<=r2
            x1=sortintersectpts(2,1);
            y1=sortintersectpts(2,2);
        elseif sortintersectpts(2,2)>=r3 && sortintersectpts(2,2)<=r4
            x2=sortintersectpts(2,1);
            y2=sortintersectpts(2,2);
        end
    end
end


if sortintersectpts(3,1)~=0
    if sortintersectpts(3,1)>=c1 && sortintersectpts(3,1)<=c2
        if sortintersectpts(3,2)>=r1 && sortintersectpts(3,2)<=r2
            x0=sortintersectpts(3,1);
            y0=sortintersectpts(3,2);
        elseif sortintersectpts(3,2)>=r3 && sortintersectpts(3,2)<=r4
            x3=sortintersectpts(3,1);
            y3=sortintersectpts(3,2);
        end
    elseif sortintersectpts(3,1)>=c3 && sortintersectpts(3,1)<=c4
        if sortintersectpts(3,2)>=r1 && sortintersectpts(3,2)<=r2
            x1=sortintersectpts(3,1);
            y1=sortintersectpts(3,2);
        elseif sortintersectpts(3,2)>=r3 && sortintersectpts(3,2)<=r4
            x2=sortintersectpts(3,1);
            y2=sortintersectpts(3,2);
        end
    end
end


if sortintersectpts(4,1)~=0
    if sortintersectpts(4,1)>=c1 && sortintersectpts(4,1)<=c2
        if sortintersectpts(4,2)>=r1 && sortintersectpts(4,2)<=r2
            x0=sortintersectpts(4,1);
            y0=sortintersectpts(4,2);
        elseif sortintersectpts(4,2)>=r3 && sortintersectpts(4,2)<=r4
            x3=sortintersectpts(4,1);
            y3=sortintersectpts(4,2);
        end
    elseif sortintersectpts(4,1)>=c3 && sortintersectpts(4,1)<=c4
        if sortintersectpts(4,2)>=r1 && sortintersectpts(4,2)<=r2
            x1=sortintersectpts(4,1);
            y1=sortintersectpts(4,2);
        elseif sortintersectpts(4,2)>=r3 && sortintersectpts(4,2)<=r4
            x2=sortintersectpts(4,1);
            y2=sortintersectpts(4,2);
        end
    end
end
% 
% 
% plot(x0,y0,'m*','markersize',8);
% plot(x1,y1,'m*','markersize',8);
% plot(x2,y2,'m*','markersize',8);
% plot(x3,y3,'m*','markersize',8);
 

end





