function [angleDeg, torqueNm] = ss_load_torque_data(angle_vec_raw, torque_vec_raw)
%SS_LOAD_TORQUE_DATA Processes a raw measured load-torque-vs-mechanical-
% crank-angle dataset into a clean, uniform, periodic lookup table -
% same idea as ss_bemf_data.m applies to its raw measured back-EMF data
% (wrap to one period, de-duplicate, resample onto a uniform grid), just
% for load torque vs MECHANICAL angle instead of back-EMF vs electrical
% angle, and periodicity is enforced by circular padding (wrap a copy of
% the first/last point across the 0/360 boundary) rather than forcing a
% physical zero-crossing (there's no reason load torque should be zero
% anywhere, unlike back-EMF).
%
% Call this ONCE (e.g. in the model's InitFcn, or run manually before
% opening the model) - NOT re-reading your .xlsx here, to keep this
% toolset portable (that file lives outside this repo). Get
% angle_vec_raw/torque_vec_raw from your own mechanicsParameters.m, run
% with tc.gas_condition.experimentdata = 1:
%   [angleDeg, torqueNm] = ss_load_torque_data(tc.Load.angle_vec, tc.Load.torque_vec);
%
% angle_vec_raw, torque_vec_raw : measured crank angle [deg] (any order,
%                                 not necessarily sorted or within
%                                 [0,360]) and torque [Nm]
%
% angleDeg, torqueNm : 0:0.5:360 (721 points) - feed to two Constant
%                      blocks and use with ss_load_torque_lookup.m

angle_wrapped = mod(angle_vec_raw(:), 360);
[angle_wrapped, sortIdx] = sort(angle_wrapped);
torque_wrapped = torque_vec_raw(:);
torque_wrapped = torque_wrapped(sortIdx);

[angle_unique, ~, ic] = unique(angle_wrapped);
if numel(angle_unique) < numel(angle_wrapped)
    torque_unique = accumarray(ic, torque_wrapped, [], @mean);
else
    torque_unique = torque_wrapped;
end
angle_unique = angle_unique(:).';
torque_unique = torque_unique(:).';

% circular padding: wrap the last point back before 0, and the first
% point forward past 360, so interp1 sees continuous periodic data
% straight through the seam instead of needing a special-cased boundary
angle_ext = [angle_unique(end)-360, angle_unique, angle_unique(1)+360];
torque_ext = [torque_unique(end), torque_unique, torque_unique(1)];

angleDeg = 0:0.5:360;
torqueNm = interp1(angle_ext, torque_ext, angleDeg, 'linear');

end
