function ver = eegplugin_SuishiBCI(fig, trystrs, catchstrs)
% eegplugin_SuishiBCI - EEGLAB plugin: import BDF/BDF+ via SuishiBCI (BDF reader MEX).
%
% EEGLAB loads this file automatically when the plugin folder is on the path.

ver = 'SuishiBCI1.0';
if nargin < 3
    error('eegplugin_SuishiBCI requires 3 arguments');
end

if ~exist('pop_SuishiBCI', 'file')
    p = which('eegplugin_SuishiBCI');
    p = p(1:strfind(p, 'eegplugin_SuishiBCI.m') - 1);
    addpath(p);
end

menu = findobj(fig, 'tag', 'import data');
comcnt = [trystrs.no_check '[EEG, LASTCOM] = pop_SuishiBCI();' catchstrs.new_and_hist];
uimenu(menu, 'label', 'From SuishiBCI data (.bdf)', 'callback', comcnt, ...
    'separator', 'on', 'userdata', 'startup:on');

end
