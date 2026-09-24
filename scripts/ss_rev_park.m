function [Valpha, Vbeta] = ss_rev_park(Vd, Vq, theta)
%SS_REV_PARK MATLAB port of MCM_Rev_Park() (Src/mc_math.c, ~lines
% 258-297): Valpha = Vq*cos(theta) + Vd*sin(theta)
%           Vbeta  = -Vq*sin(theta) + Vd*cos(theta)
%
% Exact inverse of ss_park.m under the same convention (verified when
% Park was written: Rev_Park(Park(Ialpha,Ibeta,theta),theta) = Ialpha,
% Ibeta for any theta).
%
% Vd, Vq : synchronous-frame voltage commands (PI controller outputs,
%          already converted to per-unit via p.VoltageFullScale)
% theta  : rotor electrical angle, radians (same theta fed to ss_park.m)

c = cos(theta);
s = sin(theta);

Valpha = Vq * c + Vd * s;
Vbeta  = -Vq * s + Vd * c;

end
