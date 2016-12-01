clear

%% load mat file consisting of skeleton and depth data of TUG
%cd C:\Users\Stan\Documents\Data_Big_Data;
%matfile = '20160712t173512-depth-16b-videotime-skeleton.mat';
matfile = uigetfile('*.mat','Selecteer een Matlab Bestand');
load(matfile);

filename = inputdlg('Geef een bestandsnaam op', 'Opslaan')

filename = strcat(filename{1,1}, '_xyzScript.csv');

% -> size(bodiesArray) -> 2 antwoorden -> rows, cols

[rows,cols]=size(bodiesArray);

time_start = cell2mat(bodiesArray(1,1));

for i=1:rows
    %blijf loopen tot einde van rows

    time_converted = bodiesArray(i,1);
    time_raw = cell2mat(time_converted) - time_start;
    time_base(i,:) = time_raw/8400;
end

time_double = double(time_base);

clearvars time_converted time_raw time_base

for i=1:rows
    %blijf loopen tot einde van rows
    for s=1:25
        %per sensor
        skip = s * 3 - 2;
        x = skip;
        y = skip + 1;
        z = skip + 2;
        item = bodiesArray{i,2};
        %pos x
        joints_data(i,x) = item.Position(1,s);
        %pos y
        joints_data(i,y) = item.Position(2,s);
        %pos z
        joints_data(i,z) = item.Position(3,s);
    end
    
    clearvars skip x y z s
    
end

clearvars matfile item i cols rows time_start

joints_total = horzcat(time_double, joints_data);

fid = fopen(filename,'wt');
	
fprintf(fid, 'Miliseconds,Spine_base_x,Spine_base_y,Spine_base_z,Spine_mid_x,Spine_mid_y,Spine_mid_z,Neck_x,Neck_y,Neck_z,Head_x,Head_y,Head_z,Shoulder_left_x,Shoulder_left_y,Shoulder_left_z,Elbow_left_x,Elbow_left_y,Elbow_left_z,Wrist_left_x,Wrist_left_y,Wrist_left_z,Hand_left_x,Hand_left_y,Hand_left_z,Shoulder_right_x,Shoulder_right_y,Shoulder_right_z,Elbow_right_x,Elbow_right_y,Elbow_right_z,Wrist_right_x,Wrist_right_y,Wrist_right_z,Hand_right_x,Hand_right_y,Hand_right_z,Hip_left_x,Hip_left_y,Hip_left_z,Knee_left_x,Knee_left_y,Knee_left_z,Ankle_left_x,Ankle_left_y,Ankle_left_z,Foot_left_x,Foot_left_y,Foot_left_z,Hip_right_x,Hip_right_y,Hip_right_z,Knee_right_x,Knee_right_y,Knee_right_z,Ankle_right_x,Ankle_right_y,Ankle_right_z,Foot_right_x,Foot_right_y,Foot_right_z,Spine_shoulder_x,Spine_shoulder_y,Spine_shoulder_z,Handtip_left_x,Handtip_left_y,Handtip_left_z,Thumb_left_x,Thumb_left_y,Thumb_left_z,Handtip_right_x,Handtip_right_y,Handtip_right_z,Thumb_right_x,Thumb_right_y,Thumb_right_z\n');
fclose(fid);

dlmwrite(filename,joints_total,'-append','precision',15);

clearvars ans filename fid joints_data joints_total time_double