%% Exercise 2 (b) - Dynamic comparison: income follows GDP per capita in the data
clear; clc; close all;

excel_file = 'data_korea_turkey.xlsx';
data = readtable(excel_file);

years = data.year;

% Data shares, from percent to fractions
agr_T = data.agr_TUR / 100;
ind_T = data.ind_TUR / 100;
srv_T = data.srv_TUR / 100;
agr_K = data.agr_KOR / 100;
ind_K = data.ind_KOR / 100;
srv_K = data.srv_KOR / 100;

% --- Turkey ----
params.omega_a = 0.0325;
params.omega_m = 0.1621;
params.omega_s = 0.8054;
params.epsilon = 0.75;
params.c_bar_a = -1388;
params.c_bar_m = 0;
params.c_bar_s = 12251;
prices = [1.0, 1.0, 1.0];

% --- Korea ----
params_2.omega_a = 0.0082;
params_2.omega_m = 0.1917;
params_2.omega_s = 0.8001;
params_2.epsilon = 0.75;
params_2.c_bar_a = -1388;
params_2.c_bar_m = 0;
params_2.c_bar_s = 12251;
prices_2 = [1.0, 1.0, 1.0];


w_vector_T = data.gdp_TUR;
w_vector_K = data.gdp_KOR;
N = length(years);

ag_share_vec_T = zeros(N,1);
man_share_vec_T = zeros(N,1);
serv_share_vec_T = zeros(N,1);

ag_share_vec_K = zeros(N,1);
man_share_vec_K = zeros(N,1);
serv_share_vec_K = zeros(N,1);

options = optimoptions('fsolve','Display','none');

% --- Turkey ---
for i = 1:N

    income_T = w_vector_T(i);
    x0_T = [agr_T(i)*income_T; ind_T(i)*income_T; srv_T(i)*income_T; 1];

    [x_solution_T] = fsolve(@(x) solve_consumption_foc(x, income_T, prices, params), x0_T, options);

    ca_T = x_solution_T(1);
    cm_T = x_solution_T(2);
    cs_T = x_solution_T(3);

    total_expenditure_T = prices(1)*ca_T + prices(2)*cm_T + prices(3)*cs_T;
    ag_share_vec_T(i)   = (prices(1) * ca_T) / total_expenditure_T;
    man_share_vec_T(i)  = (prices(2) * cm_T) / total_expenditure_T;
    serv_share_vec_T(i) = (prices(3) * cs_T) / total_expenditure_T;
end

% --- Korea ---
for i = 1:N

    income_K = w_vector_K(i);
    x0_K = [agr_K(i)*income_K; ind_K(i)*income_K; srv_K(i)*income_K; 1];

    [x_solution_K] = fsolve(@(x) solve_consumption_foc(x, income_K, prices_2, params_2), x0_K, options);

    ca_K = x_solution_K(1);
    cm_K = x_solution_K(2);
    cs_K = x_solution_K(3);

    total_expenditure_K = prices_2(1)*ca_K + prices_2(2)*cm_K + prices_2(3)*cs_K;
    ag_share_vec_K(i)   = (prices_2(1) * ca_K) / total_expenditure_K;
    man_share_vec_K(i)  = (prices_2(2) * cm_K) / total_expenditure_K;
    serv_share_vec_K(i) = (prices_2(3) * cs_K) / total_expenditure_K;
end


%% Table: first and last year, model vs data
line = '----------------------------------------------';

fprintf('                      Agri    Manu    Serv\n');
fprintf('%s\n', line);
fprintf('Turkey %d  model    %5.3f   %5.3f   %5.3f\n', years(6), ag_share_vec_T(6), man_share_vec_T(6), serv_share_vec_T(6));
fprintf('Turkey %d  data     %5.3f   %5.3f   %5.3f\n', years(6), agr_T(6), ind_T(6), srv_T(6));
fprintf('%s\n', line);
fprintf('Turkey %d  model    %5.3f   %5.3f   %5.3f\n', years(N), ag_share_vec_T(N), man_share_vec_T(N), serv_share_vec_T(N));
fprintf('Turkey %d  data     %5.3f   %5.3f   %5.3f\n', years(N), agr_T(N), ind_T(N), srv_T(N));
fprintf('%s\n', line);
fprintf('Korea  %d  model    %5.3f   %5.3f   %5.3f\n', years(6), ag_share_vec_K(6), man_share_vec_K(6), serv_share_vec_K(6));
fprintf('Korea  %d  data     %5.3f   %5.3f   %5.3f\n', years(6), agr_K(6), ind_K(6), srv_K(6));
fprintf('%s\n', line);
fprintf('Korea  %d  model    %5.3f   %5.3f   %5.3f\n', years(N), ag_share_vec_K(N), man_share_vec_K(N), serv_share_vec_K(N));
fprintf('Korea  %d  data     %5.3f   %5.3f   %5.3f\n', years(N), agr_K(N), ind_K(N), srv_K(N));
fprintf('%s\n', line);

%% Figure 1: Turkey, model (solid) vs data (dashed), one panel per sector

figure;

subplot(1,3,1);
plot(years, ag_share_vec_T, '-r', 'LineWidth', 2);
hold on;
plot(years, agr_T, '--r', 'LineWidth', 2);
hold off;
title('Agriculture');
xlabel('Year');
ylabel('Share');
legend('Model', 'Data', 'Location', 'best');
grid on;
xlim([years(6) years(N)]);
ylim([0 0.8]);

subplot(1,3,2);
plot(years, man_share_vec_T, '-r', 'LineWidth', 2);
hold on;
plot(years, ind_T, '--r', 'LineWidth', 2);
hold off;
title('Manufacturing');
xlabel('Year');
grid on;
xlim([years(6) years(N)]);
ylim([0 0.8]);

subplot(1,3,3);
plot(years, serv_share_vec_T, '-r', 'LineWidth', 2);
hold on;
plot(years, srv_T, '--r', 'LineWidth', 2);
hold off;
title('Services');
xlabel('Year');
grid on;
xlim([years(6) years(N)]);
ylim([0 0.8]);

sgtitle('Turkey');

%% Figure 2: Korea, model (solid) vs data (dashed), one panel per sector
figure;

subplot(1,3,1);
plot(years, ag_share_vec_K, '-b', 'LineWidth', 2);
hold on;
plot(years, agr_K, '--b', 'LineWidth', 2);
hold off;
title('Agriculture');
xlabel('Year');
ylabel('Share');
legend('Model', 'Data', 'Location', 'best');
grid on;
xlim([years(6) years(N)]);
ylim([0 0.8]);

subplot(1,3,2);
plot(years, man_share_vec_K, '-b', 'LineWidth', 2);
hold on;
plot(years, ind_K, '--b', 'LineWidth', 2);
hold off;
title('Manufacturing');
xlabel('Year');
grid on;
xlim([years(6) years(N)]);
ylim([0 0.8]);

subplot(1,3,3);
plot(years, serv_share_vec_K, '-b', 'LineWidth', 2);
hold on;
plot(years, srv_K, '--b', 'LineWidth', 2);
hold off;
title('Services');
xlabel('Year');
grid on;
xlim([years(6) years(N)]);
ylim([0 0.8]);

sgtitle('Korea');

%% Figure 3
figure;

subplot(3,1,1);
plot(years, ag_share_vec_K, '-b', 'LineWidth', 2);
hold on;
plot(years, ag_share_vec_T, '-r', 'LineWidth', 2);
hold off;
title('Agriculture');
xlabel('Year');
ylabel('Share');
legend('Korea', 'Turkey', 'Location', 'best');
grid on;
xlim([years(6) years(N)]);
ylim([0 0.8]);

subplot(3,1,2);
plot(years, man_share_vec_K, '-b', 'LineWidth', 2);
hold on;
plot(years, man_share_vec_T, '-r', 'LineWidth', 2);
hold off;
title('Manufacturing');
xlabel('Year');
ylabel('Share');
legend('Korea', 'Turkey', 'Location', 'best');
grid on;
xlim([years(6) years(N)]);
ylim([0 0.8]);

subplot(3,1,3);
plot(years, serv_share_vec_K, '-b', 'LineWidth', 2, 'DisplayName', 'Korea');
hold on;
plot(years, serv_share_vec_T, '-r', 'LineWidth', 2, 'DisplayName', 'Turkey');
hold off;
title('Services');
xlabel('Year');
ylabel('Share');
legend('Korea', 'Turkey', 'Location', 'best');
grid on;
xlim([years(6) years(N)]);
ylim([0 0.8]);
