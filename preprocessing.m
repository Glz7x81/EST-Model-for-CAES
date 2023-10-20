% Pre-processing script for the EST Simulink model. This script is invoked
% before the Simulink model starts running (initFcn callback function).

%% Load the supply and demand data

timeUnit   = 's';

supplyFile = "Team29_supply.csv";
supplyUnit = "W";

% load the supply data
Supply = loadSupplyData(supplyFile, timeUnit, supplyUnit);

demandFile = "Team29_demand.csv";
demandUnit = "W";

% load the demand data
Demand = loadDemandData(demandFile, timeUnit, demandUnit);

%% Simulation settings

deltat = 15*unit("min");
stopt  = min([Supply.Timeinfo.End, Demand.Timeinfo.End]);

%% System parameters

% transport to supply
aSupplyTransport = 0.03; % Dissipation coefficient

% heat efficiency of compressor
% specifically what % of energy is lost as heat
aHeatCompressor = 0.07;

% injection system
% energy loss of compressor excluding heat dissipation
% mechanical losses due to friction, pressure loss and pressure drop
aInjection = 0.15; % Dissipation coefficient

%This should be moved to the Preproccsing matlab script
DemandWireLength = 15;

% Efficiency of Air Compressor, which is 0.90
% (1 - a) version is 0.10

% storage system
EStorageMax     = (25/3)*unit("kWh"); % Maximum energy, which is 30 MJ, or 8.333.. kWh
EStorageMin     = 0.000*unit("kWh"); % Minimum energy
EStorageInitial = 0.000*unit("kWh"); % Initial energy
bStorage        = 0.000/unit("s");  % Storage dissipation coefficient

% heat exchanger storage system
% initial energy in heat exchanger
HeatExchangerInitial = 0;

% dissipation of heat energy in storage
bHeatExchanger = 0.001;

% extraction system
aExtraction = 0.80; % Dissipation coefficient
% (1 - 0.20)

% Efficiency of an Alternator, which is 0.95
% 1 / (1 - a) version is 0.49

% transport to demand
aDemandTransport = 0.03; % Dissipation coefficient

% Efficiency is the same as aSupplyTransport, which is 0.82
% 1 / (1 - a) version is 0.45

% Efficiency of Home Electrical Wiring, which is dependent on:
% L = 20 m
% A = 2.5e-06 m^2

% heat supplied to extractor
% SHOULD BE VARIABLE SUCH THAT TEMPERATURE OF AIR IS CONSTANT
% easier approach is to just provide fixed amount of heat energy every time
aHeatGenerator = 0.1;

% PfromStorage = PfromExtraction + PfromHeatExchanger;

%% Time dependent system parameters

% Supply_Data = readmatrix(supplyFile);
% Demand_Data = readmatrix(demandFile);
% 
% Supply_Power = Supply_Data(:,2);
% Demand_Power = Demand_Data(:,2);
% 
% % solarPower = 1500; % Solar panel power output in watts (W)
% voltage = 24; % Assumed Voltage rating of Solar Panel
% wireLength = 20; % Length of the copper wire in meters (m)
% wireArea = 2.5e-6; % Cross-sectional area of the wire in square meters (m²)
% resistivityCopper = 1.68e-8; % Resistivity of copper in ohm-meter (Ω·m)
% wireResistance = (resistivityCopper * wireLength) / wireArea;
% 
% 
% % transport from supply
% current_s = Supply_Power ./ voltage;
% aSupplyTransport = current_s .^ 2 * wireResistance;
% 
% % % injection system
% % aInjection = 0.10;
% % 
% % % extraction system
% % aExtraction = 0.95;
% 
% % transport to demand
% current_d = Demand_Power ./ voltage;
% aDemandTransport = current_d .^ 2 * wireResistance;
