/*
 * File: FOC_Core_OL.c
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

#include "FOC_Core_OL.h"
#include "rtwtypes.h"
#include <math.h>
#include "FOC_Core_OL_private.h"
#include "FOC_Core_OL_types.h"

/* Block states (default storage) */
DW_FOC_Core_OL_T FOC_Core_OL_DW;

/* External inputs (root inport signals with default storage) */
ExtU_FOC_Core_OL_T FOC_Core_OL_U;

/* External outputs (root outports fed by signals with default storage) */
ExtY_FOC_Core_OL_T FOC_Core_OL_Y;

/* Real-time model */
static RT_MODEL_FOC_Core_OL_T FOC_Core_OL_M_;
RT_MODEL_FOC_Core_OL_T *const FOC_Core_OL_M = &FOC_Core_OL_M_;

/* Forward declaration for local functions */
static void FOC_Core_OL_sort(real_T x[3], int32_T idx[3]);
real_T rt_roundd(real_T u)
{
  real_T y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

/* Function for MATLAB Function: '<Root>/sector_from_duty' */
static void FOC_Core_OL_sort(real_T x[3], int32_T idx[3])
{
  real_T b_x_idx_0;
  real_T b_x_idx_1;
  real_T b_x_idx_2;
  b_x_idx_0 = x[0];
  b_x_idx_1 = x[1];
  b_x_idx_2 = x[2];
  if (x[0] <= x[1]) {
    if (x[1] <= x[2]) {
      idx[0] = 1;
      idx[1] = 2;
      idx[2] = 3;
    } else if (x[0] <= x[2]) {
      idx[0] = 1;
      idx[1] = 3;
      idx[2] = 2;
      b_x_idx_1 = x[2];
      b_x_idx_2 = x[1];
    } else {
      idx[0] = 3;
      idx[1] = 1;
      idx[2] = 2;
      b_x_idx_2 = x[1];
      b_x_idx_1 = x[0];
      b_x_idx_0 = x[2];
    }
  } else if (x[0] <= x[2]) {
    idx[0] = 2;
    idx[1] = 1;
    idx[2] = 3;
    b_x_idx_0 = x[1];
    b_x_idx_1 = x[0];
  } else if (x[1] <= x[2]) {
    idx[0] = 2;
    idx[1] = 3;
    idx[2] = 1;
    b_x_idx_0 = x[1];
    b_x_idx_1 = x[2];
    b_x_idx_2 = x[0];
  } else {
    idx[0] = 3;
    idx[1] = 2;
    idx[2] = 1;
    b_x_idx_0 = x[2];
    b_x_idx_2 = x[0];
  }

  x[0] = b_x_idx_0;
  x[1] = b_x_idx_1;
  x[2] = b_x_idx_2;
}

/* Model step function */
void FOC_Core_OL_step(void)
{
  real_T x[7];
  real_T y[7];
  real_T aShiftval[3];
  real_T x_tmp[3];
  real_T b_xtmp;
  real_T r;
  real_T rtb_Gain;
  real_T rtb_we_target;
  real_T submax_mid_deltmin;
  real_T submax_mid_deltmin_tmp;
  real_T submid_min_deltmin;
  real_T submid_min_deltmin_tmp;
  real_T v;
  real_T v0;
  int32_T iidx[3];
  int32_T high_i;
  int32_T low_i;
  int32_T low_ip1;
  int32_T mid_i;
  boolean_T max_bad_flag;
  boolean_T min_bad_flag;

  /* Gain: '<S2>/Gain' incorporates:
   *  UnitDelay: '<S2>/Unit Delay'
   */
  rtb_Gain = 8.0E-5 * (real_T)FOC_Core_OL_DW.UnitDelay_DSTATE;

  /* MATLAB Function: '<S2>/the phase sequencer_Updated' */
  for (high_i = 0; high_i < 7; high_i++) {
    y[high_i] = FOC_Core_OL_ConstP.pooled1.Startup_RPM[high_i] *
      0.31415926535897931;
  }

  x[0] = 0.0;
  for (high_i = 0; high_i < 6; high_i++) {
    x[high_i + 1] = FOC_Core_OL_ConstP.pooled1.Startup_T[high_i];
  }

  r = fmin(rtb_Gain, 0.623);
  if (x[1] < 0.0) {
    x[0] = x[6];
    x[6] = 0.0;
    b_xtmp = y[0];
    y[0] = y[6];
    y[6] = b_xtmp;
    b_xtmp = x[1];
    x[1] = x[5];
    x[5] = b_xtmp;
    b_xtmp = y[1];
    y[1] = y[5];
    y[5] = b_xtmp;
    b_xtmp = x[2];
    x[2] = x[4];
    x[4] = b_xtmp;
    b_xtmp = y[2];
    y[2] = y[4];
    y[4] = b_xtmp;
  }

  rtb_we_target = 0.0;
  if ((r <= x[6]) && (r >= x[0])) {
    high_i = 7;
    low_i = 1;
    low_ip1 = 2;
    while (high_i > low_ip1) {
      mid_i = (low_i + high_i) >> 1;
      if (r >= x[mid_i - 1]) {
        low_i = mid_i;
        low_ip1 = mid_i + 1;
      } else {
        high_i = mid_i;
      }
    }

    b_xtmp = x[low_i - 1];
    r = (r - b_xtmp) / (x[low_i] - b_xtmp);
    if (r == 0.0) {
      rtb_we_target = y[low_i - 1];
    } else if (r == 1.0) {
      rtb_we_target = y[low_i];
    } else if (y[low_i - 1] == y[low_i]) {
      rtb_we_target = y[low_i - 1];
    } else {
      rtb_we_target = (1.0 - r) * y[low_i - 1] + r * y[low_i];
    }
  }

  /* Bias: '<Root>/Bias3' incorporates:
   *  Gain: '<Root>/Gain'
   */
  b_xtmp = 0.00078 * rtb_we_target + 0.11;

  /* Saturate: '<Root>/Saturation' */
  if (b_xtmp > 0.9) {
    b_xtmp = 0.9;
  } else if (b_xtmp < 0.0) {
    b_xtmp = 0.0;
  }

  /* End of Saturate: '<Root>/Saturation' */

  /* MATLAB Function: '<S2>/forced angle generator' incorporates:
   *  Delay: '<S2>/Delay'
   */
  FOC_Core_OL_DW.Delay_DSTATE += rtb_we_target * 8.0E-5;
  r = fabs((FOC_Core_OL_DW.Delay_DSTATE + 3.1415926535897931) /
           6.2831853071795862);
  if (fabs(r - floor(r + 0.5)) > 2.2204460492503131E-16 * r) {
    r = fmod(FOC_Core_OL_DW.Delay_DSTATE + 3.1415926535897931,
             6.2831853071795862);
  } else {
    r = 0.0;
  }

  if (r == 0.0) {
    r = 0.0;
  } else if (r < 0.0) {
    r += 6.2831853071795862;
  }

  FOC_Core_OL_DW.Delay_DSTATE = r - 3.1415926535897931;

  /* End of MATLAB Function: '<S2>/forced angle generator' */

  /* MATLAB Function: '<Root>/rev_park' incorporates:
   *  Delay: '<S2>/Delay'
   */
  r = b_xtmp * sin(FOC_Core_OL_DW.Delay_DSTATE);

  /* MATLAB Function: '<Root>/inv_clarke(V)' incorporates:
   *  Delay: '<S2>/Delay'
   *  MATLAB Function: '<Root>/rev_park'
   */
  rtb_we_target = -r / 2.0;
  v0 = b_xtmp * cos(FOC_Core_OL_DW.Delay_DSTATE) * 0.8660254037844386;
  b_xtmp = rtb_we_target - v0;
  rtb_we_target += v0;

  /* MATLAB Function: '<Root>/SVPWM_minmax' incorporates:
   *  MATLAB Function: '<Root>/inv_clarke(V)'
   */
  v0 = r;
  submax_mid_deltmin = r;
  if (r < b_xtmp) {
    v0 = b_xtmp;
  }

  if (r > b_xtmp) {
    submax_mid_deltmin = b_xtmp;
  }

  if (v0 < rtb_we_target) {
    v0 = rtb_we_target;
  }

  if (submax_mid_deltmin > rtb_we_target) {
    submax_mid_deltmin = rtb_we_target;
  }

  v0 = -(v0 + submax_mid_deltmin) / 2.0;

  /* Rounding: '<Root>/Round' incorporates:
   *  Gain: '<Root>/HalfPwmPeriod'
   *  MATLAB Function: '<Root>/SVPWM_minmax'
   *  MATLAB Function: '<Root>/inv_clarke(V)'
   */
  r = rt_roundd(((r + v0) * 0.5 + 0.5) * 5120.0);

  /* Rounding: '<Root>/Round1' incorporates:
   *  Gain: '<Root>/HalfPwmPeriod1'
   *  MATLAB Function: '<Root>/SVPWM_minmax'
   */
  b_xtmp = rt_roundd(((b_xtmp + v0) * 0.5 + 0.5) * 5120.0);

  /* Rounding: '<Root>/Round2' incorporates:
   *  Gain: '<Root>/HalfPwmPeriod2'
   *  MATLAB Function: '<Root>/SVPWM_minmax'
   */
  rtb_we_target = rt_roundd(((rtb_we_target + v0) * 0.5 + 0.5) * 5120.0);

  /* MATLAB Function: '<Root>/sector_from_duty' incorporates:
   *  MATLAB Function: '<Root>/calc_duty_and_samplepoints'
   */
  x_tmp[0] = r;
  x_tmp[1] = b_xtmp;
  x_tmp[2] = rtb_we_target;
  aShiftval[0] = r;
  aShiftval[1] = b_xtmp;
  aShiftval[2] = rtb_we_target;
  FOC_Core_OL_sort(aShiftval, iidx);

  /* MATLAB Function: '<Root>/calc_duty_and_samplepoints' incorporates:
   *  MATLAB Function: '<Root>/sector_from_duty'
   */
  aShiftval[0] = 0.0;
  aShiftval[1] = 0.0;
  aShiftval[2] = 0.0;
  submax_mid_deltmin_tmp = x_tmp[(int32_T)(((real_T)iidx[1] - 1.0) + 1.0) - 1];
  high_i = (int32_T)(((real_T)iidx[2] - 1.0) + 1.0) - 1;
  v0 = x_tmp[high_i];
  submax_mid_deltmin = (v0 - submax_mid_deltmin_tmp) - 768.0;
  low_i = (int32_T)(((real_T)iidx[0] - 1.0) + 1.0) - 1;
  submid_min_deltmin_tmp = x_tmp[low_i];
  submid_min_deltmin = (submax_mid_deltmin_tmp - submid_min_deltmin_tmp) - 768.0;
  max_bad_flag = false;
  min_bad_flag = false;
  if (submax_mid_deltmin <= 0.0) {
    if (((1.0 - submax_mid_deltmin) + v0) + 512.0 > 5120.0) {
      max_bad_flag = true;
    } else {
      aShiftval[high_i] = 1.0 - submax_mid_deltmin;
    }
  }

  if (submid_min_deltmin <= 0.0) {
    if ((submid_min_deltmin - 1.0) + submid_min_deltmin_tmp < 0.0) {
      min_bad_flag = true;
    } else {
      aShiftval[low_i] = submid_min_deltmin - 1.0;
    }
  }

  if ((!max_bad_flag) && (!min_bad_flag)) {
    submax_mid_deltmin = submax_mid_deltmin_tmp - 512.0;
    v0 = (submax_mid_deltmin_tmp + 768.0) - 512.0;
  } else if (max_bad_flag && min_bad_flag) {
    submax_mid_deltmin = 2560.0;
    v0 = 3584.0;
  } else if (max_bad_flag) {
    submax_mid_deltmin = submax_mid_deltmin_tmp - 512.0;
    v0 = submax_mid_deltmin_tmp + 512.0;
  } else {
    v0 = (submax_mid_deltmin_tmp + 768.0) - 512.0;
    submax_mid_deltmin = submax_mid_deltmin_tmp;
  }

  if (v0 - submax_mid_deltmin < 512.0) {
    submax_mid_deltmin = 2560.0;
    v0 = 3584.0;
  }

  if ((v0 >= 5120.0) || (v0 <= 0.0)) {
    v0 = submax_mid_deltmin_tmp + 512.0;
  }

  if ((submax_mid_deltmin >= 5120.0) || (submax_mid_deltmin <= 0.0)) {
    submax_mid_deltmin = submax_mid_deltmin_tmp;
  }

  /* Saturate: '<Root>/Saturation1' incorporates:
   *  MATLAB Function: '<Root>/calc_duty_and_samplepoints'
   */
  submax_mid_deltmin_tmp = r + aShiftval[0];
  submid_min_deltmin_tmp = b_xtmp + aShiftval[1];
  submid_min_deltmin = rtb_we_target + aShiftval[2];
  if (submax_mid_deltmin_tmp > 5120.0) {
    submax_mid_deltmin_tmp = 5120.0;
  } else if (submax_mid_deltmin_tmp < 0.0) {
    submax_mid_deltmin_tmp = 0.0;
  }

  /* DataTypeConversion: '<Root>/Data Type Conversion2' */
  if (submax_mid_deltmin_tmp < 4.503599627370496E+15) {
    if (submax_mid_deltmin_tmp >= 0.5) {
      submax_mid_deltmin_tmp = floor(submax_mid_deltmin_tmp + 0.5);
    } else {
      submax_mid_deltmin_tmp = 0.0;
    }
  }

  /* Saturate: '<Root>/Saturation1' */
  if (submid_min_deltmin_tmp > 5120.0) {
    submid_min_deltmin_tmp = 5120.0;
  } else if (submid_min_deltmin_tmp < 0.0) {
    submid_min_deltmin_tmp = 0.0;
  }

  /* DataTypeConversion: '<Root>/Data Type Conversion2' */
  if (submid_min_deltmin_tmp < 4.503599627370496E+15) {
    if (submid_min_deltmin_tmp >= 0.5) {
      submid_min_deltmin_tmp = floor(submid_min_deltmin_tmp + 0.5);
    } else {
      submid_min_deltmin_tmp = 0.0;
    }
  }

  /* Saturate: '<Root>/Saturation1' */
  if (submid_min_deltmin > 5120.0) {
    submid_min_deltmin = 5120.0;
  } else if (submid_min_deltmin < 0.0) {
    submid_min_deltmin = 0.0;
  }

  /* DataTypeConversion: '<Root>/Data Type Conversion2' */
  if (submid_min_deltmin < 4.503599627370496E+15) {
    if (submid_min_deltmin >= 0.5) {
      submid_min_deltmin = floor(submid_min_deltmin + 0.5);
    } else {
      submid_min_deltmin = 0.0;
    }
  }

  /* Saturate: '<Root>/Saturation2' incorporates:
   *  MATLAB Function: '<Root>/calc_duty_and_samplepoints'
   */
  r -= aShiftval[0];
  b_xtmp -= aShiftval[1];
  rtb_we_target -= aShiftval[2];
  if (r > 5120.0) {
    r = 5120.0;
  } else if (r < 0.0) {
    r = 0.0;
  }

  /* DataTypeConversion: '<Root>/Data Type Conversion1' */
  if (r < 4.503599627370496E+15) {
    if (r >= 0.5) {
      r = floor(r + 0.5);
    } else {
      r = 0.0;
    }
  }

  /* Saturate: '<Root>/Saturation2' */
  if (b_xtmp > 5120.0) {
    b_xtmp = 5120.0;
  } else if (b_xtmp < 0.0) {
    b_xtmp = 0.0;
  }

  /* DataTypeConversion: '<Root>/Data Type Conversion1' */
  if (b_xtmp < 4.503599627370496E+15) {
    if (b_xtmp >= 0.5) {
      b_xtmp = floor(b_xtmp + 0.5);
    } else {
      b_xtmp = 0.0;
    }
  }

  /* Saturate: '<Root>/Saturation2' */
  if (rtb_we_target > 5120.0) {
    rtb_we_target = 5120.0;
  } else if (rtb_we_target < 0.0) {
    rtb_we_target = 0.0;
  }

  /* DataTypeConversion: '<Root>/Data Type Conversion1' */
  if (rtb_we_target < 4.503599627370496E+15) {
    if (rtb_we_target >= 0.5) {
      rtb_we_target = floor(rtb_we_target + 0.5);
    } else {
      rtb_we_target = 0.0;
    }
  }

  /* DataTypeConversion: '<Root>/Data Type Conversion3' incorporates:
   *  MATLAB Function: '<Root>/calc_duty_and_samplepoints'
   */
  v = fabs(submax_mid_deltmin);
  if (v < 4.503599627370496E+15) {
    if (v >= 0.5) {
      submax_mid_deltmin = floor(submax_mid_deltmin + 0.5);
    } else {
      submax_mid_deltmin = 0.0;
    }
  }

  if (submax_mid_deltmin < 65536.0) {
    if (submax_mid_deltmin >= 0.0) {
      FOC_Core_OL_Y.Out.SP1 = (uint16_T)submax_mid_deltmin;
    } else {
      FOC_Core_OL_Y.Out.SP1 = 0U;
    }
  } else {
    FOC_Core_OL_Y.Out.SP1 = MAX_uint16_T;
  }

  /* End of DataTypeConversion: '<Root>/Data Type Conversion3' */

  /* MATLAB Function: '<S2>/the phase sequencer_Updated' */
  if (rtb_Gain <= 0.2) {
    rtb_Gain = 1.0;
  } else if (rtb_Gain <= 0.22) {
    rtb_Gain = 1.5;
  } else if (rtb_Gain <= 0.62) {
    rtb_Gain = 2.0;
  } else if (rtb_Gain <= 0.621) {
    rtb_Gain = 3.0;
  } else if (rtb_Gain <= 0.622) {
    rtb_Gain = 4.0;
  } else if (rtb_Gain <= 0.623) {
    rtb_Gain = 5.0;
  } else {
    rtb_Gain = 6.0;
  }

  /* DataTypeConversion: '<Root>/Data Type Conversion5' incorporates:
   *  MATLAB Function: '<S2>/the phase sequencer_Updated'
   */
  FOC_Core_OL_Y.Out.ModelState = (uint8_T)floor(rtb_Gain + 0.5);

  /* DataTypeConversion: '<Root>/Data Type Conversion2' */
  if (submax_mid_deltmin_tmp < 65536.0) {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.DutyA_h1 = (uint16_T)submax_mid_deltmin_tmp;
  } else {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.DutyA_h1 = MAX_uint16_T;
  }

  if (submid_min_deltmin_tmp < 65536.0) {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.DutyB_h1 = (uint16_T)submid_min_deltmin_tmp;
  } else {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.DutyB_h1 = MAX_uint16_T;
  }

  if (submid_min_deltmin < 65536.0) {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.DutyC_h1 = (uint16_T)submid_min_deltmin;
  } else {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.DutyC_h1 = MAX_uint16_T;
  }

  /* DataTypeConversion: '<Root>/Data Type Conversion1' */
  if (r < 65536.0) {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.DutyA_h2 = (uint16_T)r;
  } else {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.DutyA_h2 = MAX_uint16_T;
  }

  if (b_xtmp < 65536.0) {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.DutyB_h2 = (uint16_T)b_xtmp;
  } else {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.DutyB_h2 = MAX_uint16_T;
  }

  if (rtb_we_target < 65536.0) {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.DutyC_h2 = (uint16_T)rtb_we_target;
  } else {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.DutyC_h2 = MAX_uint16_T;
  }

  /* DataTypeConversion: '<Root>/Data Type Conversion4' incorporates:
   *  MATLAB Function: '<Root>/calc_duty_and_samplepoints'
   */
  v = fabs(v0);
  if (v < 4.503599627370496E+15) {
    if (v >= 0.5) {
      v0 = floor(v0 + 0.5);
    } else {
      v0 = 0.0;
    }
  }

  if (v0 < 65536.0) {
    if (v0 >= 0.0) {
      /* BusCreator generated from: '<Root>/Out' incorporates:
       *  Outport: '<Root>/Out'
       */
      FOC_Core_OL_Y.Out.SP2 = (uint16_T)v0;
    } else {
      /* BusCreator generated from: '<Root>/Out' incorporates:
       *  Outport: '<Root>/Out'
       */
      FOC_Core_OL_Y.Out.SP2 = 0U;
    }
  } else {
    /* BusCreator generated from: '<Root>/Out' incorporates:
     *  Outport: '<Root>/Out'
     */
    FOC_Core_OL_Y.Out.SP2 = MAX_uint16_T;
  }

  /* End of DataTypeConversion: '<Root>/Data Type Conversion4' */

  /* BusCreator generated from: '<Root>/Out' incorporates:
   *  Constant: '<Root>/Ctrl_Fault'
   *  Constant: '<Root>/PWMEnable'
   *  Outport: '<Root>/Out'
   */
  FOC_Core_OL_Y.Out.Ctrl_Fault = 0U;
  FOC_Core_OL_Y.Out.PWMEnable = 1U;

  /* BusCreator generated from: '<Root>/Diag' incorporates:
   *  Constant: '<Root>/Id'
   *  Constant: '<Root>/Iq'
   *  Constant: '<Root>/SpeedEst'
   *  Outport: '<Root>/Diag'
   */
  FOC_Core_OL_Y.Diag.Id = 0;
  FOC_Core_OL_Y.Diag.Iq = 0;
  FOC_Core_OL_Y.Diag.SpeedEst = 0;

  /* DataTypeConversion: '<Root>/Data Type Conversion' incorporates:
   *  Bias: '<Root>/Bias'
   *  Delay: '<S2>/Delay'
   *  Gain: '<Root>/Gain1'
   */
  rtb_Gain = (FOC_Core_OL_DW.Delay_DSTATE + 3.1415926535897931) *
    10430.378350470453;
  if (rtb_Gain < 65536.0) {
    /* BusCreator generated from: '<Root>/Diag' incorporates:
     *  Outport: '<Root>/Diag'
     */
    FOC_Core_OL_Y.Diag.AngleEst = (uint16_T)rtb_Gain;
  } else {
    /* BusCreator generated from: '<Root>/Diag' incorporates:
     *  Outport: '<Root>/Diag'
     */
    FOC_Core_OL_Y.Diag.AngleEst = MAX_uint16_T;
  }

  /* End of DataTypeConversion: '<Root>/Data Type Conversion' */

  /* BusCreator generated from: '<Root>/Diag' incorporates:
   *  Constant: '<Root>/InterfaceVersion'
   *  Constant: '<Root>/ModelVersion'
   *  Outport: '<Root>/Diag'
   */
  FOC_Core_OL_Y.Diag.InterfaceVersion = 0U;
  FOC_Core_OL_Y.Diag.ModelVersion = 0U;

  /* Switch: '<S2>/Switch' incorporates:
   *  Constant: '<S2>/Constant'
   *  Constant: '<S2>/Constant1'
   *  Inport: '<Root>/In'
   *  Sum: '<S2>/Add'
   *  UnitDelay: '<S2>/Unit Delay'
   */
  if (FOC_Core_OL_U.In.StartStopCmd != 0) {
    FOC_Core_OL_DW.UnitDelay_DSTATE++;
  } else {
    FOC_Core_OL_DW.UnitDelay_DSTATE = 0U;
  }

  /* End of Switch: '<S2>/Switch' */
}

/* Model initialize function */
void FOC_Core_OL_initialize(void)
{
  /* (no initialization code required) */
}

/* Model terminate function */
void FOC_Core_OL_terminate(void)
{
  /* (no terminate code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
