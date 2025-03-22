function chaos_density_comparison()
    N = 1; % 数据点数
    dim = 1000; % 维度

    % 初始化存储结果的矩阵
    all_results = zeros(N * dim, 21);

    % 生成21种混沌映射数据
    for label = 1:21
        [result, ~] = Map_set(N, dim, label);
        all_results(:, label) = result(:);
    end

    % 绘制概率密度对比图
    figure;
    hold on;
    for label = 1:21
        pd = fitdist(all_results(:, label), 'Kernel', 'Kernel', 'epanechnikov');
        x_values = linspace(-1, 1, 1000);
        y_values = pdf(pd, x_values);
        plot(x_values, y_values, 'DisplayName', ['Map ', num2str(label)]);
    end
    hold off;
    legend('show');
    title('PDF Comparison of 21 Chaos Maps');
    xlabel('Value');
    ylabel('Probability Density');
end
