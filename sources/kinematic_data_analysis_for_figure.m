% butterworth lowpass filter

fullfilename = left_filename;
%% initialize
% videoReader = VideoReader(fullfilename);


fs = 119.880119323730;

fc = 3;

[b,a]=butter(3, fc/(fs/2));

pos = filtfilt(b,a,R2);



dt = 1/fs;

vel_pos = gradient(pos)/dt;
acc_pos = gradient(vel_pos)/dt;
jerk_pos = gradient(acc_pos)/dt;

point3d_name = [fname1(1:end-4),'_point3d2.mat'];
load(point3d_name)

%% Movement Duration Calculation for pretest

%  [pks,locs] = findpeaks(vel_pretest,fs,'MinPeakHeight',min_peak_height,'MinPeakDistance',min_peak_distance);



% onset_thr=0.01;




[pks_temp,locs_temp] = findpeaks(vel_pos,'MinPeakHeight',0.2,'MinPeakWidth',10,'WidthReference','halfheight');
onset_thr = pks_temp*0.1;
if isempty(locs_temp)
    onset=1;
    offset=length(vel_pos);
    pks_move=0;
    locs_move=round(offset/2);
else
    onset = find(vel_pos(1:locs_temp(1))>0 & vel_pos(1:locs_temp(1))<max(onset_thr),1,'last');
    if isempty(onset)
        onset=0;
    end
    
    offset = locs_temp(end) +find(vel_pos(locs_temp(end):end)<max(onset_thr),1,'first');
    if isempty(offset)
        offset=length(vel_pos);
    end
    
    locs_move = max(locs_temp);
    pks_move=max(pks_temp);
end

%
%
if success(i,ii)==1
    if length(vel_pos)<=601
        vel_pos(end:601)=nan;
    end
    vel_save(:,i)=vel_pos;
    % % subplot(13,1,ii)
    % hp(i)=plot(vel_pos,'Color',[0.5 0.5 0.5]);
    % hold on;
    % hs1(i)=scatter(onset,vel_pos(onset),'r');
    % hs2(i)=scatter(locs_move,vel_pos(locs_move),'c');
    % hs3(i)=scatter(offset,vel_pos(offset),'g');
    %
    % ax=gca;
    % ax.XLim=[0 600];
    % ax.YLim = [0 0.8];
end


L=sum(sqrt(diff(X(onset:offset)).^2 + diff(Y(onset:offset)).^2 + diff(Z(onset:offset)).^2))/1000;

jerk = jerk_pos(onset:offset);
t = (1:length(jerk))*dt;
dmlj=-log(trapz(t,jerk.^2)*(dt*length(jerk))^5/pks_move^2);
clear locs_temp pks_temp vel_pos onset_thr


% accuracy=sqrt((Target_point3d(ii,1)-point3d(end,1)).^2+(Target_point3d(ii,2)-point3d(end,2)).^2+(Target_point3d(ii,3)-point3d(end,3)).^2)/1000;

MT = (offset-onset)'*dt;
MT(MT>=5)=5;

TiiV = (locs_move-onset)'*dt;
PV = pks_move';

PT = offset*dt;
PT(PT>=5)=5;


TTPV_r = TiiV./MT*100;
GT = onset'*dt;
GT(GT>=5)=5;

% accuracy = sqrt(x(offset).^2+(y(offset)-0.2).^2);




MT_save(i,ii)=MT*success(i,ii);
MT_save(MT_save==0)=nan;

GT_save(i,ii)=GT.*success(i,ii);
GT_save(GT_save==0)=nan;

PT_save(i,ii)=PT.*success(i,ii);
PT_save(PT_save==0)=nan;

PV_save(i,ii)=PV*success(i,ii);
PV_save(PV_save==0)=nan;

TTPV_save(i,ii)=TiiV*success(i,ii);
TTPV_save(TTPV_save==0)=nan;

TTPV_r_save(i,ii)=TTPV_r.*success(i,ii);
TTPV_r_save(TTPV_r_save==0)=nan;

dmlj_save(i,ii)=dmlj*success(i,ii);
dmlj_save(dmlj_save==0)=nan;

path_save(i,ii)=L*success(i,ii);
path_save(path_save==0)=nan;
%
% accuracy_save(i,ii)=accuracy.*success(i,ii);
% accuracy_save(accuracy_save==0)=nan;

MT_mean=nanmean(MT_save(:,ii));
GT_mean=nanmean(GT_save(:,ii));
PT_mean=nanmean(PT_save(:,ii));
PV_mean=nanmean(PV_save(:,ii));
TTPV_mean=nanmean(TTPV_save(:,ii));
TTPV_r_mean=nanmean(TTPV_r_save(:,ii));
dmlj_mean=nanmean(dmlj_save(:,ii));

% accuracy_mean=nanmean(accuracy_save);

MT_mean_all(id,ii)=MT_mean;
GT_mean_all(id,ii)=GT_mean;
PT_mean_all(id,ii)=PT_mean;
PV_mean_all(id,ii)=PV_mean;
TTPV_mean_all(id,ii)=TTPV_mean;
TTPV_r_mean_all(id,ii)=TTPV_r_mean;
dmlj_mean_all(id,ii)=dmlj_mean;
% accuracy_mean_all(id,ii)=accuracy_mean;

% MT_combine(ii)=MT_mean;
% GT_combine(ii)=GT_mean;
% PT_combine(ii)=PT_mean;
% PV_combine(ii)=PV_mean;
% TTPV_combine(ii)=TTPV_mean;
% TTPV_r_combine(ii)=TTPV_r_mean;
% dmlj_combine(ii)=dmlj_mean(:,1);
% accuracy_combine(ii)=accuracy_mean;


%% save data

% 
% 
% MT_save(i,ii,id)=MT;
% GT_save(i,ii,id)=GT;
% PT_save(i,ii,id)=PT;
% PV_save(i,ii,id)=PV;
% TTPV_save(i,ii,id)=TTPV;
% TTPV_r_save(i,ii,id)=TTPV_r;
% dmlj_save(i,ii,id)=dmlj;
% accuracy_save(i,ii,id)=accuracy;
% 
% 
% MT_save1(i,id)=MT;
% GT_save1(i,id)=GT;
% PT_save1(i,id)=PT;
% PV_save1(i,id)=PV;
% TiiV_save1(i,id)=TiiV;
% TiiV_r_save1(i,id)=TiiV_r;
% dmlj_save1(i,id)=dmlj;
% accuracy_save1(i,id)=accuracy;

clear MT GT PT PV TiiV TiiV_r dmlj accuracy MT2 GT2 PT2 PV2 TiiV2 TiiV_r2 dmlj2 accuracy2 MT_mean GT_mean PT_mean PV_mean TiiV_mean TiiV_r_mean dmlj_mean accuracy_mean pks_move locs_move onset offset




