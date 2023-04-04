function rename_files(PID, dirL, dirR, days)
%% Rename files
% This code is automatically move and rename multiple video files for the
% chopstick operation skill assessment. 

% PID is the participant's ID. 
% dirL is the original folder where you store the video files from the left
% camera.
% dirR is the original folder where you store the video files from the
% right camera.
% 'days' is either 1 or 2. If you have a delayed retention test, it would
% be 2. If not, it would be 1.




% Initialize the file name counter
p=1;

% Define the time points for the video files
timepoints={'base', 'p1_', 'p2_', 'p3_', 'p4_', 'p5_', 'p6_', 'p7_', 'p8_', 'p9_', 'p10_', 'IR', 'DR'};

% Loop through the participant IDs
for id=17
    
    % Loop through the time points
    for ii=1:13
        
        % Set the number of utnum based on the time point index
        if ii>=2 && ii<=11
            utnum=5;
        else
            utnum=10;
        end
        
        % Loop through the trials
        for i=1:utnum
            
            % Define the new file name for the left camera video
            fname1{p} = [PID,'_Lt_',timepoints{ii},num2str(i),'.mp4'];
            
            % Define the new file name for the right camera video
            fname2{p} = [PID,'_Rt_',timepoints{ii},num2str(i),'.mp4'];
            
            % Increment the file name counter
            p=p+1;
            
        end
    end
end

% Define the original directories for the left and right camera videos
dir1=dirL;
dir2=dirR;

% Get the list of files in the directories
dir_files1=dir(dirL);
dir_files2=dir(dirR);

% Loop through the files in the left and right camera directories
for k=3:72
    
    %% Left video files
    % Get the original file name
    original_name = fullfile(dir1,dir_files1(k).name);
    
    % Get the new file name
    destination_name = fname1{k-2};
    
    % Rename & move the file
    movefile(original_name,destination_name)
    
    %% Right video files
    % Get the original file name
    original_name = fullfile(dir2,dir_files2(k).name);
    
    % Get the new file name
    destination_name = fname2{k-2};
    
    % Rename & move the file
    movefile(original_name,destination_name)
end

% % Rename the calibration files (not used in this case)
% for k=3
%
%     original_name = fullfile(dir1,dir_files1(k).name);
%
%     destination_name = [PID{id},'_Lt_calib.mp4'];
%
%     movefile(original_name,destination_name)
%
%     original_name = fullfile(dir2,dir_files2(k).name);
%
%     destination_name = [PID{id},'_Rt_calib.mp4'];
%
%     movefile(original_name,destination_name)
% end

%% Second day data
if days==2
    % Get the updated list of files in the directories
    dir_files1=dir(dirL);
    dir_files2=dir(dirR);
    
    % Loop through the files in the left and right camera directories
    for k=3:length(dir_files1)
        
        %% Left video files
        % Get the original file name
        original_name = fullfile(dir1,dir_files1(k).name);
        
        % Get the new file name
        destination_name = fname1{68+k};
        
        % Rename & move the file
        movefile(original_name,destination_name)
        
        %% Right video files
        % Get the original file name
        original_name = fullfile(dir2,dir_files2(k).name);
        
        % Get the new file name
        destination_name = fname2{68+k};
        
        % Rename & move the file
        movefile(original_name,destination_name)
    end
end
end
