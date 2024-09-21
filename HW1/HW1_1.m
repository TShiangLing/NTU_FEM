f = @(x) 4 * cos(x) - 2;

a = 0;
b = pi;

integral_exact = integral(f, a, b);

n_values = 1:1000;
errors = zeros(length(n_values), 1);


for k = 1:length(n_values)
    n = n_values(k);  
    h = (b - a) / n;  
    x = linspace(a, b, n+1);  
    y = f(x);  

    integral_trapezoid = 0;
    for i = 1:n
        integral_trapezoid = integral_trapezoid + ((y(i) + y(i+1)) * h * 0.5);
    end

    errors(k) = abs(integral_trapezoid - integral_exact);
end

figure;
plot(1./n_values, errors, 'b-');
xlabel('step size');
ylabel('error');
title('HW1 (1)');
ylim([0, 1e-9])
set(gca, 'XDir', 'reverse');
set(gca, 'XScale', 'log');
grid on;

