/*
 * File: FOC_Core_OL_types.h
 *
 * Code generated for Simulink model 'FOC_Core_OL'.
 *
 * Model version                  : 1.290
 * Simulink Coder version         : 25.2 (R2025b) 28-Jul-2025
 * C/C++ source code generated on : Mon Nov  2 22:31:18 2026
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex-M
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef FOC_Core_OL_types_h_
#define FOC_Core_OL_types_h_
#include "foc_shared.h"
#include "rtwtypes.h"
#ifndef DEFINED_TYPEDEF_FOR_struct_Av75QoKcngViB8GlIfEOFE_
#define DEFINED_TYPEDEF_FOR_struct_Av75QoKcngViB8GlIfEOFE_

typedef struct {
  real_T AdvTimClk_Hz;
  real_T AdcClk_Hz;
  real_T PwmFreq_Hz;
  real_T RegulationExecRate;
  real_T IsrFreq_Hz;
  real_T Ts;
  uint32_T PwmPeriodCycles;
  real_T HalfPwmPeriod;
  real_T RepetitionCounter;
  real_T AdcSamplingCycles;
  real_T AdcTrigConvLatencyCyc;
  real_T AdcSarCycles;
  real_T TSample;
  real_T hTADConv;
  real_T DeadTime_ns;
  real_T TNoise_ns;
  real_T TRise_ns;
  real_T TDead;
  real_T TAfter;
  real_T TMin;
  real_T Rshunt;
  real_T Gain;
  real_T Vref;
  real_T AdcFullScaleCounts;
  real_T CurrentConvFactor;
  real_T CurrentConvFactorInv;
  real_T MaxReadableCurrent_A;
  real_T Offset;
  real_T VoltageFullScale;
  real_T IQ_Kp;
  real_T IQ_Ki;
  real_T IQ_KpDiv;
  real_T IQ_KiDiv;
  real_T ID_Kp;
  real_T ID_Ki;
  real_T ID_KpDiv;
  real_T ID_KiDiv;
  real_T PI_OutUpper;
  real_T PI_OutLower;
  real_T PI_IntegUpper;
  real_T PI_IntegLower;
  real_T MotorRS;
  real_T MotorLS;
  real_T Vbus;
  real_T VphasePerUnit;
  real_T VphaseMaxLinear;
  real_T VphaseMax;
  real_T MotorPolePairs;
  real_T ThetaOffset_rad;
  real_T Startup_T[6];
  real_T Startup_RPM[7];
  real_T Startup_Id_A;
  real_T Startup_Iq_Breakaway_A;
  real_T Startup_Iq_A;
  real_T Startup_TransitionDuration;
  real_T Idref_A;
  real_T Iqref_A;
  real_T LoadTorqueMag;
  real_T UseFixedLoad;
  real_T LoadScalingFactor;
  real_T loadRampSlope;
  real_T FFcontrol_en;
  real_T BemfRefRPM;
  real_T BemfRefWe;
  real_T LPF_FILT_CONST;
  real_T LPFAlpha;
  real_T PwmCarrierSamplesPerPeriod;
  real_T FastTs;
  real_T TicksPerFastStep;
  real_T DeadTimeFastSteps;
  real_T AdcTrigAlignSteps;
  real_T IqMax_A;
  real_T SpeedLoopFreq_Hz;
  real_T SpeedExecRate;
  real_T SpeedTs;
  real_T Speed_Kp;
  real_T Speed_Ki;
  real_T Speed_KpDiv;
  real_T Speed_KiDiv;
  real_T SpeedUnitsPerRadS;
  real_T Speed_OutUpper;
  real_T Speed_OutLower;
  real_T Speed_IntegUpper;
  real_T Speed_IntegLower;
  real_T SpeedRef_SlewUp_RPMps;
  real_T SpeedRef_SlewDown_RPMps;
  real_T STO_G1;
  real_T STO_G2;
  real_T PLL_BemfPeak_V;
  real_T PLL_Kp;
  real_T PLL_Ki;
  real_T PLL_KpDiv;
  real_T PLL_KiDiv;
  real_T PLL_WeMax;
  real_T PLL_OutUpper;
  real_T PLL_OutLower;
  real_T PLL_IntegUpper;
  real_T PLL_IntegLower;
  real_T ConvergenceBand_Frac;
  real_T ConvergenceConsecutiveSamples;
  real_T MinStartUpValidSpeed;
  real_T TimingRelaxed;
} struct_Av75QoKcngViB8GlIfEOFE;

#endif

/* Forward declaration for rtModel */
typedef struct tag_RTM_FOC_Core_OL_T RT_MODEL_FOC_Core_OL_T;

#endif                                 /* FOC_Core_OL_types_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
