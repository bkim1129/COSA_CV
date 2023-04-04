%% This code detects onset of audio cue in an audio file from the video data.

% Read the audio file and extract one channel
[y, fs] = audioread(filename);
y = mean(y, 2);

% Compute the absolute value of the audio signal
y_abs = abs(y);

% Smooth the audio signal
y_smooth = smoothdata(y_abs);

% Set the sampling frequency
Freq = fs;

% Lowpass filter the audio signal
NyqFreq = Freq/2;
Lowpass = 100;
Wn = Lowpass/NyqFreq;
[B,A] = butter (6,Wn,'low');
y_filt1 = filtfilt(B,A,y_abs);

% Highpass filter the audio signal
Highpass = 10;
Wo = Highpass/NyqFreq;
[D,C] = butter (4,Wo,'high');
y_filt2 = filtfilt(D,C,y_filt1);

% Compute the linear envelope of the audio signal
LP = 10;
Wp = LP/NyqFreq;
[F,E] = butter (4,Wp,'low');
y_env = filtfilt(F,E, y_filt1);

% Find the onset of the audio cue
[pks,locs] = findpeaks(y_env(170000:240000),'MinPeakHeight',0.04);
onset_thr = pks(1)*0.2;
locs_cue_onset = 170000 + find(y_env(170000:locs(1)+170000) < onset_thr, 1, 'last');

% If the first onset detection fails, retry with a different threshold
if isempty(locs_cue_onset)
    onset_thr = pks(2)*0.2;
    locs_cue_onset = 170000 + find(y_env(170000:locs(1)+170000) < onset_thr, 1, 'last');
end

% Plot the linear envelope of the audio signal and the detected onset
plot(y_env)
hold on;
scatter(locs_cue_onset,y_env(locs_cue_onset))





    