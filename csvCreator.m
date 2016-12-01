%% Script om de timestamp om te zetten in een normale tijd.
%vervolgens wordt dat opgeslagen in een CSV. (Ah zo handig)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% voer het pad in voor de file: %%
cd C:\Users\Stan\Documents\Data_Big_Data;
matfile = '20160712t175113-depth-16b-videotime-skeleton.mat';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(matfile);
%%
[rows,cols]=size(bodiesArray);

bodiesArray1 = cell(bodiesArray(:,2));

time_start = cell2mat(bodiesArray(1,1));

for i=1:rows
    %blijf loopen tot einde van rows

    time_converted = bodiesArray(i,1);
    time_raw = cell2mat(time_converted) - time_start;
    time_base(i,:) = time_raw/8400;
end

time_double = double(time_base);

t = 2;
x = 1;
while x < 4

    sensor1 = bodiesArray1{1}.Position(x,1);
    sensor2 = bodiesArray1{1}.Position(x,2);
    sensor3 = bodiesArray1{1}.Position(x,3);
    sensor4 = bodiesArray1{1}.Position(x,4);
    sensor5 = bodiesArray1{1}.Position(x,5);
    sensor6 = bodiesArray1{1}.Position(x,6);
    sensor7 = bodiesArray1{1}.Position(x,7);
    sensor8 = bodiesArray1{1}.Position(x,8);
    sensor9 = bodiesArray1{1}.Position(x,9);
    sensor10 = bodiesArray1{1}.Position(x,10);
    sensor11 = bodiesArray1{1}.Position(x,11);
    sensor12 = bodiesArray1{1}.Position(x,12);
    sensor13 = bodiesArray1{1}.Position(x,13);
    sensor14 = bodiesArray1{1}.Position(x,14);
    sensor15 = bodiesArray1{1}.Position(x,15);
    sensor16 = bodiesArray1{1}.Position(x,16);
    sensor17 = bodiesArray1{1}.Position(x,17);
    sensor18 = bodiesArray1{1}.Position(x,18);
    sensor19 = bodiesArray1{1}.Position(x,19);
    sensor20 = bodiesArray1{1}.Position(x,20);
    sensor21 = bodiesArray1{1}.Position(x,21);
    sensor22 = bodiesArray1{1}.Position(x,22);
    sensor23 = bodiesArray1{1}.Position(x,23);
    sensor24 = bodiesArray1{1}.Position(x,24);
    sensor25 = bodiesArray1{1}.Position(x,25);

    while t <= numel(bodiesArray1)
        sensor1(end+1) = bodiesArray1{t}.Position(x,1);
        sensor2(end+1) = bodiesArray1{t}.Position(x,2);
        sensor3(end+1) = bodiesArray1{t}.Position(x,3);
        sensor4(end+1) = bodiesArray1{t}.Position(x,4);
        sensor5(end+1) = bodiesArray1{t}.Position(x,5);
        sensor6(end+1) = bodiesArray1{t}.Position(x,6);
        sensor7(end+1) = bodiesArray1{t}.Position(x,7);
        sensor8(end+1) = bodiesArray1{t}.Position(x,8);
        sensor9(end+1) = bodiesArray1{t}.Position(x,9);
        sensor10(end+1) = bodiesArray1{t}.Position(x,10);
        sensor11(end+1) = bodiesArray1{t}.Position(x,11);
        sensor12(end+1) = bodiesArray1{t}.Position(x,12);
        sensor13(end+1) = bodiesArray1{t}.Position(x,13);
        sensor14(end+1) = bodiesArray1{t}.Position(x,14);
        sensor15(end+1) = bodiesArray1{t}.Position(x,15);
        sensor16(end+1) = bodiesArray1{t}.Position(x,16);
        sensor17(end+1) = bodiesArray1{t}.Position(x,17);
        sensor18(end+1) = bodiesArray1{t}.Position(x,18);
        sensor19(end+1) = bodiesArray1{t}.Position(x,19);
        sensor20(end+1) = bodiesArray1{t}.Position(x,20);
        sensor21(end+1) = bodiesArray1{t}.Position(x,21);
        sensor22(end+1) = bodiesArray1{t}.Position(x,22);
        sensor23(end+1) = bodiesArray1{t}.Position(x,23);
        sensor24(end+1) = bodiesArray1{t}.Position(x,24);
        sensor25(end+1) = bodiesArray1{t}.Position(x,25);
    
        t = t + 1;
    end
    
    t = 2;
    
    sorcombined = vertcat(sensor1, sensor2, sensor3, sensor4, sensor5, sensor6, sensor7, sensor8, sensor9, sensor10, sensor11, sensor12, sensor13, sensor14, sensor15, sensor16, sensor17, sensor18, sensor19, sensor20, sensor21, sensor22, sensor23, sensor24, sensor25);
    data = transpose(sorcombined);
    
    datawithtime = horzcat(time_double, data);
    
    if x==1
        tested = 'x';
    elseif x==2
        tested = 'y';
    else
        tested = 'z';
    end

    filename=strcat('base_', tested , '_', matfile, '.csv');
    
    
    fid = fopen(filename,'wt');
	
    fprintf(fid, 'Frames,Spine_base,Spine_mid,Neck,Head,Shoulder_left,Elbow_left,Wrist_left,Hand_left,Shoulder_right,Elbow_right,Wrist_right,Hand_right,Hip_left,Knee_left,Ankle_left,Foot_left,Hip_right,Knee_right,Ankle_right,Foot_right,Spine_shoulder,Handtip_left,Thumb_left,Handtip_right,Thumb_right\n');
    fclose(fid);
    
    dlmwrite(filename,datawithtime,'-append','precision',15);
    
    
    clearvars data datawithtime sensor1 sensor2 sensor3 sensor4 sensor5 sensor6 sensor7 sensor8 sensor9 sensor10 sensor11 sensor12 sensor13 sensor14 sensor15 sensor16 sensor17 sensor18 sensor19 sensor20 sensor21 sensor22 sensor23 sensor24 sensor25 sorcombined 
    
    x = x + 1;
end

clearvars bodiesArray1 cols filename i matfile rows t tested time_base time_converted time_double time_raw time_start x