% Exercise 1 (a) - agent 1 lender, agent 2 borrower
clear; close all; clc;

beta = [0.95; 0.90];
w1   = [15; 10];
w2   = [5; 20];

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
r_grid = linspace(0, 0.3, 200);
supply = a(1) - b(1)./(1+r_grid);          % saving of the lender
demand = -(a(2) - b(2)./(1+r_grid));       % borrowing of the borrower

figure
plot(r_grid, supply, 'b', 'LineWidth', 2)
hold on
plot(r_grid, demand, 'r', 'LineWidth', 2)
plot(r, credit, 'ko', 'MarkerFaceColor', 'k')
xlabel('Interest rate r')
ylabel('Credit')
legend('Supply of credit (agent 1)', 'Demand for credit (agent 2)', 'Equilibrium')
title('Credit market equilibrium')
grid on

% Results
fprintf('r* = %.4f\n', r)
fprintf('Autarky rates: agent 1 = %.4f, agent 2 = %.4f\n', r_aut(1), r_aut(2))
fprintf('Credit supplied by agent 1 = %.4f\n', credit)
fprintf('Debt of agent 2            = %.4f\n', debt)
fprintf('Agent 1: c1 = %.4f, c2 = %.4f\n', c_today(1), c_tomorrow(1))
fprintf('Agent 2: c1 = %.4f, c2 = %.4f\n', c_today(2), c_tomorrow(2))
fprintf('Check, sum of savings = %.2e\n', sum(s))

