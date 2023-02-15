% Copyright (c) 2021 Gdansk University of Technology
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
%
% Author: S.Dziedziewicz P.Kowalczyk R.Lech M.Warecka
% Project homepage: https://github.com/PioKow/SACRTA
%
%
% main program SACRTA
%
close all;
clear all;
clc;
format long;
restoredefaultpath

%choose the example
addpath('1_graphene_transmission_line')
%addpath('2_cylindrical_waveguide');

analysis_parameters; %input file

%create the intial traingle
fi=[0;1;2]*2*pi/3+InitRotation;

%tracing direction
% dir= 1 extra parameter increases
% dir=-1 extra parameter decrease
dir=sign(tFinal-tStart);
if(dir==-1)
    fi=flip(fi,1);
end

z0 = zStart+(a/sqrt(3))*exp(1i*fi);
NewNodesCoord = [real(z0) imag(z0)];
NewNodesCoord(:,3) = tStart;

%initialization of the variables
Elements = [1 2 3];
NodesAB = [1;2];
NodesBC = [2;3];
NodesCA = [3;1];
NodesCoord=[];
NrOfNodes = size(NodesCoord,1);

disp('The evaluation for the initial point has been started.')
Flag=0;
%%%% analysis mode, based on CAP results
% Flag = 0 (verification in progress) no roots has been detected
% Flag = 1 (verification completed) the existence of roots along double phase edges
while Flag==0

    %function evaluation and phase analysis
    NodesCoord=[NodesCoord ; NewNodesCoord];
    for Node=NrOfNodes+1:NrOfNodes+size(NewNodesCoord,1)
        FunctionValues(Node,1)=fun(NodesCoord(Node,:),Optional);
        Quadrants(Node,1) = vinq(FunctionValues(Node,1));
    end
    NrOfNodes = size(NodesCoord,1);

    %applying the CAP in a triangle
    [Flag, SuspAB, SuspBC, SuspCA] = CAP_triangle(Quadrants(NodesAB)', Quadrants(NodesBC)', Quadrants(NodesCA)' , dir);

    %adding extra point on the edge where a double phase change is detected at its ends
    if Flag==0
        [EdgesToSplit,NodesAB,NodesBC,NodesCA] = set_new_nodes(NodesAB,NodesBC,NodesCA,SuspAB,SuspBC,SuspCA,NrOfNodes);
        NewNodesCoord = (NodesCoord(EdgesToSplit(:,1),:)+NodesCoord(EdgesToSplit(:,2),:))/2;
    else
        %determination of the coordinates of the root inside the triangle
        roots(1,:) = mean(NodesCoord,1);
    end
    if NrOfNodes>MaxInitNodes
        disp(['The maximum number of inital nodes has been reached',newline,'The starting point probably is not root!'])
        disp(['Check the all settings',newline,'The analysis hasnt been started.'])
        return
    end
end

H=sqrt(6)*a/3; %tetrahedron height
disp('The tracing routine has been started.')
%%%% analysis mode, base CAP results
% Flag = 0 - (verification in progress) no roots has been detected
% Flag = 1 - (verification in progress) the existence of one root or more along faces of a tetrahedron
% Flag = 2 - (aborted verification) the problem of unambiguously defining zero
% Flag = 3 - (correted verification) the final results
%% general loop
while NrOfNodes<NodesMax && Flag<2

    %tetrahedron formation by adding height to one of the faces
    A = NodesCoord(Elements(end,1),:);
    B = NodesCoord(Elements(end,2),:);
    C = NodesCoord(Elements(end,3),:);
    nvec=cross(C-B,A-B)/norm(cross(C-B,A-B));

    %adding new point and chain of tetetrahedrons
    NewNodesCoord = ((A+B+C)/3)+nvec*H;
    NrOfNodes = size(NodesCoord,1);
    NodesAD = [Elements(end,1); NrOfNodes+1];
    NodesBD = [Elements(end,2); NrOfNodes+1];
    NodesCD = [Elements(end,3); NrOfNodes+1];

    Flag=0;
    while(Flag==0)

        %function evaluation and phase analysis
        NodesCoord=[NodesCoord; NewNodesCoord];
        for Node=NrOfNodes+1:NrOfNodes+size(NewNodesCoord,1)
            FunctionValues(Node,1)=fun(NodesCoord(Node,:),Optional);
            Quadrants(Node,1) = vinq(FunctionValues(Node,1) );
        end
        NrOfNodes = size(NodesCoord,1);

        %applying the CAP in a tetrahedron
        [Flag, Face, SuspAD, SuspBD, SuspCD] = CAP_tetrahedron(Quadrants(NodesAB)', Quadrants(NodesBC)', Quadrants(NodesCA)' , Quadrants(NodesAD)', Quadrants(NodesBD)', Quadrants(NodesCD)' , dir );

        %adding extra point on the edge where a double phase change is detected at its ends
        if(Flag==0)
            [EdgesToSplit,NodesAD,NodesBD,NodesCD] = set_new_nodes(NodesAD,NodesBD,NodesCD,SuspAD,SuspBD,SuspCD,NrOfNodes);
            NewNodesCoord = (NodesCoord(EdgesToSplit(:,1),:)+NodesCoord(EdgesToSplit(:,2),:))/2;
        elseif(Flag==1)
            if(size(Face,2)>1) %multipath root
                disp(['WARRING!',newline,'Both or more characteristics are probable to have intersected.'])
                disp('The problem is around the point.')
                disp(roots(end,:))
                disp('One of the path was automatically tracing.')
                Face = Face(1);
            end
            %determining the face that becomes the base of the new tetrahedron
            switch Face %swap verices
                case 1 %ABD -> ABC;
                    Elements(end+1,:) = [Elements(end,1) Elements(end,2) NodesAD(end,:)];
                    NodesBC = NodesBD;
                    NodesCA = flip(NodesAD,1);
                case 2 %BCD -> ABC
                    Elements(end+1,:) = [Elements(end,2) Elements(end,3) NodesAD(end,:)];
                    NodesAB = NodesBC;
                    NodesBC = NodesCD;
                    NodesCA = flip(NodesBD,1);
                case 3 %CAD -> ABC
                    Elements(end+1,:) = [Elements(end,3) Elements(end,1) NodesAD(end,:)];
                    NodesAB = NodesCA;
                    NodesBC = NodesAD;
                    NodesCA = flip(NodesCD,1);
            end
            %determination of the coordinates of the root inside the face
            roots(end+1,:)=mean([NodesCoord(NodesAB(1:end-1),:); NodesCoord(NodesBC(1:end-1),:); NodesCoord(NodesCA(1:end-1),:)],1);
            if(dir*roots(end,3)>dir*tFinal)
                Flag=3; %termination condition
            end
        end
    end
end

disp('----------------------------------------------------------------')
%final analysis
if(NrOfNodes>=NodesMax && Flag<2)
    disp(['The maximum number of nodes has been reached.',newline,'The results could be not complete.']);
elseif(Flag==2)
    disp(['ERROR!',newline,'The function argument doesnt varies inside the tetrahedron.'])
    disp(['It isnt taking the values from the four quadrants (I, II, III, and IV).',newline,'Analysis had to be interrupted.'])
elseif(Flag>2)
    disp(['Analysis completed correctly.',newline,'Check the results in the plot.'])
end

%visualization results
vis(roots)

