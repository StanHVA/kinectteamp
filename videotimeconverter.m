%% Script om de timestamp om te zetten in een normale tijd.
%vervolgens wordt dat opgeslagen in een CSV. (Ah zo handig)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% voer het pad in voor de file: %%
cd C:\Users\Stan\Documents\Data_Big_Data;
matfile = '20160712t173512-depth-16b-videotime-skeleton.mat';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(matfile);

[rows,cols]=size(videoTime);

for i=1:rows
    %blijf loopen tot einde van rows

    time_converted = videoTime(i,1);
    time_epoch(i,:) = int32(floor(86400 * (datenum(time_converted) - datenum('01-Jan-1970'))));
end

filename=strcat('unix_', matfile, '.csv');

dlmwrite(filename,time_epoch,'precision',10)