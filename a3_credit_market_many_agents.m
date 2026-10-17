% Exercise 1 (c) - part 1: many agents
clc; clear; close all;

% The two types: first element lender, second element borrower
beta = [0.95; 0.90];
w1   = [15; 10];
w2   = [5; 20];

% a and b of each type (same as part (a))
a = beta.*w1./(1+beta);
b = w2./(1+beta);

% Benchmark: Caso paritetico (50% Lenders, 50% Borrowers)
% Economy with N = 500
n_500 = [250; 250];                                % number of lenders, number of borrowers
r_500 = sum(n_500.*b)/sum(n_500.*a) - 1;           % equilibrium interest rate
s_500 = a - b./(1+r_500);                          % saving of ONE agent of each type
credit_per_lender_500 = s_500(1);
credit_total_500      = n_500(1)*s_500(1);
credit_per_agent_500  = credit_total_500/sum(n_500);

fprintf('N = 500:  r* = %.4f, credit per lender = %.4f, per agent = %.4f, total credit = %.2f\n', ...
        r_500, credit_per_lender_500, credit_per_agent_500, credit_total_500);

% Economy with N = 1000
n_1000 = [500; 500];
r_1000 = sum(n_1000.*b)/sum(n_1000.*a) - 1;
s_1000 = a - b./(1+r_1000);
credit_per_lender_1000 = s_1000(1);
credit_total_1000  = n_1000(1)*s_1000(1);
credit_per_agent_1000  = credit_total_1000/sum(n_1000);

fprintf('N = 1000: r* = %.4f, credit per lender = %.4f, per agent = %.4f, total credit = %.2f\n', ...
        r_1000, credit_per_lender_1000, credit_per_agent_1000, credit_total_1000);

share_lenders = linspace(10, 90, 100);             
theta = share_lenders / 100;                       

r_vec = (theta.*b(1) + (1-theta).*b(2)) ./ (theta.*a(1) + (1-theta).*a(2)) - 1;

s_lender_vec = a(1) - b(1)./(1 + r_vec);

credit_tot_500_vec  = (theta .* 500)  .* s_lender_vec;
credit_tot_1000_vec = (theta .* 1000) .* s_lender_vec;

figure;
% Subplot 1: Interest rate of equilibrium 
subplot(1, 3, 1);
plot(share_lenders, r_vec, 'b-',  'LineWidth', 2.5, 'DisplayName', 'N = 500');
hold on;
plot(share_lenders, r_vec, 'r--', 'LineWidth', 1.8, 'DisplayName', 'N = 1000 (coincide)');
plot(50, r_500, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 7, 'DisplayName', '50% (Part a)');
yline(0, '--k', 'HandleVisibility', 'off');
xlabel('Share of lenders (%)'); 
ylabel('r*'); 
title('Equilibrium interest rate');
legend('Location', 'northeast'); 
grid on;

% Subplot 2: Total quantity of credit
subplot(1, 3, 2);
plot(share_lenders, credit_tot_500_vec,  'b-', 'LineWidth', 2, 'DisplayName', 'N = 500');
hold on;
plot(share_lenders, credit_tot_1000_vec, 'r-', 'LineWidth', 2, 'DisplayName', 'N = 1000');
plot(50, credit_total_500,  'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 7, 'DisplayName', '50% (N = 500)');
plot(50, credit_total_1000, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 7, 'DisplayName', '50% (N = 1000)');
xlabel('Share of lenders (%)'); 
ylabel('Total credit'); 
title('Quantity of credit');
legend('Location', 'northwest'); 
grid on;

% Calculation of credit per agent
credit_per_agent_500_vec  = credit_tot_500_vec  / 500;
credit_per_agent_1000_vec = credit_tot_1000_vec / 1000;

subplot(1, 3, 3);
plot(share_lenders, credit_per_agent_500_vec,  'b-',  'LineWidth', 2.5, 'DisplayName', 'N = 500');
hold on;
plot(share_lenders, credit_per_agent_1000_vec, 'r--', 'LineWidth', 1.8, 'DisplayName', 'N = 1000 (coincide)');
plot(50, credit_per_agent_500,  'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 7, 'DisplayName', '50% (N = 500)');
plot(50, credit_per_agent_1000, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 5, 'DisplayName', '50% (N = 1000)');
xlabel('Share of lenders (%)'); 
ylabel('Credit per agent'); 
title('Credit per agent');
legend('Location', 'northwest'); 
grid on;


%% Part 2: supply and demand for three compositions
r_grid = linspace(-0.4, 0.7, 300);

figure
hold on

% 300 lenders, 700 borrowers (solid lines)
plot(r_grid, 300*(a(1) - b(1)./(1+r_grid)), 'b-', 'LineWidth', 2)
plot(r_grid, 700*(b(2)./(1+r_grid) - a(2)), 'b-', 'LineWidth', 2)

% 500 lenders, 500 borrowers (dashed lines)
plot(r_grid, 500*(a(1) - b(1)./(1+r_grid)), 'r--', 'LineWidth', 2)
plot(r_grid, 500*(b(2)./(1+r_grid) - a(2)), 'r--', 'LineWidth', 2)

% 700 lenders, 300 borrowers (dotted lines)
plot(r_grid, 700*(a(1) - b(1)./(1+r_grid)), 'g:', 'LineWidth', 2)
plot(r_grid, 300*(b(2)./(1+r_grid) - a(2)), 'g:', 'LineWidth', 2)

% The three equilibria
N_Lc  = [300; 500; 700];
N_Bc  = 1000 - N_Lc;
r_eq  = (N_Lc*b(1) + N_Bc*b(2)) ./ (N_Lc*a(1) + N_Bc*a(2)) - 1;
cr_eq = N_Lc.*(a(1) - b(1)./(1+r_eq));
plot(r_eq, cr_eq, 'ko', 'MarkerFaceColor', 'w')

xlabel('Interest rate r')
ylabel('Total credit')
title('Credit market with different shares of lenders (N = 1000)')
legend('Supply, 30% lenders', 'Demand, 70% borrowers', ...
       'Supply, 50% lenders', 'Demand, 50% borrowers', ...
       'Supply, 70% lenders', 'Demand, 30% borrowers', ...
       'Equilibria', 'Location', 'best')
grid on