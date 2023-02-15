% this file contains all parameters of the analysis
% start point: zStart
% range of the analysis: tStart, tFinal
% accuracy: a
% advanced seetings: InitRotation,Optional
% buffers: ItMaxInit,ItMax

%initial point zero with initial triangle setting
zStart =-2.927648575;
InitRotation=deg2rad(12); 

% zStart =3.675195522;
% InitRotation=deg2rad(19); 

%frequency analysis range (normalization to 1GHz)
tStart=3; 
tFinal=7;

% tetrahedron edge length (the length of the side of the triangle of each wall) 
a=0.01; %accuracy

%frequency normalization (scale t parameters)
Optional=1e9;

%buffers
MaxInitNodes=100; % maximum number verfication points
NodesMax=50000;   % maximum number of nodes (function evaluation)

