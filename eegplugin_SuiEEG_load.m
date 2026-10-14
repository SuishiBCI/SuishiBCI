function ver = eegplugin_SuiEEG_load(fig, trystrs, catchstrs)
% eegplugin_SuiEEG_load - EEGLAB plugin: import BDF/BDF+ via SuiEEG_load (BDF reader MEX).
%
% EEGLAB loads this file automatically when the plugin folder is on the path.

ver = 'SuiEEG_load1.0';
if nargin < 3
    error('eegplugin_SuiEEG_load requires 3 arguments');
end

if ~exist('pop_SuiEEG_load', 'file')
    p = which('eegplugin_SuiEEG_load');
    p = p(1:strfind(p, 'eegplugin_SuiEEG_load.m') - 1);
    addpath(p);
end

menu = findobj(fig, 'tag', 'import data');
comcnt = [trystrs.no_check '[EEG, LASTCOM] = pop_SuiEEG_load();' catchstrs.new_and_hist];
uimenu(menu, 'label', 'From SuishiBCI data (.bdf)', 'callback', comcnt, ...
    'separator', 'on', 'userdata', 'startup:on');

end
