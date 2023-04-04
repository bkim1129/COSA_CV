function COSA_CV_triangulation(PID,time_point_start,time_point_end)
% create cell array with timepoint names
p=1;
timepoints={'base', 'p1_', 'p2_', 'p3_', 'p4_', 'p5_', 'p6_', 'p7_', 'p8_', 'p9_', 'p10_', 'IR', 'DR'};

% loop through each timepoint
for ii=time_point_start:time_point_end
    tic
    
    % set the number of image pairs for each timepoint
    if ii>=2 && ii<=11
        utnum=5;
    else
        utnum=10;
    end
    
    % set the calibration filename based on the current timepoint
    if ii<=12
        calib_left_filename = [PID,'_Lt_Ca2.mat'];
    else
        calib_left_filename = [PID,'_Lt_Ca2.mat'];
    end
    % load the calibration data
    load(calib_left_filename);
    
    % loop through each image pair for the current timepoint
    for i=1:utnum
            
        % set the filenames for the current image pair
        fname1 = [PID,'_Lt_',timepoints{ii},num2str(i),'.mp4'];
        fname2 = [PID,'_Rt_',timepoints{ii},num2str(i),'.mp4'];
        left_filename = fullfile(fname1);
        right_filename = fullfile(fname2);
        
        % load the start frame number for the current image pair
        Frame_start;
        
        % load the saved centroid data for the current image pair
        outputfullFileName = [fname1,'.mat'];
        load(outputfullFileName);
        
        % get the start frame number and set the end frame number to 600 frames after the start frame
        sf=v1_FrameStart;
        end_frame=sf+600;
        
        % if the end frame number exceeds the total number of frames, set the end frame number to the last frame
        if end_frame>length(centroid_save)
            points_Lt = centroid_save(sf:end,:);
        else
            points_Lt=centroid_save(sf:sf+600,:);
        end
        
        % clear the saved centroid data
        clear centroid_save;
        
        % load the saved centroid data for the right image
        outputfullFileName = [fname2,'.mat'];
        load(outputfullFileName);

        % get the start frame number and set the end frame number to 600 frames after the start frame
        sf=v2_FrameStart;
        end_frame=sf+600;
        
        % if the end frame number exceeds the total number of frames, set the end frame number to the last frame
        if end_frame>length(centroid_save)
            points_Rt = centroid_save(sf:end,:);
        else
            points_Rt=centroid_save(sf:sf+600,:);
        end
        
        % clear the saved centroid data
        clear centroid_save;
        
        % make sure both point arrays have the same length
        if length(points_Lt(:,1))>length(points_Rt(:,1))
            points_Lt = points_Lt(1:length(points_Rt),:);
        elseif length(points_Lt)<length(points_Rt)
            points_Rt = points_Rt(1:length(points_Lt),:);
        end
        
        % triangulate the 3D points from the image points and stereo parameters
        point3d = triangulate(points_Lt,points_Rt, stereoParams);

        % Convert point3d to double precision
        point3d=double(point3d);
        
        % Calculate accuracy
        %         accuracy(i,ii)=sqrt((Target_point3d(ii,1)-point3d(end,1)).^2+(Target_point3d(ii,2)-point3d(end,2)).^2+(Target_point3d(ii,3)-point3d(end,3)).^2)/1000;
        
        % Translate the origin to the first object point
        point3d(:,1)=point3d(:,1)-point3d(1,1);
        point3d(:,2)=point3d(:,2)-point3d(1,2);
        point3d(:,3)=point3d(:,3)-point3d(1,3);
        
        
        %% Rotation for correct Z position
        
        % Define rotation angle
        theta=-30;
        
        % Extract X, Y, and Z values from point3d
        x=point3d(:,1);
        y=-point3d(:,2);
        z=-point3d(:,3);
        
        % Rotate X, Y, and Z using rotation matrix
        X = x;
        Y = y*cosd(theta) - z*sind(theta);
        Z = y*sind(theta) + z*cosd(theta);
                
        %% Recalculate distance using rotated 3d position data
        
        % Calculate R using X, Y, and Z
        R =sqrt(X.^2+Y.^2+Z.^2)/1000;
        
        % Create figure
        h1=figure('visible','off');
        
        % Recalculate R2 using original 3d position data
        R2=sqrt(point3d(:,1).^2+point3d(:,2).^2+point3d(:,3).^2)/1000;
        
        % Plot R2
        plot(R2,'LineWidth',3,'Color','k')
        grid on;
        ax=gca;
        ax.XLabel.String={'Frames'};
        ax.YLabel.String={'Distance [m]'};
        ax.FontSize=20;
        ax.YTick=0:0.05:0.25;
        ax.YLim=[0 0.25];
        ax.XTick = 0:200:700;
        ax.XLim = [0 700];
        
        % Save X, Y, and Z values
        point_save2 = [fname1(1:end-4),'_point3d2.mat'];
        save(point_save2,'X','Y','Z');
        
        % Save R2
        Rsave = [fname1(1:end-4),'_R.mat'];
        save(Rsave, 'R2');
        
        % Save figure
        R_fig_name=Rsave(1:end-4);
        print(h1,sprintf(R_fig_name),'-dtiff','-r300')
        close all
        
        % Increment p
        p=p+1;
        
    end
    rot_time(ii)=toc
end

% Save rotation time
writematrix(rot_time,'rotation_time.csv')
end