% Exercise 1 (b) - agent 1 lender, agent 2 borrower
clear; close all; clc;

experiment = 2; % <- put experiment number (1 to 3)
% 1. beta increases for the borrower to 0.95
% 2. income of borrower in period 1 increases to 15
% 3. income of lender in period 2 increases to 15

% Base case (Part a)
beta_0 = [0.95; 0.90];
w1_0   = [15; 10];
w2_0   = [5; 20];

if experiment == 1
    beta = [0.95; 0.95];
    w1   = [15; 10];
    w2   = [5; 20];
elseif experiment ==2
    beta = [0.95; 0.90];
    w1   = [15; 15];
    w2   = [5; 20];
elseif experiment == 3
    beta = [0.95; 0.90];
    w1   = [15; 10];
    w2   = [15; 20];
end

% Same for the base case
a_0 = beta_0.*w1_0./(1+beta_0);
b_0 = w2_0./(1+beta_0);
r_0 = sum(b_0)/sum(a_0) - 1;
credit_0 = a_0(1) - b_0(1)/(1+r_0);

% Equilibrium interest rate
a = beta.*w1./(1+beta);
b = w2./(1+beta);
r = sum(b)/sum(a) - 1;

% Optimal consumption
c_today    = (w1 + w2./(1+r)) ./ (1+beta);
c_tomorrow = beta./(1+beta) .* ((1+r).*w1 + w2);

% Saving and credit
s      = w1 - c_today;
credit = s(1);
debt   = -s(2);

% Autarky rates
r_aut = b./a - 1;

% Supply and demand of credit
r_grid = linspace(-0.4,2,30);
supply = a(1) - b(1)./(1+r_grid);          % saving of the lender
demand = -(a(2) - b(2)./(1+r_grid));       % borrowing of the borrower

supply_0 = a_0(1) - b_0(1)./(1+r_grid);    % base case
demand_0 = -(a_0(2) - b_0(2)./(1+r_grid));

figure
plot(r_grid, supply, 'b', 'LineWidth', 2)
hold on
plot(r_grid, demand, 'r', 'LineWidth', 2)
plot(r_grid, supply_0, 'b--', 'LineWidth', 1)
plot(r_grid, demand_0, 'r--', 'LineWidth', 1)
plot(r, credit, 'ko', 'MarkerFaceColor', 'k')
plot(r_0, credit_0, 'ko')
xlabel('Interest rate r')
ylabel('Credit')
legend('Supply of credit (agent 1)', 'Demand for credit (agent 2)', ...
       'Supply, base case', 'Demand, base case', 'Equilibrium', 'Equilibrium, base case')
title(sprintf('Credit market equilibrium - experiment %d', experiment))
grid on

% Results
fprintf('r* = %.4f\n', r)
fprintf('Autarky rates: agent 1 = %.4f, agent 2 = %.4f\n', r_aut(1), r_aut(2))
fprintf('Credit supplied by agent 1 = %.4f\n', credit)
fprintf('Debt of agent 2            = %.4f\n', debt)
fprintf('Agent 1: c1 = %.4f, c2 = %.4f\n', c_today(1), c_tomorrow(1))
fprintf('Agent 2: c1 = %.4f, c2 = %.4f\n', c_today(2), c_tomorrow(2))
fprintf('Check, sum of savings = %.2e\n', sum(s))