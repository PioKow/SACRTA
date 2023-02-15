function [Flag, Face, SuspIndexAD, SuspIndexBD, SuspIndexCD] = CAP_tetrahedron( VqAB, VqBC, VqCA , VqAD, VqBD, VqCD , dir )
%  CAP_tetrahedron:
%                  dicretization of Cauchy arument Principle
%                  procedure verifies change quadrant number in equilateral tetrahedron contour
%                  (along edges on three faces (without base) ABD,BCD,CAD) at associated points
%                  it finds a double phase change at ends single segment
%                  or it finds and determining the face the existence of four possible quadrants in correct order
%
% INPUTS
%  VqAB     : quadrants at single segments points on the egde of AB
%  VqBC     : quadrants at single segments points on the egde of BC
%  VqCA     : quadrants at single segments points on the egde of CA
%  VqAD     : quadrants at single segments points on the egde of AD
%  VqBD     : quadrants at single segments points on the egde of BD
%  VqCD     : quadrants at single segments points on the egde of CD
%  dir      : direction tracing
%
% OUTPUTS
%  Flag            : answer for the CAP results
%                    0 - no double phase change has been detected
%                    1 - the existence of four possible quadrants in correct without double phase change along single segment
%                    2 - both above conditions (0,1) are not met
%  Face            : vector to identify a face, where four quadrants in correct order exist
%  SuspIndexAD     : vector to identify a single element at AB edge, where double phase change exist
%  SuspIndexBD     : vector to identify a single element at BC edge, where double phase change exist
%  SuspIndexCD     : vector to identify a single element at CA edge, where double phase change exist
%

Flag=0;
Face=[];

dVqAB=diff(VqAB);
dVqAB(dVqAB==-3)=1;
dVqAB(dVqAB==3)=-1;

dVqBC=diff(VqBC);
dVqBC(dVqBC==-3)=1;
dVqBC(dVqBC==3)=-1;

dVqCA=diff(VqCA);
dVqCA(dVqCA==-3)=1;
dVqCA(dVqCA==3)=-1;

dVqAD=diff(VqAD);
dVqAD(dVqAD==-3)=1;
dVqAD(dVqAD==3)=-1;

dVqBD=diff(VqBD);
dVqBD(dVqBD==-3)=1;
dVqBD(dVqBD==3)=-1;

dVqCD=diff(VqCD);
dVqCD(dVqCD==-3)=1;
dVqCD(dVqCD==3)=-1;

SuspIndexAD = find(abs(dVqAD)==2);
SuspIndexBD = find(abs(dVqBD)==2);
SuspIndexCD = find(abs(dVqCD)==2);

if isempty(SuspIndexAD) && isempty(SuspIndexBD) && isempty(SuspIndexCD)
    dVqABD = [dVqAB dVqBD -(dVqAD)]; % face ABD
    dVqBCD = [dVqBC dVqCD -(dVqBD)]; % face BCD
    dVqCAD = [dVqCA dVqAD -(dVqCD)]; % face CAD

    tempABD = (sum(dVqABD)==4*dir);
    tempBCD = (sum(dVqBCD)==4*dir);
    tempCAD = (sum(dVqCAD)==4*dir);
    temp = tempABD + tempBCD + tempCAD;

    if temp>=1
        Flag=1;
        if(tempABD==1)
            Face = [Face 1];
        end
        if(tempBCD==1)
            Face = [Face 2];
        end
        if(tempCAD==1)
            Face = [Face 3];
        end
    else
        Flag = 2;
        SuspIndexAD = 1:length(dVqAD);
        SuspIndexBD = 1:length(dVqBD);
        SuspIndexCD = 1:length(dVqCD);
    end
end

end

