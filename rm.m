function r = rm(a1,a2,a3)
rx = [1,0,0;0,cos(a1*pi/180),-sin(a1*pi/180);0,sin(a1*pi/180),cos(a1*pi/180)];
ry = [cos(a2*pi/180),0,sin(a2*pi/180);0,1,0;-sin(a2*pi/180),0,cos(a2*pi/180)];
rz = [cos(a3*pi/180),-sin(a3*pi/180),0;sin(a3*pi/180),cos(a3*pi/180),0;0,0,1];
r = rz*ry*rx;
end