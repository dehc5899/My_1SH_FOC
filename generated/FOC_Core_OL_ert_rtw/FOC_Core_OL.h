/*
 * File: FOC_Core_OL.h
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

#ifndef FOC_Core_OL_h_
#define FOC_Core_OL_h_
#ifndef FOC_Core_OL_COMMON_INCLUDES_
#define FOC_Core_OL_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* FOC_Core_OL_COMMON_INCLUDES_ */

#include "FOC_Core_OL_types.h"
#include "foc_shared.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

/* Block states (default storage) for system '<Root>' */
typedef struct {
  real_T Delay_DSTATE;                 /* '<S2>/Delay' */
  uint32_T UnitDelay_DSTATE;           /* '<S2>/Unit Delay' */
} DW_FOC_Core_OL_T;

/* Constant parameters (default storage) */
typedef struct {
  /* Pooled Parameter (Expression: p)
   * Referenced by:
   *   '<Root>/calc_duty_and_samplepoints'
   *   '<S2>/forced angle generator'
   *   '<S2>/the phase sequencer_Updated'
   */
  struct_Av75QoKcngViB8GlIfEOFE pooled1;
} ConstP_FOC_Core_OL_T;

/* External inputs (root inport signals with default storage) */
typedef struct {
  FOC_Inputs_t In;                     /* '<Root>/In' */
} ExtU_FOC_Core_OL_T;

/* External outputs (root outports fed by signals with default storage) */
typedef struct {
  FOC_Outputs_t Out;                   /* '<Root>/Out' */
  FOC_ModelDiag_t Diag;                /* '<Root>/Diag' */
} ExtY_FOC_Core_OL_T;

/* Real-time Model Data Structure */
struct tag_RTM_FOC_Core_OL_T {
  const char_T * volatile errorStatus;
};

/* Block states (default storage) */
extern DW_FOC_Core_OL_T FOC_Core_OL_DW;

/* External inputs (root inport signals with default storage) */
extern ExtU_FOC_Core_OL_T FOC_Core_OL_U;

/* External outputs (root outports fed by signals with default storage) */
extern ExtY_FOC_Core_OL_T FOC_Core_OL_Y;

/* Constant parameters (default storage) */
extern const ConstP_FOC_Core_OL_T FOC_Core_OL_ConstP;

/* Model entry point functions */
extern void FOC_Core_OL_initialize(void);
extern void FOC_Core_OL_step(void);
extern void FOC_Core_OL_terminate(void);

/* Real-time Model object */
extern RT_MODEL_FOC_Core_OL_T *const FOC_Core_OL_M;

/*-
 * These blocks were eliminated from the model due to optimizations:
 *
 * Block '<Root>/Scope' : Unused code path elimination
 * Block '<Root>/Scope2' : Unused code path elimination
 * Block '<Root>/Scope3' : Unused code path elimination
 */

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'FOC_Core_OL'
 * '<S1>'   : 'FOC_Core_OL/SVPWM_minmax'
 * '<S2>'   : 'FOC_Core_OL/Startup'
 * '<S3>'   : 'FOC_Core_OL/calc_duty_and_samplepoints'
 * '<S4>'   : 'FOC_Core_OL/inv_clarke(V)'
 * '<S5>'   : 'FOC_Core_OL/rev_park'
 * '<S6>'   : 'FOC_Core_OL/sector_from_duty'
 * '<S7>'   : 'FOC_Core_OL/Startup/forced angle generator'
 * '<S8>'   : 'FOC_Core_OL/Startup/the phase sequencer_Updated'
 */
#endif                                 /* FOC_Core_OL_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
