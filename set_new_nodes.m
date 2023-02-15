function [EdgesToSplit,NodesAB,NodesBC,NodesCA] = set_new_nodes(NodesAB,NodesBC,NodesCA,SuspIndexAB,SuspIndexBC,SuspIndexCA,NrOfNodes)
%  set_new_nodes: divides the segments in half
%                 and extends the node vectors with new indices
%
% INPUTS
%  NodesAB     : node indices between edge AB
%  NodesBC     : node indices between edge BC
%  NodesCA     : node indices between edge CA
%  SuspIndexAB : vector to identify a single element at AB edge, where double phase change exist
%  SuspIndexBC : vector to identify a single element at BC edge, where double phase change exist
%  SuspIndexCA : vector to identify a single element at CA edge, where double phase change exist
%  NrOfNodes   : last node index in the chain
%
% OUTPUTS
%  EdgesToSplit : nodes forming a suspect segment
%  NodesAB      : node indices between edge AB (with new nodes)
%  NodesBC      : node indices between edge AB (with new nodes)
%  NodesCA      : node indices between edge AB (with new nodes)
%

EdgesToSplit = [
    NodesAB(flip(SuspIndexAB,1)) NodesAB(flip(SuspIndexAB+1,1));
    NodesBC(flip(SuspIndexBC,1)) NodesBC(flip(SuspIndexBC+1,1));
    NodesCA(flip(SuspIndexCA,1)) NodesCA(flip(SuspIndexCA+1,1))
    ];

for ik = length(SuspIndexAB):-1:1
    NrOfNodes = NrOfNodes+1;
    NodesAB = [NodesAB(1:SuspIndexAB(ik)); NrOfNodes; NodesAB((SuspIndexAB(ik)+1):end)];
end
for ik = length(SuspIndexBC):-1:1
    NrOfNodes = NrOfNodes+1;
    NodesBC = [NodesBC(1:SuspIndexBC(ik)); NrOfNodes; NodesBC((SuspIndexBC(ik)+1):end)];
end
for ik = length(SuspIndexCA):-1:1
    NrOfNodes = NrOfNodes+1;
    NodesCA = [NodesCA(1:SuspIndexCA(ik)); NrOfNodes; NodesCA((SuspIndexCA(ik)+1):end)];
end

end

