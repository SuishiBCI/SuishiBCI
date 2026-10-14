function EEG = demo_SuiEEG_load()
% demo_SuiEEG_load - Load bundled sample BDF and print basic dataset info.
%
% Usage:
%   >> demo_SuiEEG_load
%
% Requires sample_data/demo_recording.bdf in the plugin folder.
% Start EEGLAB first, or ensure SuiEEG_load is on the MATLAB path.

sampleName = 'demo_recording.bdf';
pluginRoot = fileparts(which('pop_SuiEEG_load'));
if isempty(pluginRoot)
    pluginRoot = fileparts(fileparts(mfilename('fullpath')));
    addpath(pluginRoot);
end

sampleFile = fullfile(pluginRoot, 'sample_data', sampleName);
if ~isfile(sampleFile)
    error(['demo_SuiEEG_load: sample file not found:\n  %s\n' ...
        'Copy a BDF file to sample_data/%s and try again.'], sampleFile, sampleName);
end

fprintf('Loading sample BDF...\n  %s\n', sampleFile);
EEG = pop_SuiEEG_load(sampleFile);

fprintf('\nDataset summary\n');
fprintf('  setname : %s\n', EEG.setname);
fprintf('  nbchan  : %d\n', EEG.nbchan);
fprintf('  pnts    : %d\n', EEG.pnts);
fprintf('  trials  : %d\n', EEG.trials);
fprintf('  srate   : %.3f Hz\n', EEG.srate);
if isfield(EEG, 'times') && ~isempty(EEG.times)
    fprintf('  duration: %.2f s\n', EEG.times(end) - EEG.times(1));
end

if exist('pop_eegplot', 'file') == 2
    fprintf('\nOpening EEGLAB data browser (close the figure to continue)...\n');
    pop_eegplot(EEG, 1, 1, 1);
else
    fprintf('\nEEGLAB plotting not available; import succeeded.\n');
end

end
