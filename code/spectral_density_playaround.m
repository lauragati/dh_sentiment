% spectral density playaround
% a code for experimenting with looking at frequencies of correlation
% 17 May 2021

clearvars
clc
fs=20; % fontsize

% Example 6.4 in Hamilton, p. 167
% Load in data
url = 'https://fred.stlouisfed.org/';
c = fred(url);

series = 'INDPRO';
metadata = fetch(c,series);
time  = metadata.Data(:,1);
y = metadata.Data(:,2);

% Raw data, time domain (Hamilton, Figure 6.3)
figure
set(gcf,'color','w'); % sets white background color
set(gcf, 'Position', get(0, 'Screensize')); % sets the figure fullscreen
plot(time,y, 'linewidth',2)
ax = gca; % current axes
ax.FontSize = fs;
grid on
grid minor
datetick('x','yyyy', 'keeplimits')
title('Industrial production, Index 2012=100, Seasonally Adjusted, monthly')

% Compute sample periodogram
T = length(y);