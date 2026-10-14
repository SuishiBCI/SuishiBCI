function [EEG, command] = pop_SuishiBCI(filename, filepath)
% pop_SuishiBCI - Import BDF/BDF+ into EEGLAB (SuiEEG_load plugin).
%
% Usage:
%   >> EEG = pop_SuishiBCI;
%   >> EEG = pop_SuishiBCI(filename);
%   >> EEG = pop_SuishiBCI(filename, filepath);
%
% Inputs:
%   filename - [string] BDF file name (with extension), or full path if one argument
%   filepath - [string] directory containing the file (default: pwd)
%
% Outputs:
%   EEG      - EEGLAB dataset structure
%   command  - history string for EEGLAB (empty if user cancels file dialog)
%
% Requires private/SuishiBCI_bdf.mex* in this plugin folder.

command = '';
EEG = [];

if nargin < 1
    lastdir = get_last_bdf_dir();
    if isempty(lastdir)
        uidefault = '*.bdf';
    else
        uidefault = fullfile(lastdir, '*.bdf');
    end
    [filename, filepath] = uigetfile({'*.bdf;*.BDF', 'BDF files (*.bdf)'}, ...
        'Choose a BDF file -- pop_SuishiBCI()', uidefault);
    drawnow;
    if isequal(filename, 0) || isequal(filepath, 0)
        return;
    end
elseif nargin == 1
    if ischar(filename) && (contains(filename, filesep) || contains(filename, '/'))
        [filepath, name, ext] = fileparts(filename);
        filename = [name, ext];
    else
        filepath = pwd;
    end
else
    if isempty(filepath)
        filepath = pwd;
    end
end

if iscell(filename)
    if numel(filename) ~= 1
        error('pop_SuishiBCI: only one file per call; loop in your script for batches.');
    end
    filename = filename{1};
end

fpath = fullfile(filepath, filename);
if ~isfile(fpath)
    error('pop_SuishiBCI: file not found: %s', fpath);
end

if exist('SuishiBCI_bdf', 'file') ~= 3
    if ispc
        mexfile = 'private/SuishiBCI_bdf.mexw64';
    elseif isunix
        mexfile = 'private/SuishiBCI_bdf.mexa64';
    else
        mexfile = 'private/SuishiBCI_bdf.mex*';
    end
    error('pop_SuishiBCI: MEX SuishiBCI_bdf not found. Ensure %s exists.', mexfile);
end

EEG = SuishiBCI_bdf(fpath);

[~, EEG.setname, ~] = fileparts(fpath);

if exist('eeg_checkset', 'file') == 2
    EEG = eeg_checkset(EEG);
end

set_last_bdf_dir(filepath);

command = sprintf('EEG = pop_SuishiBCI(''%s'', ''%s'');', ...
    escape_quote(filename), escape_quote(filepath));

end

function dir = get_last_bdf_dir()
dir = '';
prefFile = fullfile(prefdir, 'SuishiBCI_lastdir.mat');
if ~isfile(prefFile)
    return;
end
try
    s = load(prefFile, 'lastdir');
    if isfield(s, 'lastdir') && isfolder(s.lastdir)
        dir = s.lastdir;
    end
catch
end
end

function set_last_bdf_dir(dir)
if nargin < 1 || isempty(dir) || ~isfolder(dir)
    return;
end
try
    lastdir = char(dir);
    save(fullfile(prefdir, 'SuishiBCI_lastdir.mat'), 'lastdir', '-mat');
catch
end
end

% Double single quotes so paths/filenames are safe inside MATLAB string literals.
function s = escape_quote(s)
s = strrep(s, '''', ''''''); % ' -> ''
end
