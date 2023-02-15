function [Flag, SuspIndexAB, SuspIndexBC, SuspIndexCA] = CAP_triangle( VqAB, VqBC, VqCA , dir )
%  CAP_triangle:
%                  dicretization of Cauchy arument Principle
%                  procedure verifies change quadrant number in equilateral triagnle contour (along edges AB->BC->CA) at associated points
%                  it finds a double phase change at ends single segment
%                  or it finds the existence of four possible quadrants in correct order
%
% INPUTS
%  VqAB     : quadrants at single segments points on the egde of AB
%  VqBC     : quadrants at single segments points on the egde of BC
%  VqCA     : quadrants at single segments points on the egde of CA
%  dir      : direction tracing
%
% OUTPUTS
%  Flag            : answer for the CAP results
%                    0 - no double phase change has been detected
%                    1 - the existence of four possible quadrants in correct without double phase change along single segment
%  SuspIndexAB     : vector to identify a single element at AB edge, where double phase change exist
%  SuspIndexBC     : vector to identify a single element at BC edge, where double phase change exist
%  SuspIndexCA     : vector to identify a single element at CA edge, where double phase change exist
%

Flag=0;

dVqAB=diff(VqAB);
dVqAB(dVqAB==-3)=1;
dVqAB(dVqAB==3)=-1;

dVqBC=diff(VqBC);
dVqBC(dVqBC==-3)=1;
dVqBC(dVqBC==3)=-1;

dVqCA=diff(VqCA);
dVqCA(dVqCA==-3)=1;
dVqCA(dVqCA==3)=-1;

SuspIndexAB = find(abs(dVqAB)==2);
SuspIndexBC = find(abs(dVqBC)==2);
SuspIndexCA = find(abs(dVqCA)==2);

if isempty(SuspIndexAB) && isempty(SuspIndexBC) && isempty(SuspIndexAB)
    dVq = [dVqAB dVqBC dVqCA];
    if(sum(dVq)==4*dir)
        Flag=1;
    else
        %dividing all edges
        SuspIndexAB = 1:length(dVqAB);
        SuspIndexBC = 1:length(dVqBC);
        SuspIndexCA = 1:length(dVqCA);
    end
end

end

