f = @(x) 3*sin(x) + 0.5*exp(x);

x_range = [-1, 1];
x = linspace(x_range(1), x_range(2), 100);

y_true = f(x);

poly_orders = [1, 2, 3, 4];
num_points = [5, 10, 15];

errors = zeros(length(num_points), length(poly_orders));

line_styles = {'-', '--', ':', '-.'};
colors = lines(length(poly_orders)); 

figure;
hold on;
for n = 1:length(num_points)
    x_interp = linspace(x_range(1), x_range(2), num_points(n));
    y_interp = f(x_interp);
    for p = 1:length(poly_orders)
        if poly_orders(p) >= num_points(n)
            continue;
        end
        p_poly = polyfit(x_interp, y_interp, poly_orders(p));
        y_fit = polyval(p_poly, x);
        errors(n, p) = norm(y_true - y_fit, inf);
        
        plot(x, y_fit, 'DisplayName', sprintf('Points: %d, Order: %d', num_points(n), poly_orders(p)), ...
             'Color', colors(p, :), 'LineStyle', line_styles{n});
    end
end
plot(x, y_true, 'k--', 'DisplayName', 'True Function');
legend('Location', 'northwest');
title('HW1 (5)');
xlabel('x');
ylabel('f(x)');


figure;
hold on;
for n = 1:length(num_points)
    x_interp = linspace(x_range(1), x_range(2), num_points(n));
    y_interp = f(x_interp);
    for p = 1:length(poly_orders)
        if poly_orders(p) >= num_points(n)
            continue;
        end
        p_poly = polyfit(x_interp, y_interp, poly_orders(p));
        y_fit = polyval(p_poly, x);
        square_error = (y_fit - y_true).^2;
        
        plot(x, square_error, 'DisplayName', sprintf('Points: %d, Order: %d', num_points(n), poly_orders(p)), ...
             'Color', colors(p, :), 'LineStyle', line_styles{n});
    end
end
legend;
title('HW1 (5)');
xlabel('x');
ylabel('Square Error');
grid on;


disp('Interpolation errors:');
for n = 1:length(num_points)
    for p = 1:length(poly_orders)
        if poly_orders(p) < num_points(n)
            fprintf('Points: %d, Order: %d, Error: %.4f\n', num_points(n), poly_orders(p), errors(n, p));
        end
    end
end
