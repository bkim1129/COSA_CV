function [vel_save2,combined_data] = COSA_CV_kinematic_analysis(PID,success_filename,id)
%% Kinematic analysis

% 'PID' is the patient's ID
% 'success_filename' is the name of the excel file containing the data for
% success of the task.
% 'id' is the number assigned to the participant, but it is only necessary
% when you save the data for 

% loads the data from the file 'Target__Loc_save2.mat' into the workspace
load('Target__Loc_save2.mat');

% Initialize arrays to hold the kinematic data for all subjects
MT_save(1:10,1:13)=nan;
GT_save(1:10,1:13)=nan;
PT_save(1:10,1:13)=nan;
PV_save(1:10,1:13)=nan;
TTPV_save(1:10,1:13)=nan;
TTPV_r_save(1:10,1:13)=nan;
dmlj_save(1:10,1:13)=nan;

% Define an array of timepoint labels
timepoints={'base', 'p1_', 'p2_', 'p3_', 'p4_', 'p5_', 'p6_', 'p7_', 'p8_', 'p9_', 'p10_', 'IR', 'DR'};

% Start a timer

tic;

% Loop over all timepoints in the timepoints array
for ii=1:13
    
    % Determine the number of video files to load based on the
    % timepoint index
    if ii>=2 && ii<=11
        utnum=5;
    else
        utnum=10;
    end
    
    % Create a new figure for the current subject and timepoint
    h1=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
    
    % Loop over all trials for the current timepoint
    for i=1:utnum
        
        % Determine the filename of the current video file
        fname1 = [PID,'_Lt_',timepoints{ii},num2str(i),'.mp4'];
        
        % Determine the name of the file containing the 3D position data
        % for the current trial
        Rsave = [fname1(1:end-4),'_R.mat'];
        left_filename = fullfile(fname1);
        
        % Load the left-hand kinematic data from the current video file
        load(Rsave);
        
        % Call the 'success_data_import' function to process the kinematic data
        success = success_data_import2(success_filename,PID);
        
        % Call the 'kinematic_data_analysis_for_figure' function to analyze
        % the kinematic data and create a velocity plot
        kinematic_data_analysis_for_figure;

    end
    
    % Remove any rows from the velocity data where the first element is zero
    vel_save(:,vel_save(1,:)==0)=[];
    
    % Define a vector of time points to use as x-axis labels for the plots
    % based on the length of the variable 'vel_save'
    x_for_label=0:1:length(vel_save)-1;
    
    % Convert the x-axis values to seconds (since the sampling frequency is 120Hz)
    x_for_label=x_for_label/120;
    
    % Plot the mean and standard error of the mean of the velocity data using
    % the 'area' function
    area(x_for_label,mean(vel_save,2)+(std(vel_save')')/sqrt(5),'LineStyle',':','FaceColor',[0.5 0.5 0.5],'FaceAlpha',0.5);
    hold on
    area(x_for_label,mean(vel_save,2)-(std(vel_save')')/sqrt(5),'LineStyle',':','FaceColor',[1 1 1]);
    
    % Plot the velocity data for each trial using a black line
    plot(x_for_label,vel_save,'Color','k','LineWidth',1);
    
    % Plot the mean velocity for each time point in blue
    plot(x_for_label,mean(vel_save,2),'b','LineWidth',5);
    
    hold off
    
    % Customize the plot appearance
    box off
    ax=gca;
    ax.XLim=[0 5]; % Set the x-axis limits to be from 0 to 5 seconds
    ax.YLim = [-0.1 0.8]; % Set the y-axis limits
    xlabel('Time [s]');
    ylabel('Velocity [m/s]');
    ax.LineWidth=5; % Set the line width to be thicker
    ax.FontSize = 36; % Set the font size of the labels
    fig_filename = [PID,'_',timepoints{ii},'.tiff']; % Define the file name for the figure
    print(h1,fig_filename,'-dtiff','-r300') % Save the figure as a TIFF file
   
    % Save the velocity data for each trial in a struct called 'vel_save2'
    vel_save2(ii).data=vel_save;
    
    % Clear the 'vel_save' variable to free up memory for the next iteration of the loop
    clear vel_save    
end

% Create a box plot of the movement duration data ('MT_save')
h2=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');

MT_all_subj(id).data=MT_save;
MT2(:,1)=MT_save(:,1);
MT2(:,2)=nanmean(MT_save(:,2:11),2);
MT2(:,3)=MT_save(:,12);
MT2(:,4)=MT_save(:,13);
boxh=boxplot(MT2);
set(boxh,{'linew'},{2})

% Customize the plot appearance and labels
title([PID,'  Object Movement Duration']);
ax=gca;
ax.XTickLabel = {'Baseline','Practice','Immediate Retention','Delayed Retention'};
ylabel('Time [s]');
xlabel('Time Points');
ax.FontSize=20;
box off;

% Save the figure as a TIFF file
print(h2,[PID,'  Object Movement Duration'],'-dtiff','-r300')

% Repeat the same process for the other variables: 'GT_save', 'PT_save', 'PV_save', and 'dmlj_save'
h2=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');

GT_all_subj(id).data=GT_save;
GT2(:,1)=GT_save(:,1);
GT2(:,2)=nanmean(GT_save(:,2:11),2);
GT2(:,3)=GT_save(:,12);
GT2(:,4)=GT_save(:,13);
boxh=boxplot(GT2);
set(boxh,{'linew'},{2})
title([PID,'  Object Pick-up Duration']);
ax=gca;
ax.XTickLabel = {'Baseline','Practice','Immediate Retention','Delayed Retention'};
ylabel('Time [s]');
xlabel('Time Points');
ax.FontSize=30;
box off;
print(h2,[PID,'  Object Pick-up Duration'],'-dtiff','-r300')

h2=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');

PT_all_subj(id).data=PT_save;
PT2(:,1)=PT_save(:,1);
PT2(:,2)=nanmean(PT_save(:,2:11),2);
PT2(:,3)=PT_save(:,12);
PT2(:,4)=PT_save(:,13);
boxh=boxplot(PT2);
set(boxh,{'linew'},{2})
title([PID,'  Total Performance Duration']);
ax=gca;
ax.XTickLabel = {'Baseline','Practice','Immediate Retention','Delayed Retention'};
ylabel('Time [s]');
xlabel('Time Points');
ax.FontSize=30;
box off;
print(h2,[PID,'  Total Performance Duration'],'-dtiff','-r300')

h2=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');

PV_all_subj(id).data=PV_save;
PV2(:,1)=PV_save(:,1);
PV2(:,2)=nanmean(PV_save(:,2:11),2);
PV2(:,3)=PV_save(:,12);
PV2(:,4)=PV_save(:,13);
boxh=boxplot(PV2);
set(boxh,{'linew'},{2})
title([PID,'  Peak Velocity']);
ax=gca;
ax.XTickLabel = {'Baseline','Practice','Immediate Retention','Delayed Retention'};
ylabel('Velocity [m/s]');
xlabel('Time Points');
ax.FontSize=20;
box off;
print(h2,[PID,'  Peak Velocity'],'-dtiff','-r300')

h2=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');

dmlj_all_subj(id).data=dmlj_save;
dmlj2(:,1)=dmlj_save(:,1);
dmlj2(:,2)=nanmean(dmlj_save(:,2:11),2);
dmlj2(:,3)=dmlj_save(:,12);
dmlj2(:,4)=dmlj_save(:,13);
boxh=boxplot(dmlj2);
set(boxh,{'linew'},{2})
title([PID,'  Jerk']);
ax=gca;
ax.XTickLabel = {'Baseline','Practice','Immediate Retention','Delayed Retention'};
ylabel('Log Dimensionless Jerk');
xlabel('Time Points');
ax.FontSize=20;
box off;
print(h2,[PID,'  Jerk'],'-dtiff','-r300')

combined_data(id).MT = MT_save;
combined_data(id).GT = GT_save;
combined_data(id).PT = PT_save;
combined_data(id).PV = PV_save;
combined_data(id).dmlj = dmlj_save;

% These are for the object trajectory length. 
%     h2=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
%
%     path_all_subj(id).data=path_save;
%     path2(:,1)=path_save(:,1);
%     path2(:,2)=nanmean(path_save(:,2:11),2);
%     path2(:,3)=path_save(:,12);
%     path2(:,4)=path_save(:,13);
%     boxh=boxplot(path2);
%     set(boxh,{'linew'},{2})
%     title([PID,'  Trajectory Length']);
%     ax=gca;
%     ax.XTickLabel = {'Baseline','Practice','Immediate Retention','Delayed Retention'};
%     ylabel('Trajectory Length [m]');
%     xlabel('Time Points');
%     ax.FontSize=20;
%     box off;
%     print(h2,[PID,'  Trajectory Length'],'-dtiff','-r300')
toc
end


