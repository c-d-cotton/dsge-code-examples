clear

% MATLAB_PREAMBLE_STANDARD.{{{
% Christopher Cotton (c)
% www.cdcotton.com

% Get project directory for this file so I can call script relative to project path, not this script.
% Useful if move script within project.

% First set up project directory dictionary if not exist.
if exist('projectdirdict') == 0
    projectdirdict = containers.Map;
end

if isKey(projectdirdict, mfilename('fullpath')) == 0
    % get projectdir
    curfilesplit = strsplit(mfilename('fullpath'), '/');

    while true
        if length(curfilesplit) > 1
            curfilesplit = curfilesplit(1: (length(curfilesplit) - 1));
        else
            projectdir = 0;
            break
        end

        projectdir = strcat(strjoin(curfilesplit(1:length(curfilesplit)), '/'), '/');
        gitdir = strcat(projectdir, '.git/');
        if exist(gitdir, 'file') == 7
            break
        end
            

    end

    % Add projectdir to dictionary of projectdirs by file
    projectdirdict(mfilename('fullpath')) = projectdir;

    % projectdirdict(mfilename('fullpath')) gives the name of the project directory associated with a file
end

% function to add script's directory to path by giving full filename
if exist('addpath_fullpath') == 0
    addpath_fullpath=@(fullpath) addpath(fileparts(fullpath));
end

% SORT OUT PROJECTDIR
% Perhaps separate call for main and call scripts since want to clear main script.
% MATLAB_PREAMBLE_STANDARD.}}}

% Main Computation of Policy Function:{{{1

syms C Y K A Cp Yp Kp Ap;
syms ALPHA BETA DELTA SIGMA_A RHO

eq1 = 1/C - BETA * (1/Cp) * (ALPHA * Ap * Kp^(ALPHA - 1) + 1 - DELTA);

eq2 = C + Kp - A * K^ALPHA - (1 - DELTA)*K;

eq3 = log(Ap) - RHO * log(A);

eq4 = Y - A * K^ALPHA;

% create function
f = [eq1; eq2; eq3; eq4];

% Define states etc.
x = [A K];
xp = [Ap Kp];
y = [C Y];
yp = [Cp Yp];

variables_in_logs = [A, Ap, K, Kp, C, Cp Y Yp];
f = subs(f, transpose(variables_in_logs), transpose(exp(variables_in_logs)));


approx = 1;

addpath_fullpath(strcat(projectdirdict(mfilename('fullpath')), 'sgu/sgu-firstderiv-codes'));
[fx,fxp,fy,fyp]=anal_deriv(f,x,y,xp,yp,approx);

ETASHOCK = [SIGMA_A; 0];

anal_deriv_print2f(strcat(projectdirdict(mfilename('fullpath')), 'sgu/temp/evaluated'),fx,fxp,fy,fyp,f,ETASHOCK);

ALPHA = 0.3;
BETA = 0.95;
DELTA = 0.1;
SIGMA_A = 0.5;
RHO = 0.9;

Ass = 1;
Kss = ((ALPHA * Ass)/(1/BETA - 1 + DELTA))^(1/(1 - ALPHA));
Css = Ass * Kss^ALPHA - DELTA * Kss;
Yss = Ass * Kss^ALPHA;

Ass = log(Ass);
Kss = log(Kss);
Css = log(Css);
Yss = log(Yss);

A = Ass;
K = Kss;
C = Css;
Y = Yss;
Ap = Ass;
Kp = Kss;
Cp = Css;
Yp = Yss;

% then load file
addpath_fullpath(strcat(projectdirdict(mfilename('fullpath')), 'sgu/temp/'));
evaluated_num_eval

[gx, hx, exitflag] = gx_hx(nfy, nfx, nfyp, nfxp);

disp('print policy functions')
hx
gx

% Additional Computations:{{{1
% Second Moments:{{{2
varshock = nETASHOCK * nETASHOCK';

[sigy0,sigx0]=mom(gx,hx,varshock);
stds = sqrt(diag(sigy0));

% correlations of K and A:
sigx0;

% IRFS:{{{2
ny = 2;
nc = 1;
nk = 4;
na = 3;


%Plot Impulse responses
nx = size(hx,1);
T = 40;             %number of periods for impulse responses
%Give a unit innovation to TFP
x0 = zeros(nx,1);
x0(1) = 0.01; % SHOCKING IR BY 1 PERCENT

IR_IDF = ir(gx,hx,x0,T);
t=(0:T-1)';
fig = figure; 
subplot(3,2,1); plot(t,IR_IDF(:,ny),'r','linewidth',2); title('Output'); xlim([t(1) t(end)])
subplot(3,2,2); plot(t,IR_IDF(:,nc),'r','linewidth',2); title('Consumption'); xlim([t(1) t(end)])
subplot(3,2,3); plot(t,IR_IDF(:,nk),'r','linewidth',2); title('Capital'); xlim([t(1) t(end)])
subplot(3,2,4); plot(t,IR_IDF(:,na),'r','linewidth',2); title('Productivity'); xlim([t(1) t(end)])

saveas(fig, strcat(projectdirdict(mfilename('fullpath')), 'sgu/temp/irfs.jpg'))
