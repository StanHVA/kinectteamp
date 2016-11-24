%% Script om de timestamp om te zetten in een normale tijd.
%vervolgens wordt dat opgeslagen in een CSV. (Ah zo handig)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% voer het pad in voor de file: %%
cd C:\Users\Stan\Documents\Data_Big_Data;
matfile = '20160712t173430-depth-16b-videotime-skeleton.mat';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(matfile);

[rows,cols]=size(bodiesArray);

time_start = cell2mat(bodiesArray(1,1));

for i=1:rows
    %blijf loopen tot einde van rows

    time_converted = bodiesArray(i,1);
    time_raw = cell2mat(time_converted) - time_start;
    time_base(i,:) = time_raw/84000;
end

filename=strcat('base_', matfile, '.csv');

dlmwrite(filename,time_base,'precision',10)

clearvars i rows cols time_converted matfile filename time_start