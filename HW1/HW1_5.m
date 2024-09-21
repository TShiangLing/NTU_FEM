f = @(x) 3*cos(x) + 0.1*exp(x) - 2;

x0_1 = 1;
x0_2 = 3;

root1 = fzero(f, x0_1);
root2 = fzero(f, x0_2);
root = [root1, root2];

fprintf('第一個根是: %.6f\n', root1);
fprintf('第二個根是: %.6f\n', root2);

figure;
fplot(f, [0, 4], '-b', 'DisplayName', 'f(x)');
hold on;
scatter(root, zeros(size(root)), 30, 'r', 'filled', 'DisplayName', 'Roots');
grid on;
xlabel('x');
ylabel('f(x)');
legend;
title('HW1 (4)');
