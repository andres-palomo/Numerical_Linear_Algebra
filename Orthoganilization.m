clear; clc; close all;

v1 = input('v1 = [a b c] (Default [1/2 1 0]): ');
if isempty(v1), v1 = [1/2 1 0]; end
v2 = input('v2 = [a b c] (Default [0 1 1]): ');
if isempty(v2), v2 = [0 1 1]; end
v3 = input('v3 = [a b c] (Default [1/2 0 1]): ');
if isempty(v3), v3 = [1/2 0 1]; end

v1 = v1(:); v2 = v2(:); v3 = v3(:);          % make column vectors
V  = [v1 v2 v3];

if rank(V) < 3
    error('v1, v2, v3 must be linearly independent.');
end

D = diag([1 1 0]);
P = V * D / V;                              % same as V*D*inv(V), but more stable

fprintf('\nP =\n'); 
disp(P);


while true
    x = input('Enter x = [x1 x2 x3] to be projected: ');
    if isempty(x)
        error('No vector');
    end
    if numel(x) ~= 3
        error('I must be 3D.');
    end
    x = x(:);

    Px = P * x;
    Qx = x - Px;

    fprintf('Px = [%8.4f %8.4f %8.4f]\n', Px);
    fprintf('(I-P)x = [%8.4f %8.4f %8.4f]\n', Qx);

    %% Plot - 100% AI--- way better that I could ever do... :(
    figure(1); clf; hold on; grid on; axis equal;

    % plot size: big enough to contain all vectors
    L = 1.3 * max([norm(x), norm(Px), norm(Qx), 1]);

    % S1: plane s*v1 + t*v2, scaled so it covers the vectors
    n1 = norm(v1); n2 = norm(v2);
    [s, t] = meshgrid(linspace(-L/n1, L/n1, 2), linspace(-L/n2, L/n2, 2));
    surf(s*v1(1) + t*v2(1), s*v1(2) + t*v2(2), s*v1(3) + t*v2(3), ...
         'FaceColor', [0.30 0.60 0.90], 'FaceAlpha', 0.25, 'EdgeColor', 'none');

    % S2: line t*v3
    u3 = v3 / norm(v3);
    plot3(L*[-u3(1) u3(1)], L*[-u3(2) u3(2)], L*[-u3(3) u3(3)], ...
          'Color', [0.10 0.60 0.30], 'LineWidth', 2);

    % vectors from the origin
    quiver3(0,0,0, x(1),  x(2),  x(3),  0, 'k', 'LineWidth', 2.5, 'MaxHeadSize', 0.3);
    quiver3(0,0,0, Px(1), Px(2), Px(3), 0, 'r', 'LineWidth', 2.5, 'MaxHeadSize', 0.3);
    quiver3(0,0,0, Qx(1), Qx(2), Qx(3), 0, 'm', 'LineWidth', 2.5, 'MaxHeadSize', 0.3);

    % dashed line from x to Px: it is parallel to v3, i.e. "along S2"
    plot3([x(1) Px(1)], [x(2) Px(2)], [x(3) Px(3)], 'k--', 'LineWidth', 1);

    plot3(0, 0, 0, 'k.', 'MarkerSize', 15);
    xlabel('x_1'); ylabel('x_2'); zlabel('x_3');
    title(sprintf('Projection on S_1 along S_2,  x = (%g, %g, %g)', x));
    legend({'S_1 = span\{v_1, v_2\}', 'S_2 = span\{v_3\}', 'x', 'Px', '(I-P)x', ...
            'x \rightarrow Px (parallel to v_3)'}, 'Location', 'northeastoutside');
    view(35, 20);
    rotate3d on;              % drag the figure with the mouse to rotate
    hold off; drawnow;
end