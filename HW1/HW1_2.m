f = @(x) 4*x.^3 + 7*x.^4 + 2*x + 9;

df_exact = @(x) 12*x.^2 + 28*x.^3 + 2;

x = linspace(0, 1, 100);

h = 0.1:-0.0001:0.0001;
h_values_to_plot = [0.1, 0.01, 0.001, 0.0001];

h_plot_indices = arrayfun(@(val) find(abs(h - val) < 1e-10), h_values_to_plot, 'UniformOutput', false);
h_plot_indices = [h_plot_indices{:}]; 

df_forward = cell(length(h), 1);
df_central = cell(length(h), 1);
error_forward = zeros(length(h), 1);
error_central = zeros(length(h), 1);

for i = 1:length(h)
    df_forward{i} = (f(x + h(i)) - f(x)) / h(i);
    df_central{i} = (f(x + h(i)) - f(x - h(i))) / (2 * h(i));
    
    error_forward(i) = (sum((df_forward{i} - df_exact(x)).^2))./100;
    error_central(i) = (sum((df_central{i} - df_exact(x)).^2))./100;
end


figure;
subplot(2, 1, 1);
plot(x, df_exact(x), 'k', 'DisplayName', 'Exact Derivative');
hold on;
for i = h_plot_indices
    plot(x, df_forward{i}, 'DisplayName', ['Forward Difference (h = ', num2str(h(i)), ')']);
end
title('Forward Difference Method');
legend('Location', 'northwest');
xlabel('x');
ylabel('f''(x)');

subplot(2, 1, 2);
plot(x, df_exact(x), 'k', 'DisplayName', 'Exact Derivative');
hold on;
for i = h_plot_indices
    plot(x, df_central{i}, 'DisplayName', ['Central Difference (h = ', num2str(h(i)), ')']);
end
title('Central Difference Method');
legend('Location', 'northwest');
xlabel('x');
ylabel('f''(x)');

figure;
loglog(h, error_forward, '-', 'DisplayName', 'Forward Difference Error');
hold on;
loglog(h, error_central, '-', 'DisplayName', 'Central Difference Error');
title('HW1 (2b)');
xlabel('step size');
ylabel('mse error');
legend;
grid on;
set(gca, 'XDir', 'reverse');
