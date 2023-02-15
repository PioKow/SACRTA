function vis(roots,varargin)
%  vis: results visualization, plots the curve of the roots
%
% INPUTS
%
%  roots       : set of zero/poles and extra parameters [re(z) im(z) t]
%  varargin    : optional axis limits
%

figure()
hold on
plot3(roots(:,1),roots(:,2),roots(:,3),'k.','MarkerSize',0.5)
xlabel('re(z)');
ylabel('im(z)');
zlabel('t');
view(-30,45)
title('Final results:')

if(~isempty(varargin))
    Domain = varargin{1};
    xlim([Domain(:,1)])
    ylim([Domain(:,2)])
    zlim([Domain(:,3)])
end

drawnow;
hold off

end

