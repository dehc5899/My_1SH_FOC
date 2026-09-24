function theta_next = ss_theta_step(theta_prev, we, Ts)
%SS_THETA_STEP Open-loop electrical angle generator (bench-test stand-in
% for the sensorless STO-PLL observer, sto_pll_speed_pos_fdbk.c, which
% isn't wired into this testbed). Integrates a commanded electrical speed
% `we` [rad/s] once per PWM period and wraps to (-pi, pi], exactly the
% "forced angle" mode used to bring up a current loop before closing the
% speed/position loop on a real drive.
%
% theta_prev : previous period's angle (radians) - feed from a Unit Delay
%              (Z^-1), initial condition 0, same as IaEst/IbEst/IcEst
% we         : commanded electrical speed, rad/s (2*pi*fe)
% Ts         : p.Ts (must match the model's execution rate)

theta_next = theta_prev + we * Ts;
theta_next = mod(theta_next + pi, 2*pi) - pi;

end
