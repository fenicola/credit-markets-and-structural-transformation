%% Exercise 2 (a) - Static comparison: Turkey 2025 vs Korea 1997
clear; clc; close all;

%% 1. 
excel_file = 'data_korea_turkey.xlsx';
data = readtable(excel_file);

year_T = 2025;      % Turkey (Economy A)
year_K = 1997;      % Korea  (Economy B)

row_T = (data.year == year_T);
row_K = (data.year == year_K);


prices = [1.0, 1.0, 1.0];

c_bar_a_val = -1388;
c_bar_m_val = 0;
c_bar_s_val = 12251;
epsilon_val = 0.75;     

sum_c_bar = c_bar_a_val + c_bar_m_val + c_bar_s_val;

%% 2. ECONOMY A: Turkey 2025

w_T   = data.gdp_TUR(row_T);
s_a_T = data.agr_TUR(row_T) / 100;
s_m_T = data.ind_TUR(row_T) / 100;
s_s_T = data.srv_TUR(row_T) / 100;


W_bar_T = w_T + sum_c_bar;

% omega_i = (s_i * w + c_bar_i) / (w + sum(c_bar))
params_T.omega_a = (s_a_T * w_T + c_bar_a_val) / W_bar_T;
params_T.omega_m = (s_m_T * w_T + c_bar_m_val) / W_bar_T;
params_T.omega_s = (s_s_T * w_T + c_bar_s_val) / W_bar_T;

params_T.epsilon = epsilon_val;
params_T.c_bar_a = c_bar_a_val;
params_T.c_bar_m = c_bar_m_val;
params_T.c_bar_s = c_bar_s_val;

% FOC with fsolve
x0_T = [w_T/(3*prices(1)), w_T/(3*prices(2)), w_T/(3*prices(3)), 1/w_T];
options = optimoptions('fsolve', 'Display', 'off');

[sol_T, ~] = fsolve(@(x) solve_consumption_foc(x, w_T, prices, params_T), x0_T, options);

ca_T = sol_T(1);
cm_T = sol_T(2);
cs_T = sol_T(3);
lambda_T = sol_T(4);

expenditure_T = prices(1)*ca_T + prices(2)*cm_T + prices(3)*cs_T;
share_a_T = (prices(1)*ca_T) / expenditure_T * 100;
share_m_T = (prices(2)*cm_T) / expenditure_T * 100;
share_s_T = (prices(3)*cs_T) / expenditure_T * 100;

%% 3. ECONOMY B: Korea 1997

w_K   = data.gdp_KOR(row_K);
s_a_K = data.agr_KOR(row_K) / 100;
s_m_K = data.ind_KOR(row_K) / 100;
s_s_K = data.srv_KOR(row_K) / 100;

W_bar_K = w_K + sum_c_bar;

params_K.omega_a = (s_a_K * w_K + c_bar_a_val) / W_bar_K;
params_K.omega_m = (s_m_K * w_K + c_bar_m_val) / W_bar_K;
params_K.omega_s = (s_s_K * w_K + c_bar_s_val) / W_bar_K;

params_K.epsilon = epsilon_val;
params_K.c_bar_a = c_bar_a_val;
params_K.c_bar_m = c_bar_m_val;
params_K.c_bar_s = c_bar_s_val;

% FOC with fsolve
x0_K = [w_K/(3*prices(1)), w_K/(3*prices(2)), w_K/(3*prices(3)), 1/w_K];

[sol_K, ~] = fsolve(@(x) solve_consumption_foc(x, w_K, prices, params_K), x0_K, options);

ca_K = sol_K(1);
cm_K = sol_K(2);
cs_K = sol_K(3);
lambda_K = sol_K(4);

expenditure_K = prices(1)*ca_K + prices(2)*cm_K + prices(3)*cs_K;
share_a_K = (prices(1)*ca_K) / expenditure_K * 100;
share_m_K = (prices(2)*cm_K) / expenditure_K * 100;
share_s_K = (prices(3)*cs_K) / expenditure_K * 100;

%% 4. 
fprintf('============================================================\n');
fprintf('Exercise 2(a) - STATIC CALIBRATION OF THE 2 STAGES OF DEVELOPMENT\n');
fprintf('============================================================\n\n');

fprintf('--- TURKEY %d (Economy A) ---\n', year_T);
fprintf('GDP PER CAPITA (w): %.2f\n', w_T);
fprintf('Omega calibrated:    omega_a = %.4f, omega_m = %.4f, omega_s = %.4f (Somma = %.4f)\n', ...
    params_T.omega_a, params_T.omega_m, params_T.omega_s, ...
    params_T.omega_a + params_T.omega_m + params_T.omega_s);
fprintf('Obtimal Consumptions:     ca = %.2f, cm = %.2f, cs = %.2f\n', ca_T, cm_T, cs_T);
fprintf('Total Expenditure:       %.2f (Must be equal the income)\n', expenditure_T);
fprintf('Model Shares:      Agri = %5.2f%%, Manu = %5.2f%%, Serv = %5.2f%%\n', share_a_T, share_m_T, share_s_T);
fprintf('Shares Hystorical Data: Agri = %5.2f%%, Manu = %5.2f%%, Serv = %5.2f%%\n\n', ...
    data.agr_TUR(row_T), data.ind_TUR(row_T), data.srv_TUR(row_T));

fprintf('--- KOREA %d (Economy B) ---\n', year_K);
fprintf('GDP PER CAPITA (w): %.2f\n', w_K);
fprintf('Omega calibrated:    omega_a = %.4f, omega_m = %.4f, omega_s = %.4f (Somma = %.4f)\n', ...
    params_K.omega_a, params_K.omega_m, params_K.omega_s, ...
    params_K.omega_a + params_K.omega_m + params_K.omega_s);
fprintf('Obtimal Consumptions:     ca = %.2f, cm = %.2f, cs = %.2f\n', ca_K, cm_K, cs_K);
fprintf('Total Expenditure:       %.2f (Must be equal the income)\n', expenditure_K);
fprintf('Model Shares:      Agri = %5.2f%%, Manu = %5.2f%%, Serv = %5.2f%%\n', share_a_K, share_m_K, share_s_K);
fprintf('Shares Hystorical Data: Agri = %5.2f%%, Manu = %5.2f%%, Serv = %5.2f%%\n\n', ...
    data.agr_KOR(row_K), data.ind_KOR(row_K), data.srv_KOR(row_K));

%% 5. FIGURE 1 - Comparison GDP PER CAPITA
mean_gdp = mean([w_T, w_K]);

figure;
hold on; box on; grid on;

plot(data.year, data.gdp_KOR, '-b', 'LineWidth', 2, 'DisplayName', 'Korea');
plot(data.year, data.gdp_TUR, '-r', 'LineWidth', 2, 'DisplayName', 'Turkey');

% Horizontal line at common income (~15.700)
plot([min(data.year) max(data.year)], [mean_gdp mean_gdp], '--k', 'DisplayName', 'Level of common income');

plot(year_K, w_K, 'o', 'MarkerSize', 9, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
plot(year_T, w_T, 'o', 'MarkerSize', 9, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');

% Line that shows the matched income with delay (28 years)
plot([year_K year_T], [mean_gdp mean_gdp] + 1500, 'k-', 'LineWidth', 1.2, 'HandleVisibility', 'off');
text(mean([year_K year_T]), mean_gdp + 2600, sprintf('%d years of delay', year_T - year_K), ...
    'HorizontalAlignment', 'center', 'FontWeight', 'bold');

text(year_K, w_K - 2500, sprintf('Korea %d\n$%.0f', year_K, w_K), 'HorizontalAlignment', 'center');
text(year_T, w_T - 2500, sprintf('Turkey %d\n$%.0f', year_T, w_T), 'HorizontalAlignment', 'right');

xlabel('Year');
ylabel('GDP PER CAPITA costant prices');
title('GDP PER CAPITA: Korea e Turkey reach the same stage after 28 years');
legend('Location', 'northwest');
xlim([min(data.year) max(data.year)]);
ylim([0 max([data.gdp_KOR; data.gdp_TUR]) * 1.08]);

%% 6. FIGURE 2 - Sectoral compsition at comparable stage: Model vs Data
figure;

tur_plot = [share_a_T, data.agr_TUR(row_T); ...
            share_m_T, data.ind_TUR(row_T); ...
            share_s_T, data.srv_TUR(row_T)];

kor_plot = [share_a_K, data.agr_KOR(row_K); ...
            share_m_K, data.ind_KOR(row_K); ...
            share_s_K, data.srv_KOR(row_K)];

subplot(1,2,1);
bar(tur_plot);
set(gca, 'XTickLabel', {'Agriculture', 'Manufacturing', 'Services'});
ylabel('Share (%)'); ylim([0 100]); grid on;
title(sprintf('Turkey %d: Model vs Data', year_T));
legend({'Model', 'Data'}, 'Location', 'northwest');

subplot(1,2,2);
bar(kor_plot);
set(gca, 'XTickLabel', {'Agriculture', 'Manufacturing', 'Services'});
ylabel('Share (%)'); ylim([0 100]); grid on;
title(sprintf('Korea %d: Model vs Data', year_K));
legend({'Model', 'Data'}, 'Location', 'northwest');