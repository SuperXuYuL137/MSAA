% % 示例数据
% [X, Y] = meshgrid(-5:0.5:5, -5:0.5:5);
% Z = sin(sqrt(X.^2 + Y.^2));
% 
% % 绘制三维图
% figure;
% surf(X, Y, Z);
% 
% % 设置视角为顶视图
% view(2);
% 
% % 添加一些标签和标题
% xlabel('X-axis');
% ylabel('Y-axis');
% title('Top view of the 3D plot');
% 创建三维数据
[X, Y, Z] = peaks;

% 创建三维表面图
figure;
surf(X, Y, Z);

% 设置视角为正面视图
view([0, 0]);

% 添加标题和标签
title('三维表面图 - 正面视角');
xlabel('X 轴');
ylabel('Y 轴');
zlabel('Z 轴');

% 可选：调整图形的其他属性
shading interp;
colormap jet;
colorbar;
