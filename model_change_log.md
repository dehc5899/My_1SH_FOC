Simulink Model Change Record
Document ID: 
Version: 1.0.0
Status: Norelease

1. Document Control
	Project Name: MCC_MotorControl_Simulation		
	Safety Level (ASIL): A	
	Responsible Engineer1: Sourav Sahoo	
	Responsible Engineer2: 	
	Reviewer: NA	
	Approver: NA	
	MATLAB Version:R2025b (update 2)	
	Simulink Version: 9.2	
	
2. Change Record Overview
	2.1 Change Identification

	Change ID	CHG-YYYY-XXX
	Related Requirement ID(s)	REQ-XXX
	Related Safety Requirement ID(s)	SAF-XXX
	Related Problem Report ID	PR-XXX
	Related Test Case ID(s)	TC-XXX
	Branch	
	Commit Hash	


	Affected subsystem(s)	-
	2.2 Change Classification

	Select one:

	[]Functional Change

	[]Safety Mechanism Change

	[]Interface Change

	[]Algorithm Modification

	[]Parameter Update

	[]Refactoring (No Functional Change)

	[]Toolchain Impact

	[X]Code Generation Impact

	[]Bug Fix

	[]Performance Optimization

3. Change Description
	3.1 Summary

	SVmodulation subsystem is made automic and referenced model is generated for code generation

	3.2 Detailed Description
	3.2.1 Structural Modifications

	Added/Removed/Modified subsystems:

	Modified signal routing:

	Changed execution order:

	Updated referenced models:SVmodulation subsystem is made automic and referenced model is generated

	3.2.2 Interface Changes
	Interface Element	Previous State	New State	Impact
	Input Signal			
	Output Signal			
	Bus Structure			
	Data Dictionary Entry			
	3.2.3 Parameter Changes
	Parameter	Old Value	New Value	Unit	Safety Relevant (Y/N)
	3.2.4 Algorithm Changes

	Describe mathematical or logical modifications.

	Equations modified:

	Control structure changes:

	State machine modifications:

4. Rationale and Justification
Reason for Change

	-Requirement update

	-Defect correction

	-Safety improvement

	-Performance optimization

	-Refactoring

	-Hardware change

	-Other:

Provide justification.


5. Verification and Validation
	5.1 Verification Activities
	Activity	Performed (Y/N)	Result	Evidence Reference
	Model Review			
	MIL Testing			
	SIL Testing			
	PIL Testing			
	HIL Testing			
	Static Analysis			
	Back-to-Back Test			
	5.2 Test Case Traceability
	Requirement ID	Test Case ID	Result

Summary of results:

6. Review and Approval
Role	Name	Date	Signature
Author			
Reviewer			
Safety Engineer			
Approver			
