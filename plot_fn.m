function plot_fn(params)
    

    scrs = params.scrs;
    n = size(scrs,1);
    mn1 = params.mn1;
    mn2 = params.mn2;
    U = params.U;
    p = params.p;

    hold on;
    scatteru(scrs);
    quiver(mn1(1), mn1(2), U(1,1), U(2,1), 0, 'k', 'LineWidth', 2, 'MaxHeadSize', 0.1);
    quiver(mn2(1), mn2(2), U(1,2), U(2,2), 0, 'k', 'LineWidth', 2, 'MaxHeadSize', 0.1);

    text(0.95, 0.95, sprintf('\\xi_m: %.4f', p), ...
        'Units', 'normalized', ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', ...
        'FontSize', 12, 'FontWeight', 'bold', 'Color', 'black', ...
        'Interpreter', 'tex');
    xlabel('Dim1')
    ylabel('Dim2')
    title(sprintf('MGS Demonstration: N=%.1d ',n))
    hold off;
end
