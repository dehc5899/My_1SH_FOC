function [Va, Vb, Vc] = ss_inv_clarke(Valpha, Vbeta)
%SS_INV_CLARKE Inverse Clarke transform - NOT a firmware port (the real
% MCSDK has no such function: PWMC_SetPhaseVoltage() computes SVM duty
% directly from alpha-beta via the fixed-point wX/wY/wZ method, never
% forming Va/Vb/Vc explicitly). This is the bridge WE need because
% ss_svpwm_minmax.m (the SVPWM stage already validated in this build)
% works in the three-phase domain rather than being a byte-for-byte port
% of that alpha-beta-native method (see ss_sector_from_duty.m header).
%
% Derived as the exact algebraic inverse of ss_clarke.m's specific sign
% convention (Ibeta = -(Ia+2*Ib)/sqrt(3), i.e. flipped vs. the "textbook"
% Clarke transform) - NOT copied from a generic inverse-Clarke formula,
% to guarantee round-tripping through ss_clarke.m -> ss_park.m ->
% ss_rev_park.m -> here reproduces the original three phases exactly.
% Verified: ss_inv_clarke(ss_clarke(Ia,Ib)) == [Ia, Ib, Ic] for any Ia,Ib.
%
% Valpha, Vbeta : ss_rev_park.m output (per-unit stationary-frame voltage)
% Va, Vb, Vc    : per-unit three-phase reference voltage, same scale/sign
%                 convention as the Va/Vb/Vc already feeding
%                 ss_svpwm_minmax.m

Va = Valpha;
Vb = -Valpha/2 - (sqrt(3)/2) * Vbeta;
Vc = -Valpha/2 + (sqrt(3)/2) * Vbeta;

end
