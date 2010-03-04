# flds1500.py - data fields used in the HCFA 1500 form (see hcfa1500.py)
##############################################################################
#
#   License Terms:
#     same as http://www.python.org/doc/Copyright.html
#
#   (C) Copyright Jeff Bauer 2000.
#     jeffbauer@bigfoot.com
#
# All Rights Reserved
#
# Permission to use, copy, modify, and distribute this software
# and its documentation for any purpose and without fee is hereby
# granted, provided that the above copyright notice appear in all
# copies and that both that copyright notice and this permission
# notice appear in supporting documentation.
#
# Disclaimer
#
# JEFF BAUER DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS,
# IN NO EVENT SHALL ReportLab BE LIABLE FOR ANY SPECIAL, INDIRECT
# OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
# OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
##############################################################################

XYPosition = { \
    'LOC_1_MEDICARE' : (16, 728),
    'LOC_1_MEDICAID' : (68, 728),
    'LOC_1_CHAMPUS' : (120, 728),
    'LOC_1_CHAMPVA' : (178, 728),
    'LOC_1_GROUP' : (228, 728),
    'LOC_1_FECA' : (286, 728),
    'LOC_1_OTHER' : (330, 728),
    'LOC_1A_INSUR_ID' : (370, 728),
    'LOC_2_PT_NAME' : (17, 705),
    'LOC_3_PT_DOB_MM' : (230, 704),
    'LOC_3_PT_DOB_DD' : (252, 704),
    'LOC_3_PT_DOB_YY' : (274, 704),
    'LOC_3_PT_SEX_M' : (311, 705),
    'LOC_3_PT_SEX_F' : (345, 705),
    'LOC_4_INSUR_NAME' : (370, 704),
    'LOC_5_PT_ADDRESS' : (17, 682),
    'LOC_5_PT_CITY' : (17, 658),
    'LOC_5_PT_STATE' : (199, 658),
    'LOC_5_PT_ZIP' : (17, 632),
    'LOC_5_PT_PHONE' : (108, 632),
    'LOC_6_PTREL_SELF' : (244, 682),
    'LOC_6_PTREL_SPOUSE' : (280, 682),
    'LOC_6_PTREL_CHILD' : (311, 682),
    'LOC_6_PTREL_OTHER' : (345, 682),
    'LOC_7_INSUR_ADDRESS' : (370, 682),
    'LOC_7_INSUR_CITY' : (370, 658),
    'LOC_7_INSUR_STATE' : (543, 658),
    'LOC_7_INSUR_ZIP' : (370, 632),
    'LOC_7_INSUR_PHONE' : (462, 632),
    'LOC_8_PT_STATUS_SINGLE' : (257, 657),
    'LOC_8_PT_STATUS_MARRIED' : (302, 657),
    'LOC_8_PT_STATUS_OTHER' : (345, 657),
    'LOC_8_PT_STATUS_EMPLOYED' : (257, 632),
    'LOC_8_PT_STATUS_FULLTIME_STUDENT' : (302, 632),
    'LOC_8_PT_STATUS_PARTTIME_STUDENT' : (345, 632),
    'LOC_9_OTHER_INSUR_NAME' : (17, 608),
    'LOC_9A_OTHER_INSUR_POLICY' : (17, 585),
    'LOC_9B_OTHER_INSUR_DOB_MM' : (20, 560),
    'LOC_9B_OTHER_INSUR_DOB_DD' : (42, 560),
    'LOC_9B_OTHER_INSUR_DOB_YY' : (64, 560),
    'LOC_9B_OTHER_INSUR_SEX_M' : (137, 562),
    'LOC_9B_OTHER_INSUR_SEX_F' : (176, 562),
    'LOC_9C_OTHER_EMPLOYER_SCHOOL' : (17, 538),
    'LOC_9D_OTHER_PLAN_NAME' : (17, 514),
    'LOC_10_PT_COND_EMPLOY_YES' : (257, 587),
    'LOC_10_PT_COND_EMPLOY_NO' : (302, 587),
    'LOC_10_PT_COND_AUTO_YES' : (257, 562),
    'LOC_10_PT_COND_AUTO_NO' : (302, 562),
    'LOC_10_PT_COND_AUTO_PLACE' : (336, 562),
    'LOC_10_PT_COND_OTHER_YES' : (257, 538),
    'LOC_10_PT_COND_OTHER_NO' : (302, 538),
    'LOC_10D_PT_COND' : (224, 514),
    'LOC_11_INSUR_GROUP_NUMBER' : (370, 608),
    'LOC_11A_INSUR_DOB_MM' : (398, 583),
    'LOC_11A_INSUR_DOB_DD' : (418, 583),
    'LOC_11A_INSUR_DOB_YY' : (438, 583),
    'LOC_11A_INSUR_SEX_M' : (494, 585),
    'LOC_11A_INSUR_SEX_F' : (548, 585),
    'LOC_11B_INSUR_EMPLOYER_SCHOOL' : (370, 562),
    'LOC_11C_INSUR_PLAN_NAME' : (370, 538),
    'LOC_11D_INSUR_OTHER_PLAN_YES' : (382, 514),
    'LOC_11D_INSUR_OTHER_PLAN_NO' : (418, 514),
    'LOC_12_PT_SIGNATURE' : (52, 468),
    'LOC_12_PT_DATE' : (258, 468),
    'LOC_13_INSUR_SIGNATURE' : (408, 468),
    'LOC_14_ILLNESS_DATE_MM' : (22, 441),
    'LOC_14_ILLNESS_DATE_DD' : (43, 441),
    'LOC_14_ILLNESS_DATE_YY' : (64, 441),
    'LOC_15_SAME_DATE_MM' : (275, 441),
    'LOC_15_SAME_DATE_DD' : (295, 441),
    'LOC_15_SAME_DATE_YY' : (315, 441),
    'LOC_16_FROM_DATE_MM' : (396, 441),
    'LOC_16_FROM_DATE_DD' : (418, 441),
    'LOC_16_FROM_DATE_YY' : (442, 441),
    'LOC_16_TO_DATE_MM' : (498, 441),
    'LOC_16_TO_DATE_DD' : (520, 441),
    'LOC_16_TO_DATE_YY' : (542, 441),
    'LOC_17_REFER_PHYS_NAME' : (17, 417),
    'LOC_17A_REFER_PHYS_ID' : (208, 417),
    'LOC_18_HOSP_DATE_FROM_MM' : (396, 416),
    'LOC_18_HOSP_DATE_FROM_DD' : (418, 416),
    'LOC_18_HOSP_DATE_FROM_YY' : (442, 416),
    'LOC_18_HOSP_DATE_TO_MM' : (498, 416),
    'LOC_18_HOSP_DATE_TO_DD' : (520, 416),
    'LOC_18_HOSP_DATE_TO_YY' : (542, 416),
    'LOC_19' : (17, 392),
    'LOC_20_OUTSIDE_LAB_YES' : (380, 392),
    'LOC_20_OUTSIDE_LAB_NO' : (418, 392),
    'LOC_20_LAB_CHARGES' : (453, 392),
    'LOC_20_LAB_OTHER' : (521, 392),
    'LOC_21_DIAG1' : (35, 366),
    'LOC_21_DIAG2' : (35, 346),
    'LOC_21_DIAG3' : (228, 366),
    'LOC_21_DIAG4' : (228, 346),
    'LOC_22_MEDICAID_RESUMPTION_CODE' : (382, 366),
    'LOC_22_MEDICAID_ORIGINAL_REF' : (464, 366),
    'LOC_23_PRIOR_AUTHORIZATION' : (382, 343),
    'LOC_24A_1_DATE_FROM_MM' : (18, 293),
    'LOC_24A_1_DATE_FROM_DD' : (38, 293),
    'LOC_24A_1_DATE_FROM_YY' : (58, 293),
    'LOC_24A_1_DATE_TO_MM' : (83, 293),
    'LOC_24A_1_DATE_TO_DD' : (103, 293),
    'LOC_24A_1_DATE_TO_YY' : (123, 293),
    'LOC_24B_1_POS' : (145, 293),
    'LOC_24C_1_TOS' : (166, 293),
    'LOC_24D_1_CPT_HCPCS' : (188, 293),
    'LOC_24D_1_MODIFIER' : (242, 293),
    'LOC_24E_1_DIAGNOSIS' : (318, 293),
    'LOC_24F_1_CHARGE' : (371, 293),
    'LOC_24G_1_UNITS' : (433, 293),
    'LOC_24H_1_EPSDT' : (454, 293),
    'LOC_24I_1_EMG' : (475, 293),
    'LOC_24J_1_COB' : (496, 293),
    'LOC_24K_1_RESERVED' : (520, 293),
    'LOC_24A_2_DATE_FROM_MM' : (18, 269),
    'LOC_24A_2_DATE_FROM_DD' : (38, 269),
    'LOC_24A_2_DATE_FROM_YY' : (58, 269),
    'LOC_24A_2_DATE_TO_MM' : (83, 269),
    'LOC_24A_2_DATE_TO_DD' : (103, 269),
    'LOC_24A_2_DATE_TO_YY' : (123, 269),
    'LOC_24B_2_POS' : (145, 269),
    'LOC_24C_2_TOS' : (166, 269),
    'LOC_24D_2_CPT_HCPCS' : (188, 269),
    'LOC_24D_2_MODIFIER' : (242, 269),
    'LOC_24E_2_DIAGNOSIS' : (318, 269),
    'LOC_24F_2_CHARGE' : (371, 269),
    'LOC_24G_2_UNITS' : (433, 269),
    'LOC_24H_2_EPSDT' : (454, 269),
    'LOC_24I_2_EMG' : (475, 269),
    'LOC_24J_2_COB' : (496, 269),
    'LOC_24K_2_RESERVED' : (520, 269),
    'LOC_24A_3_DATE_FROM_MM' : (18, 245),
    'LOC_24A_3_DATE_FROM_DD' : (38, 245),
    'LOC_24A_3_DATE_FROM_YY' : (58, 245),
    'LOC_24A_3_DATE_TO_MM' : (83, 245),
    'LOC_24A_3_DATE_TO_DD' : (103, 245),
    'LOC_24A_3_DATE_TO_YY' : (123, 245),
    'LOC_24B_3_POS' : (145, 245),
    'LOC_24C_3_TOS' : (166, 245),
    'LOC_24D_3_CPT_HCPCS' : (188, 245),
    'LOC_24D_3_MODIFIER' : (242, 245),
    'LOC_24E_3_DIAGNOSIS' : (318, 245),
    'LOC_24F_3_CHARGE' : (371, 245),
    'LOC_24G_3_UNITS' : (433, 245),
    'LOC_24H_3_EPSDT' : (454, 245),
    'LOC_24I_3_EMG' : (475, 245),
    'LOC_24J_3_COB' : (496, 245),
    'LOC_24K_3_RESERVED' : (520, 245),
    'LOC_24A_4_DATE_FROM_MM' : (18, 221),
    'LOC_24A_4_DATE_FROM_DD' : (38, 221),
    'LOC_24A_4_DATE_FROM_YY' : (58, 221),
    'LOC_24A_4_DATE_TO_MM' : (83, 221),
    'LOC_24A_4_DATE_TO_DD' : (103, 221),
    'LOC_24A_4_DATE_TO_YY' : (123, 221),
    'LOC_24B_4_POS' : (145, 221),
    'LOC_24C_4_TOS' : (166, 221),
    'LOC_24D_4_CPT_HCPCS' : (188, 221),
    'LOC_24D_4_MODIFIER' : (242, 221),
    'LOC_24E_4_DIAGNOSIS' : (318, 221),
    'LOC_24F_4_CHARGE' : (371, 221),
    'LOC_24G_4_UNITS' : (433, 221),
    'LOC_24H_4_EPSDT' : (454, 221),
    'LOC_24I_4_EMG' : (475, 221),
    'LOC_24J_4_COB' : (496, 221),
    'LOC_24K_4_RESERVED' : (520, 221),
    'LOC_24A_5_DATE_FROM_MM' : (18, 197),
    'LOC_24A_5_DATE_FROM_DD' : (38, 197),
    'LOC_24A_5_DATE_FROM_YY' : (58, 197),
    'LOC_24A_5_DATE_TO_MM' : (83, 197),
    'LOC_24A_5_DATE_TO_DD' : (103, 197),
    'LOC_24A_5_DATE_TO_YY' : (123, 197),
    'LOC_24B_5_POS' : (145, 197),
    'LOC_24C_5_TOS' : (166, 197),
    'LOC_24D_5_CPT_HCPCS' : (188, 197),
    'LOC_24D_5_MODIFIER' : (242, 197),
    'LOC_24E_5_DIAGNOSIS' : (318, 197),
    'LOC_24F_5_CHARGE' : (371, 197),
    'LOC_24G_5_UNITS' : (433, 197),
    'LOC_24H_5_EPSDT' : (454, 197),
    'LOC_24I_5_EMG' : (475, 197),
    'LOC_24J_5_COB' : (496, 197),
    'LOC_24K_5_RESERVED' : (520, 197),
    'LOC_24A_6_DATE_FROM_MM' : (18, 173),
    'LOC_24A_6_DATE_FROM_DD' : (38, 173),
    'LOC_24A_6_DATE_FROM_YY' : (58, 173),
    'LOC_24A_6_DATE_TO_MM' : (83, 173),
    'LOC_24A_6_DATE_TO_DD' : (103, 173),
    'LOC_24A_6_DATE_TO_YY' : (123, 173),
    'LOC_24B_6_POS' : (145, 173),
    'LOC_24C_6_TOS' : (166, 173),
    'LOC_24D_6_CPT_HCPCS' : (188, 173),
    'LOC_24D_6_MODIFIER' : (242, 173),
    'LOC_24E_6_DIAGNOSIS' : (318, 173),
    'LOC_24F_6_CHARGE' : (371, 173),
    'LOC_24G_6_UNITS' : (433, 173),
    'LOC_24H_6_EPSDT' : (454, 173),
    'LOC_24I_6_EMG' : (475, 173),
    'LOC_24J_6_COB' : (496, 173),
    'LOC_24K_6_RESERVED' : (520, 173),
    'LOC_25_FED_TAX_ID' : (17, 148),
    'LOC_25_SSN' : (126, 149),
    'LOC_25_EIN' : (142, 149),
    'LOC_26_PT_ACCOUNT_NO' : (173, 148),
    'LOC_27_ASSIGNMENT_YES' : (278, 149),
    'LOC_27_ASSIGNMENT_NO' : (317, 149),
    'LOC_28_TOTAL_CHARGE' : (384, 148),
    'LOC_29_AMOUNT_PAID' : (453, 148),
    'LOC_30_BAL_DUE' : (521, 148),
    'LOC_31_PHYS_SIGN' : (17, 100),
    'LOC_31_PHYS_DATE' : (110, 100),
    'LOC_32_FACILITY_LINE_1': (173, 121),
    'LOC_32_FACILITY_LINE_2': (173, 111),
    'LOC_32_FACILITY_LINE_3': (173, 101),
    'LOC_32_FACILITY_LINE_4': (173, 91),
    'LOC_33_LINE_1': (412, 129),
    'LOC_33_LINE_2': (412, 120),
    'LOC_33_LINE_3': (412, 111),
    'LOC_33_LINE_4': (412, 102),
    'LOC_33_PIN_NUMBER': (388, 91),
    'LOC_33_GROUP_NUMBER': (490, 91),
}

def test_pattern():
    """
    Assign test values to the form by returning a dictionary
    suitable for passing to populate().
    """
    d = {}
    d['LOC_1_MEDICARE'] = 'X'
    d['LOC_1_MEDICAID'] = 'X'
    d['LOC_1_CHAMPUS'] = 'X'
    d['LOC_1_CHAMPVA'] = 'X'
    d['LOC_1_GROUP'] = 'X'
    d['LOC_1_FECA'] = 'X'
    d['LOC_1_OTHER'] = 'X'
    d['LOC_1A_INSUR_ID'] = '125-12-1452-1'
    d['LOC_2_PT_NAME'] = 'XXXXXXXXXXXX, XXXXXXXX X.'
    d['LOC_3_PT_DOB_MM'] = 'XX'
    d['LOC_3_PT_DOB_DD'] = 'XX'
    d['LOC_3_PT_DOB_YY'] = 'XX'
    d['LOC_3_PT_SEX_M'] = 'X'
    d['LOC_3_PT_SEX_F'] = 'X'
    d['LOC_4_INSUR_NAME'] = 'XXXXXXXXXXXX, XXXXXXXX X.'
    d['LOC_5_PT_ADDRESS'] = 'XXX XXXXXXXXXXXXXX XX.'
    d['LOC_5_PT_CITY'] = 'XXXXXXXXXXXXXXXXXX'
    d['LOC_5_PT_STATE'] = 'XX'
    d['LOC_5_PT_ZIP'] = 'XXXXX-XXXX'
    d['LOC_5_PT_PHONE'] = '(XXX) XXX-XXXX'
    d['LOC_6_PTREL_SELF'] = 'X'
    d['LOC_6_PTREL_SPOUSE'] = 'X'
    d['LOC_6_PTREL_CHILD'] = 'X'
    d['LOC_6_PTREL_OTHER'] = 'X'
    d['LOC_7_INSUR_ADDRESS'] = 'XXX XXXXXXXXXXXXXX XX.'
    d['LOC_7_INSUR_CITY'] = 'XXXXXXXXXXXXXXXXXX'
    d['LOC_7_INSUR_STATE'] = 'XX'
    d['LOC_7_INSUR_ZIP'] = 'XXXXX-XXXX'
    d['LOC_7_INSUR_PHONE'] = '(XXX) XXX-XXXX'
    d['LOC_8_PT_STATUS_SINGLE'] = 'X'
    d['LOC_8_PT_STATUS_MARRIED'] = 'X'
    d['LOC_8_PT_STATUS_OTHER'] = 'X'
    d['LOC_8_PT_STATUS_EMPLOYED'] = 'X'
    d['LOC_8_PT_STATUS_FULLTIME_STUDENT'] = 'X'
    d['LOC_8_PT_STATUS_PARTTIME_STUDENT'] = 'X'
    d['LOC_9_OTHER_INSUR_NAME'] = 'XXXXXXXXXXXX, XXXXXXXX X.'
    d['LOC_9A_OTHER_INSUR_POLICY'] = 'XXXXXXXXXXXX'
    d['LOC_9B_OTHER_INSUR_DOB_MM'] = 'XX'
    d['LOC_9B_OTHER_INSUR_DOB_DD'] = 'XX'
    d['LOC_9B_OTHER_INSUR_DOB_YY'] = 'XX'
    d['LOC_9B_OTHER_INSUR_SEX_M'] = 'X'
    d['LOC_9B_OTHER_INSUR_SEX_F'] = 'X'
    d['LOC_9C_OTHER_EMPLOYER_SCHOOL'] = 'XXXXXXXXXXXXXXXXXXXX'
    d['LOC_9D_OTHER_PLAN_NAME'] = 'XXXXXXXXXXXXXXXXXXXX'
    d['LOC_10_PT_COND_EMPLOY_YES'] = 'X'
    d['LOC_10_PT_COND_EMPLOY_NO'] = 'X'
    d['LOC_10_PT_COND_AUTO_YES'] = 'X'
    d['LOC_10_PT_COND_AUTO_NO'] = 'X'
    d['LOC_10_PT_COND_AUTO_PLACE'] = 'XX'
    d['LOC_10_PT_COND_OTHER_YES'] = 'X'
    d['LOC_10_PT_COND_OTHER_NO'] = 'X'
    d['LOC_10D_PT_COND'] = 'XXXXXXXXXXXX'
    d['LOC_11_INSUR_GROUP_NUMBER'] = 'XXXXXXXXXXXX'
    d['LOC_11A_INSUR_DOB_MM'] = 'XX'
    d['LOC_11A_INSUR_DOB_DD'] = 'XX'
    d['LOC_11A_INSUR_DOB_YY'] = 'XX'
    d['LOC_11A_INSUR_SEX_M'] = 'X'
    d['LOC_11A_INSUR_SEX_F'] = 'X'
    d['LOC_11B_INSUR_EMPLOYER_SCHOOL'] = 'XXXXXXXXXXXXXXXXXXXX'
    d['LOC_11C_INSUR_PLAN_NAME'] = 'XXXXXXXXXXXXXXXXXXXX'
    d['LOC_11D_INSUR_OTHER_PLAN_YES'] = 'X'
    d['LOC_11D_INSUR_OTHER_PLAN_NO'] = 'X'
    d['LOC_12_PT_SIGNATURE'] = 'XXXXXXXXXXXXXXXXXXXX'
    d['LOC_12_PT_DATE'] = 'XX/XX/XX'
    d['LOC_13_INSUR_SIGNATURE'] = 'XXXXXXXXXXXXXXXXXXXX'
    d['LOC_14_ILLNESS_DATE_MM'] = 'XX'
    d['LOC_14_ILLNESS_DATE_DD'] = 'XX'
    d['LOC_14_ILLNESS_DATE_YY'] = 'XX'
    d['LOC_15_SAME_DATE_MM'] = 'XX'
    d['LOC_15_SAME_DATE_DD'] = 'XX'
    d['LOC_15_SAME_DATE_YY'] = 'XX'
    d['LOC_16_FROM_DATE_MM'] = 'XX'
    d['LOC_16_FROM_DATE_DD'] = 'XX'
    d['LOC_16_FROM_DATE_YY'] = 'XX'
    d['LOC_16_TO_DATE_MM'] = 'XX'
    d['LOC_16_TO_DATE_DD'] = 'XX'
    d['LOC_16_TO_DATE_YY'] = 'XX'
    d['LOC_17_REFER_PHYS_NAME'] = 'XXXXXXXXXXXXXXXXXXXX'
    d['LOC_17A_REFER_PHYS_ID'] = 'XXXXXX'
    d['LOC_18_HOSP_DATE_FROM_MM'] = 'XX'
    d['LOC_18_HOSP_DATE_FROM_DD'] = 'XX'
    d['LOC_18_HOSP_DATE_FROM_YY'] = 'XX'
    d['LOC_18_HOSP_DATE_TO_MM'] = 'XX'
    d['LOC_18_HOSP_DATE_TO_DD'] = 'XX'
    d['LOC_18_HOSP_DATE_TO_YY'] = 'XX'
    d['LOC_19'] = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    d['LOC_20_OUTSIDE_LAB_YES'] = 'X'
    d['LOC_20_OUTSIDE_LAB_NO'] = 'X'
    d['LOC_20_LAB_CHARGES'] = 'XXXXXXXXX'
    d['LOC_20_LAB_OTHER'] = 'XXXXXXXXX'
    d['LOC_21_DIAG1'] = 'XXX.XX'
    d['LOC_21_DIAG2'] = 'XXX.XX'
    d['LOC_21_DIAG3'] = 'XXX.XX'
    d['LOC_21_DIAG4'] = 'XXX.XX'
    d['LOC_22_MEDICAID_RESUMPTION_CODE'] = 'XXXXXXXXX'
    d['LOC_22_MEDICAID_ORIGINAL_REF'] = 'XXXXXXXXX'
    d['LOC_23_PRIOR_AUTHORIZATION'] = 'XXXXXXXXX'
    d['LOC_24A_1_DATE_FROM_MM'] = 'XX'
    d['LOC_24A_1_DATE_FROM_DD'] = 'XX'
    d['LOC_24A_1_DATE_FROM_YY'] = 'XX'
    d['LOC_24A_1_DATE_TO_MM'] = 'XX'
    d['LOC_24A_1_DATE_TO_DD'] = 'XX'
    d['LOC_24A_1_DATE_TO_YY'] = 'XX'
    d['LOC_24B_1_POS'] = 'XX'
    d['LOC_24C_1_TOS'] = 'XX'
    d['LOC_24D_1_CPT_HCPCS'] = 'XXXXXX'
    d['LOC_24D_1_MODIFIER'] = 'XXXXXXXXXX'
    d['LOC_24E_1_DIAGNOSIS'] = 'XXX.XX'
    d['LOC_24F_1_CHARGE'] = 'XXXXX.XX'
    d['LOC_24G_1_UNITS'] = 'XX'
    d['LOC_24H_1_EPSDT'] = 'XX'
    d['LOC_24I_1_EMG'] = 'XX'
    d['LOC_24J_1_COB'] = 'XX'
    d['LOC_24K_1_RESERVED'] = 'XXXXXXXX'
    d['LOC_24A_2_DATE_FROM_MM'] = 'XX'
    d['LOC_24A_2_DATE_FROM_DD'] = 'XX'
    d['LOC_24A_2_DATE_FROM_YY'] = 'XX'
    d['LOC_24A_2_DATE_TO_MM'] = 'XX'
    d['LOC_24A_2_DATE_TO_DD'] = 'XX'
    d['LOC_24A_2_DATE_TO_YY'] = 'XX'
    d['LOC_24B_2_POS'] = 'XX'
    d['LOC_24C_2_TOS'] = 'XX'
    d['LOC_24D_2_CPT_HCPCS'] = 'XXXXXX'
    d['LOC_24D_2_MODIFIER'] = 'XXXXXXXXXX'
    d['LOC_24E_2_DIAGNOSIS'] = 'XXX.XX'
    d['LOC_24F_2_CHARGE'] = 'XXXXX.XX'
    d['LOC_24G_2_UNITS'] = 'XX'
    d['LOC_24H_2_EPSDT'] = 'XX'
    d['LOC_24I_2_EMG'] = 'XX'
    d['LOC_24J_2_COB'] = 'XX'
    d['LOC_24K_2_RESERVED'] = 'XXXXXXXX'
    d['LOC_24A_3_DATE_FROM_MM'] = 'XX'
    d['LOC_24A_3_DATE_FROM_DD'] = 'XX'
    d['LOC_24A_3_DATE_FROM_YY'] = 'XX'
    d['LOC_24A_3_DATE_TO_MM'] = 'XX'
    d['LOC_24A_3_DATE_TO_DD'] = 'XX'
    d['LOC_24A_3_DATE_TO_YY'] = 'XX'
    d['LOC_24B_3_POS'] = 'XX'
    d['LOC_24C_3_TOS'] = 'XX'
    d['LOC_24D_3_CPT_HCPCS'] = 'XXXXXX'
    d['LOC_24D_3_MODIFIER'] = 'XXXXXXXXXX'
    d['LOC_24E_3_DIAGNOSIS'] = 'XXX.XX'
    d['LOC_24F_3_CHARGE'] = 'XXXXX.XX'
    d['LOC_24G_3_UNITS'] = 'XX'
    d['LOC_24H_3_EPSDT'] = 'XX'
    d['LOC_24I_3_EMG'] = 'XX'
    d['LOC_24J_3_COB'] = 'XX'
    d['LOC_24K_3_RESERVED'] = 'XXXXXXXX'
    d['LOC_24A_4_DATE_FROM_MM'] = 'XX'
    d['LOC_24A_4_DATE_FROM_DD'] = 'XX'
    d['LOC_24A_4_DATE_FROM_YY'] = 'XX'
    d['LOC_24A_4_DATE_TO_MM'] = 'XX'
    d['LOC_24A_4_DATE_TO_DD'] = 'XX'
    d['LOC_24A_4_DATE_TO_YY'] = 'XX'
    d['LOC_24B_4_POS'] = 'XX'
    d['LOC_24C_4_TOS'] = 'XX'
    d['LOC_24D_4_CPT_HCPCS'] = 'XXXXXX'
    d['LOC_24D_4_MODIFIER'] = 'XXXXXXXXXX'
    d['LOC_24E_4_DIAGNOSIS'] = 'XXX.XX'
    d['LOC_24F_4_CHARGE'] = 'XXXXX.XX'
    d['LOC_24G_4_UNITS'] = 'XX'
    d['LOC_24H_4_EPSDT'] = 'XX'
    d['LOC_24I_4_EMG'] = 'XX'
    d['LOC_24J_4_COB'] = 'XX'
    d['LOC_24K_4_RESERVED'] = 'XXXXXXXX'
    d['LOC_24A_5_DATE_FROM_MM'] = 'XX'
    d['LOC_24A_5_DATE_FROM_DD'] = 'XX'
    d['LOC_24A_5_DATE_FROM_YY'] = 'XX'
    d['LOC_24A_5_DATE_TO_MM'] = 'XX'
    d['LOC_24A_5_DATE_TO_DD'] = 'XX'
    d['LOC_24A_5_DATE_TO_YY'] = 'XX'
    d['LOC_24B_5_POS'] = 'XX'
    d['LOC_24C_5_TOS'] = 'XX'
    d['LOC_24D_5_CPT_HCPCS'] = 'XXXXXX'
    d['LOC_24D_5_MODIFIER'] = 'XXXXXXXXXX'
    d['LOC_24E_5_DIAGNOSIS'] = 'XXX.XX'
    d['LOC_24F_5_CHARGE'] = 'XXXXX.XX'
    d['LOC_24G_5_UNITS'] = 'XX'
    d['LOC_24H_5_EPSDT'] = 'XX'
    d['LOC_24I_5_EMG'] = 'XX'
    d['LOC_24J_5_COB'] = 'XX'
    d['LOC_24K_5_RESERVED'] = 'XXXXXXXX'
    d['LOC_24A_6_DATE_FROM_MM'] = 'XX'
    d['LOC_24A_6_DATE_FROM_DD'] = 'XX'
    d['LOC_24A_6_DATE_FROM_YY'] = 'XX'
    d['LOC_24A_6_DATE_TO_MM'] = 'XX'
    d['LOC_24A_6_DATE_TO_DD'] = 'XX'
    d['LOC_24A_6_DATE_TO_YY'] = 'XX'
    d['LOC_24B_6_POS'] = 'XX'
    d['LOC_24C_6_TOS'] = 'XX'
    d['LOC_24D_6_CPT_HCPCS'] = 'XXXXXX'
    d['LOC_24D_6_MODIFIER'] = 'XXXXXXXXXX'
    d['LOC_24E_6_DIAGNOSIS'] = 'XXX.XX'
    d['LOC_24F_6_CHARGE'] = 'XXXXX.XX'
    d['LOC_24G_6_UNITS'] = 'XX'
    d['LOC_24H_6_EPSDT'] = 'XX'
    d['LOC_24I_6_EMG'] = 'XX'
    d['LOC_24J_6_COB'] = 'XX'
    d['LOC_24K_6_RESERVED'] = 'XXXXXXXX'
    d['LOC_25_FED_TAX_ID'] = 'XX-XXXXXXX'
    d['LOC_25_SSN'] = 'X'
    d['LOC_25_EIN'] = 'X'
    d['LOC_26_PT_ACCOUNT_NO'] = 'XXXXXXXX'
    d['LOC_27_ASSIGNMENT_YES'] = 'X'
    d['LOC_27_ASSIGNMENT_NO'] = 'X'
    d['LOC_28_TOTAL_CHARGE'] = 'XXXXXX.XX'
    d['LOC_29_AMOUNT_PAID'] = 'XXXXXX.XX'
    d['LOC_30_BAL_DUE'] = 'XXXXXX.XX'
    d['LOC_31_PHYS_SIGN'] = 'XXXXXXXXXXXXXX'
    d['LOC_31_PHYS_DATE'] = 'XX/XX/XX'
    d['LOC_32_FACILITY_LINE_1'] = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    d['LOC_32_FACILITY_LINE_2'] = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    d['LOC_32_FACILITY_LINE_3'] = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    d['LOC_32_FACILITY_LINE_4'] = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    d['LOC_33_LINE_1'] = 'XXXXXXXXXXXXXXXXXXXXXXXXXXX'
    d['LOC_33_LINE_2'] = 'XXXXXXXXXXXXXXXXXXXXXXXXXXX'
    d['LOC_33_LINE_3'] = 'XXXXXXXXXXXXXXXXXXXXXXXXXXX'
    d['LOC_33_LINE_4'] = 'XXXXXXXXXXXXXXXXXXXXXXXXXXX'
    d['LOC_33_PIN_NUMBER'] = 'XXXXXXXX'
    d['LOC_33_GROUP_NUMBER'] = 'XXXXXXXX'
    return d
