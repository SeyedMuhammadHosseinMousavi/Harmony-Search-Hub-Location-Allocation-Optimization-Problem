% Harmony Search Hub Location Allocation Optimization Problem
% Created by Seyed Muhammad Hossein Mousavi - 2022
% mosavi.a.i.buali@gmail.com

%% Clear

clc;
clear;
close all;
warning('off');

%% Variables

model=SelectModel();                        % Select Model
CostFunction=@(xhat) MyCost(xhat,model);    % Cost Function
VarSize=[model.N model.N];      % Decision Variables Matrix Size
nVar=prod(VarSize);             % Number of Decision Variables
VarMin=0;          % Lower Bound of Decision Variables
VarMax=1;          % Upper Bound of Decision Variables

%% Harmony Search 
MaxIt = 300;     % Maximum Number of Iterations
HMS = 60;         % Harmony Memory Size

nNew = 20;        % Number of New Harmonies
HMCR = 0.9;       % Harmony Memory Consideration Rate
PAR = 0.1;        % Pitch Adjustment Rate
FW = 0.02*(VarMax-VarMin);    % Fret Width (Bandwidth)
FW_damp = 0.995;              % Fret Width Damp Ratio

%% Initial

% Empty Harmony Structure
empty_harmony.Position = [];
empty_harmony.Cost = [];
empty_harmony.Sol = [];
% Initialize Harmony Memory
HM = repmat(empty_harmony, HMS, 1);
% Create Initial Harmonies
for i = 1:HMS
HM(i).Position = unifrnd(VarMin, VarMax, VarSize);
[HM(i).Cost HM(i).Sol]= CostFunction(HM(i).Position);
end
% Sort Harmony Memory
[~, SortOrder] = sort([HM.Cost]);
HM = HM(SortOrder);
% Update Best Solution Ever Found
BestSol = HM(1);
% Array to Hold Best Cost Values
BestCost = zeros(MaxIt, 1);

%% Harmony Search Body

for it = 1:MaxIt
% Initialize Array for New Harmonies
NEW = repmat(empty_harmony, nNew, 1);

% Create New Harmonies
for k = 1:nNew
% Create New Harmony Position
NEW(k).Position = unifrnd(VarMin, VarMax, VarSize);
for j = 1:nVar
    if rand <= HMCR
        % Use Harmony Memory
        i = randi([1 HMS]);
        NEW(k).Position(j) = HM(i).Position(j);
    end
    % Pitch Adjustment
    if rand <= PAR
        %DELTA = FW*unifrnd(-1, +1);    % Uniform
        DELTA = FW*randn();            % Gaussian (Normal) 
        NEW(k).Position(j) = NEW(k).Position(j)+DELTA;
    end
end
% Apply Variable Limits
NEW(k).Position = max(NEW(k).Position, VarMin);
NEW(k).Position = min(NEW(k).Position, VarMax);
% Evaluation
[NEW(k).Cost NEW(k).Sol]= CostFunction(NEW(k).Position);
end
% Merge Harmony Memory and New Harmonies
HM = [HM
NEW]; %#ok
% Sort Harmony Memory
[~, SortOrder] = sort([HM.Cost]);
HM = HM(SortOrder);
% Truncate Extra Harmonies
HM = HM(1:HMS);
% Update Best Solution Ever Found
BestSol = HM(1);
% Store Best Cost Ever Found
BestCost(it) = BestSol.Cost;
% Show Iteration Information
disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
% Damp Fret Width
FW = FW*FW_damp;
% Plot it 
figure(1);
PlotSol(BestSol.Sol,model);
pause(0.01);
grid on;
end
title('HS Res');
%% Plot itr
figure;
plot(BestCost,'k','LineWidth', 2);
xlabel('No of Iteration');
ylabel('HS Best Cost');
grid on;
