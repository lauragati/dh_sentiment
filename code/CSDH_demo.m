% CSDH_demo
% a proof of concept, a demo for the CSDH presentation
% 18 May 2021

clearvars
close all
clc

% Add all the relevant paths and grab the codename
this_code = mfilename;
[current_dir, basepath, BC_researchpath,toolpath,export_figpath,figpath,tablepath,datapath] = add_paths;
[fs, lw] = plot_configs;

todays_date = strrep(datestr(today), '-','_');
nowstr = strrep(strrep(strrep(datestr(now), '-','_'), ' ', '_'), ':', '_');
datestr(now)

% Variable stuff ---
print_figs        = 0;
output_table = print_figs;
save_stuff=0;

%% Load data

% Compound sentinment scores
csv_file = [datapath, '/compounds_list.csv'];
sent_scores = csvread(csv_file);

% Load in economic data
url = 'https://fred.stlouisfed.org/';
c = fred(url);

series = 'RTFPNAUSA632NRUG'; % INDPRO, GDPC1, RTFPNAUSA632NRUG (TFP), B4701C0A222NBEA (Hours worked by full-time and part-time employees), 
%CES3000000008 (Average Hourly Earnings of Production and Nonsupervisory Employees, Manufacturin)
metadata = fetch(c,series);
time  = metadata.Data(:,1);
ip = metadata.Data(:,2);

%% 
authors = {'egan', 'ellison', 'french'}';
publication_dates = {'2010', '1952','1977'};
pub_dates = datenum(publication_dates,'yyyy');

corpus = [pub_dates, sent_scores];
corpus_sorted = sort(corpus,1);
% now sort authors according to publication dates:
[~,sortIdx] = sort(pub_dates,1);
authors_sorted = authors(sortIdx);

%% Plot stuff

fig = figure;
set(gcf,'color','w'); % sets white background color
MP = get(0, 'MonitorPositions');
set(gcf,'Position',MP(2,:)) % rows of MP are screensizes of monitor 1, 2 and 3 respectively.
% set(gcf,'Position',[     -2047           1        2048        1152]) % rows of MP are screensizes of monitor 1, 2 and 3 respectively.



yyaxis left
line1= plot(time,ip, 'linewidth',lw);
ax = gca; % current axes
ax.FontSize = fs*0.8;
set(gca,'TickLabelInterpreter', 'latex');
yyaxis right
line2=plot(corpus_sorted(:,1), corpus_sorted(:,2), 'linewidth',lw);
ax = gca; % current axes
ax.FontSize = fs*0.8;
set(gca,'TickLabelInterpreter', 'latex');
grid on
grid minor
datetick('x','yyyy', 'keeplimits')
% title('Sentiment scores against economy','interpreter', 'latex')

% Overall legend
% add legend
Lgnd = legend('show',[line1, line2], 'Total Factor Productivity (TFP)','Sentiment scores', ...
    'location', 'southoutside', 'interpreter', 'latex', 'NumColumns', 2, 'fontsize', 0.8*fs);
legend('boxoff')
Lgnd.Position(1) = 0.30;
Lgnd.Position(2) = 0;

figname = [this_code,'_', series '_', todays_date];
if print_figs ==1
    disp(figname)
    cd(figpath)
    export_fig(figname)
    cd(current_dir)
    close
end