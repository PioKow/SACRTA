% this file contains all parameters of the analysis
% start point: zStart
% range of the analysis: tStart, tFinal
% accuracy: a
% advanced seetings: InitRotation,Optional
% buffers: ItMaxInit,ItMax

%initial point zero 
zStart= 141.505650594 + 165.87493656i;
%zStart= -79.380259681 + 203.072451717i
   
%frequency analysis range (normalization to 100GHz)
tStart=70; 
tFinal=10;

% tetrahedron edge length (the length of the side of the triangle of each wall) 
a=1; %accuracy

%initial triangle setting in the XY plane 
InitRotation=deg2rad(1);

%frequency normalization (scale t parameters)
Optional=1e11;

%buffers
MaxInitNodes=100;  % maximum number verfication points
NodesMax=50000;    % maximum number of nodes (function evaluation)

