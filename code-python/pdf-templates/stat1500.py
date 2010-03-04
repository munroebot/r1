# stat1500.py - static elements in the HCFA-1500 form (see hfca1500.py)
##############################################################################
#
#   License Terms:
#     same as http://www.python.org/doc/Copyright.html
#
#	(C) Copyright Jeff Bauer 2000.
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

Helvetica = 'Helvetica'
Helvetica_Bold = 'Helvetica-Bold'
Helvetica_Bold_Oblique = 'Helvetica-BoldOblique'
Helvetica_Oblique = 'Helvetica-Oblique'

helvetica_6_text = [ \
    # top boilerplate
    (38, 752, 'PICA'),
    (540, 752, 'PICA'),
    (480, 818, 'APPROVED OMB-0938-0008'),
    # Locator 1: MEDICARE / MEDICAID / CHAMPUS ...
    (15, 740, '1.'),
    (24, 740, 'MEDICARE'),
    (78, 740, 'MEDICAID'),
    (130, 740, 'CHAMPUS'),
    (186, 740, 'CHAMPVA'),
    (240, 740, 'GROUP'),
    (296, 740, 'FECA'),
    (340, 740, 'OTHER'),
    (240, 735, 'HEALTH PLAN'),
    (296, 735, 'BLK LUNG'),
    # Locator 1a: INSURED'S ID
    (368, 740, "1 a. INSURED'S I.D. NUMBER"),
    (498, 740, "(FOR PROGRAM IN ITEM 1)"),
    # Locator 2
    (15, 718, "2. PATIENT'S NAME (Last Name, First Name, Middle Initial)"),
    # Locator 3
    (220, 718, "3. PATIENT'S BIRTH DATE"),
    (274, 712, "YY"),
    (230, 712, "MM"),
    (254, 712, "DD"),
    (324, 715, "SEX"),
    (300, 706, "M"),
    (336, 706, "F"),
    # Locator 4
    (368, 718, "4. INSURED'S NAME (Last Name, First Name, Middle Initial)"),
    # Locator 5
    (15, 694, "5. PATIENT'S ADDRESS (No. Street)"),
    (15, 671, "CITY"),
    (195, 671, "STATE"),
    (15, 647, "ZIP CODE"),
    (106, 647, "TELEPHONE (Include Area Code)"),
    # Locator 6
    (220, 694, "6. PATIENT RELATIONSHIP TO INSURED"),
    (228, 682, "Self"),
    (256, 682, "Spouse"),
    (292, 682, "Child"),
    (326, 682, "Other"),
    # Locator 7
    (368, 694, "7. INSURED'S ADDRESS (No. Street)"),
    (368, 671, "CITY"),
    (539, 671, "STATE"),
    (368, 647, "ZIP CODE"),
    (460, 647, "TELEPHONE (Include Area Code)"),
    # Locator 8
    (220, 671, "8. PATIENT STATUS"),
    (234, 658, "Single"),
    (276, 658, "Married"),
    (324, 658, "Other"),
    (224, 636, "Employed"),
    (272, 636, "Full-Time"),
    (272, 630, "Student"),
    (314, 636, "Part-Time"),
    (314, 630, "Student"),
    # Locator 9
    (15,621,"9. OTHER INSURED'S NAME (Last Name, First Name, Middle Initial)"),
    (15, 598, "a. OTHER INSURED'S POLICY OR GROUP NUMBER"),
    (15, 574, "b. OTHER INSURED'S DATE OF BIRTH"),
    (22, 568, "MM"),
    (44, 568, "DD"),
    (65, 568, "YY"),
    (150, 571, "SEX"),
    (127, 564, "M"),
    (168, 564, "F"),
    (15, 551, "c. EMPLOYER'S NAME OR SCHOOL NAME"),
    (15, 527, "d. INSURANCE PLAN NAME OR PROGRAM NAME"),
    # Locator 10
    (220, 621, "10. IS PATIENT'S CONDITION RELATED TO:"),
    (220, 600, "a. EMPLOYMENT? (CURRENT OR PREVIOUS)"),
    (268, 586, "YES"),
    (314, 586, "NO"),
    (220, 574, "b. AUTO ACCIDENT?"),
    (322, 574, "PLACE (State)"),
    (268, 561, "YES"),
    (314, 561, "NO"),
    (220, 550, "c. OTHER ACCIDENT?"),
    (268, 537, "YES"),
    (314, 537, "NO"),
    (220, 527, "10 d."),
    # Locator 11
    (368, 621, "11. INSURED'S POLICY GROUP OR FECA NUMBER"),
    (368, 598, "a. INSURED'S DATE OF BIRTH"),
    (398, 592, "MM"),
    (420, 592, "DD"),
    (440, 592, "YY"),
    (518, 595, "SEX"),
    (483, 586, "M"),
    (538, 586, "F"),
    (368, 574, "b. EMPLOYER'S NAME OR SCHOOL NAME"),
    (368, 551, "c. INSURANCE PLAN NAME OR PROGRAM NAME"),
    (368, 527, "d. IS THERE ANOTHER HEALTH BENEFIT PLAN?"),
    (393, 514, "YES"),
    (429, 514, "NO"),
    (476, 514, "return to and complete item 9 a-d."),
    # locator 12
    (15, 496, "12. PATIENT'S OR AUTHORIZED PERSON'S SIGNATURE " \
     "I authorize the release of any medical or other information necessary"),
    (25, 489, "to process this claim. I also request payment of government " \
     "benefits either to myself or to the party who accepts assignment"),
    (25, 482, "below."),
    (24, 466, "SIGNED"),
    (236, 466, "DATE"),
    # locator 13
    (368, 503, "13. INSURED'S OR AUTHORIZED PERSON'S SIGNATURE  I authorize"),
    (378, 496, "payment of medical benefits to the undersigned physician " \
     "supplier for"),
    (378, 489, "services described below."),
    (378, 466, "SIGNED"),
    # locator 14
    (15, 455, "14. DATE OF CURRENT:"),
    (66, 449, "YY"),
    (22, 449, "MM"),
    (45, 449, "DD"),
    (102, 455, "ILLNESS (First symptom) OR"),
    (102, 448, "INJURY (Accident) OR"),
    (102, 441, "PREGNANCY (LMP)"),
    # locator 15
    (204, 455, "15. IF PATIENT HAS HAD SAME OR SIMILAR ILLNESS"),
    (214, 448, "GIVE FIRST DATE"),
    (272, 449, "MM"),
    (295, 449, "DD"),
    (315, 449, "YY"),
    # locator 16
    (368, 455, "16. DATES PATIENT UNABLE TO WORK IN CURRENT OCCUPATION"),
    (374, 441, "FROM"),
    (396, 449, "MM"),
    (420, 449, "DD"),
    (442, 449, "YY"),
    (480, 441, "TO"),
    (499, 449, "MM"),
    (522, 449, "DD"),
    (544, 449, "YY"),
    # locator 17
    (15, 432, "17. NAME OF REFERRING PHYSICIAN OR OTHER SOURCE"),
    (204, 432, "17a. I.D. NUMBER OF REFERRING PHYSICIAN"),
    # locator 18
    (368, 432, "18. HOSPITALIZATION DATES RELATED TO CURRENT SERVICES"),
    (374, 416, "FROM"),
    (396, 426, "MM"),
    (420, 426, "DD"),
    (442, 426, "YY"),
    (480, 416, "TO"),
    (499, 426, "MM"),
    (522, 426, "DD"),
    (544, 426, "YY"),
    # locator 19
    (15, 407, "19."),
    # locator 20
    (368, 407, "20. OUTSIDE LAB?"),
    (470, 407, "$ CHARGES"),
    (391, 392, "YES"),
    (429, 392, "NO"),
    # locator 21
    (15, 382, "21. DIAGNOSIS OR NATURE OF ILLNESS OR INJURY. " \
     "(RELATE ITEMS 1,2,3 OR 4 TO ITEM 24E BY LINE)"),
    (20, 362, "1."),
    (55, 362, "."),
    (20, 342, "2."),
    (55, 342, "."),
    (214, 362, "3."),
    (248, 362, "."),
    (214, 342, "4."),
    (248, 342, "."),
    # locator 22
    (368, 381, "22. MEDICAID RESUBMISSION"),
    (378, 375, "CODE"),
    (460, 377, "ORIGINAL REF. NO."),
    # locator 23
    (368, 356, "23. PRIOR AUTHORIZATION NUMBER"),
    # locator 24
    (15, 332, "24."),
    (30, 332, "A"),
    (42, 323, "DATE(S) OF SERVICE"),
    (36, 317, "From"),
    (104, 317, "To"),
    (20, 311, "MM"),
    (40, 311, "DD"),
    (60, 311, "YY"),
    (85, 311, "MM"),
    (105, 311, "DD"),
    (125, 311, "YY"),
    (149, 332, "B"),
    (143, 323, "Place"),
    (148, 317, "of"),
    (141, 311, "Service"),
    (170, 332, "C"),
    (164, 323, "Type"),
    (170, 317, "of"),
    (162, 311, "Service"),
    (240, 332, "D"),
    (184, 323, "PROCEDURES, SERVICES, OR SUPPLIES"),
    (198, 317, "(Explain Unusual Circumstances)"),
    (188, 311, "CPT/HCPCS"),
    (244, 311, "MODIFIER"),
    (334, 332, "E"),
    (318, 321, "DIAGNOSIS"),
    (326, 314, "CODE"),
    (394, 332, "F"),
    (378, 314, "$ CHARGES"),
    (436, 332, "G"),
    (430, 323, "DAYS"),
    (434, 317, "OR"),
    (430, 311, "UNITS"),
    (458, 332, "H"),
    (450, 323, "EPSDT"),
    (451, 317, "Family"),
    (454, 311, "Plan"),
    (480, 332, "I"),
    (474, 314, "EMG"),
    (500, 332, "J"),
    (495, 314, "COB"),
    (540, 332, "K"),
    (520, 321, "RESERVED FOR"),
    (528, 314, "LOCAL USE"),
    (7, 290, "1"),
    (7, 266, "2"),
    (7, 242, "3"),
    (7, 218, "4"),
    (7, 194, "5"),
    (7, 170, "6"),
    # locator 25
    (15, 163, "25. FEDERAL TAX I.D. NUMBER"),
    (122, 163, "SSN"),
    (140, 163, "EIN"),
    # locator 26
    (171, 163, "26. PATIENT'S ACCOUNT NO."),
    # locator 27
    (275, 163, "27. ACCEPT ASSIGNMENT?"),
    (285, 158, "(For govt. claims, see back)"),
    (293, 150, "YES"),
    (333, 150, "NO"),
    # locator 28
    (368, 163, "28. TOTAL CHARGE"),
    (371, 150, "$"),
    # locator 29
    (447, 163, "29. AMOUNT PAID"),
    (448, 150, "$"),
    # locator 30
    (515, 163, "30. BALANCE DUE"),
    (516, 150, "$"),
    # locator 31
    (15, 138, "31. SIGNATURE OF PHYSICIAN OR SUPPLIER"),
    (25, 131, "INCLUDING DEGREES OR CREDENTIALS"),
    (25, 124, "(I certify that the statements on the reverse"),
    (25, 117, "apply to this bill and are made a part thereof.)"),
    (15, 91, "SIGNED"),
    (120, 91, "DATE"),
    # locator 32
    (171, 138, "32. NAME AND ADDRESS OF FACILITY WHERE SERVICES WERE"),
    (181, 131, "RENDERED (If other than home or office)"),
    # locator 33
    (367, 138, "33. PHYSICIAN'S, SUPPLIER'S BILLING NAME, ADDRESS, ZIP CODE"),
    (377, 131, "& PHONE #"),
    (367, 91, "PIN #"),
    (467, 91, "GRP #"),
    # bottom margin text
    (24, 75, '(APPROVED BY AMA COUNCIL ON MEDICAL SERVICE 8/88)'),
    (12, 65, 'HCFA-1500-C (Rev. 12-90)'),
    (454, 78, 'FORM HCFA-1500 (12-90)'),
    (454, 72, 'FORM OWCP-1500'),
    (530, 72, 'FORM RRB-1500'),
    ]

helvetica_6_bold_text = [ \
    (86, 503, "READ BACK OF FORM BEFORE COMPLETING & SIGNING THIS FORM."),
    ]

helvetica_6_bold_oblique_text = [ \
    (456, 514, "If yes,"), # Locator 11-d.
    ]

helvetica_6_oblique_text = [ \
    (25, 729, '(Medicare #)'),
    (78, 729, '(Medicaid #)'),
    (130, 729, "(Sponsor's SSN)"),
    (188, 729, '(VA File #)'),
    (240, 729, '(SSN or ID)'),
    (296, 729, '(SSN)'),
    (340, 729, '(ID)'),
    ]

helvetica_8_text = [ \
    # upper left margin: PLEASE / DO NOT / STAPLE / IN THIS / AREA
    (12, 810, 'PLEASE'),
    (12, 801, 'DO NOT'),
    (12, 792, 'STAPLE'),
    (12, 783, 'IN THIS'),
    (12, 774, 'AREA'),
    ]

helvetica_8_bold_oblique_text = [ \
    (246, 72, 'PLEASE PRINT OR TYPE'),
    ]

helvetica_11_bold_text = [ \
    (300, 752, 'HEALTH INSURANCE CLAIM FORM'),
    ]

line_thin = [ \
    (330, 560, 330, 566), # U-shape - auto accident - State
    (330, 560, 352, 560), # U-shape - auto accident - State
    (352, 560, 352, 566), # U-shape - auto accident - State
    (118, 558, 118, 572), # other insured - dob/sex separator bar
    (50, 466, 220, 466), # locator 12 - SIGNED
    (256, 466, 364, 466), # locator 12 - DATE
    (406, 466, 582, 466), # locator 13 - SIGNED
    (232, 290, 232, 305), # locator 24D - cpt/hcpcs - 1
    (232, 266, 232, 283), # locator 24D - cpt/hcpcs - 2
    (232, 242, 232, 259), # locator 24D - cpt/hcpcs - 3
    (232, 218, 232, 235), # locator 24D - cpt/hcpcs - 4
    (232, 194, 232, 211), # locator 24D - cpt/hcpcs - 5
    (232, 170, 232, 187), # locator 24D - cpt/hcpcs - 6
    ]

line_normal = [ \
    (104, 628, 104, 654), # left telephone
    (458, 628, 458, 654), # right telephone
    (218, 510, 218, 724), # vertical
    (192, 654, 192, 678), # left vertical - state
    (536, 654, 536, 678), # right vertical - state
    (12, 88, 12, 748), # BOTTOM - horizontal bar
    (582, 88, 582, 748), # TOP - horizontal bar
    (12, 724, 582, 724), # locator 1 separator
    (12, 701, 582, 701), # locator 2 separator
    (12, 678, 582, 678), # locator 5 separator
    (12, 654, 218, 654), # left address/city separator
    (364, 654, 582, 654), # right address/city separator
    (12, 628, 582, 628), # locator 9 separator
    (12, 604, 218, 604), # locator 9a separator
    (12, 581, 218, 581), # locator 9b separator
    (12, 558, 218, 558), # locator 9c separator
    (12, 534, 582, 534), # locator 9d,10d,11d separator
    (364, 604, 582, 604), # locator 11a separator
    (364, 581, 582, 581), # locator 11b separator
    (364, 558, 582, 558), # locator 11c separator
    (12, 510, 582, 510), # locator 12 separator
    (12, 439, 582, 439), # locator 14 separator
    (12, 414, 582, 414), # locator 17 separator
    (12, 388, 582, 388), # locator 19 separator
    (202, 414, 202, 462), # vertical line - locator 15, 17a
    (449, 388, 449, 400), # vertical line - locator 20
    (517, 388, 517, 400), # vertical line - locator 20
    (29, 362, 29, 368), # locator 21 - diag 1 - vertical
    (29, 362, 53, 362), # locator 21 - diag 1
    (59, 362, 70, 362), # locator 21 - diag 1
    (29, 342, 29, 348), # locator 21 - diag 2 - vertical
    (29, 342, 53, 342), # locator 21 - diag 2
    (59, 342, 70, 342), # locator 21 - diag 2
    (222, 362, 222, 368), # locator 21 - diag 3 - vertical
    (222, 362, 246, 362), # locator 21 - diag 3
    (252, 362, 263, 362), # locator 21 - diag 3
    (222, 342, 222, 348), # locator 21 - diag 4 - vertical
    (222, 342, 246, 342), # locator 21 - diag 4
    (252, 342, 263, 342), # locator 21 - diag 4
    (316, 383, 336, 383), # locator 21 - point to 24E
    (336, 383, 336, 360), # locator 21 - point to 24E
    (336, 360, 338, 363), # locator 21 - point to 24E - arrowtip
    (336, 360, 334, 363), # locator 21 - point to 24E - arrowtip
    (364, 363, 582, 363), # locator 22 separator
    (449, 363, 449, 375), # vertical line - locator 22
    (364, 339, 582, 339), # locator 23 separator
    (12, 339, 307, 339), # locator 24 separator
    (77, 310, 77, 170), # locator 24a - vertical - dates of service
    (140, 339, 140, 170), # locator 24b - vertical separator
    (161, 339, 161, 170), # locator 24c - vertical separator
    (182, 339, 182, 170), # locator 24d - vertical separator
    (307, 339, 307, 170), # locator 24e - vertical separator
    (428, 339, 428, 170), # locator 24f - vertical separator
    (449, 339, 449, 170), # locator 24g - vertical separator
    (470, 339, 470, 170), # locator 24h - vertical separator
    (491, 339, 491, 170), # locator 24i - vertical separator
    (512, 339, 512, 146), # locator 24j - vertical separator
    (12, 330, 582, 330), # locator 24 separator
    (12, 310, 582, 310), # locator 24 - headings
    (12, 290, 582, 290), # locator 24 - line 1
    (12, 266, 582, 266), # locator 24 - line 2
    (12, 242, 582, 242), # locator 24 - line 3
    (12, 218, 582, 218), # locator 24 - line 4
    (12, 194, 582, 194), # locator 24 - line 5
    (12, 170, 582, 170), # locator 24 - line 6
    (12, 145, 582, 145), # locator 25 separator
    (168, 170, 168, 88), # vertical separator - locators 25-26
    (272, 170, 272, 146), # vertical separator - locators 26-27
    (444, 170, 444, 146), # vertical separator - locators 28-29
    (464, 88, 464, 100), # vertical separator - locator 33 - PIN/GRP
    ]

line_wide = [ \
    (364, 88, 364, 748), # vertical center line
    ]

line_very_wide = [ \
    # horizontal lines
    (12, 748, 582, 748),
    (12, 88, 582, 88),
    (12, 462, 582, 462),
    ]

CheckBoxes = [ \
    (14, 726), # Medicare
    (66, 726), # Medicaid
    (118, 726), # Sponsor's SSN
    (176, 726), # VA File
    (226, 726), # SSN or ID
    (284, 726), # SSN
    (328, 726), # ID
    (309, 703), # Sex - Male
    (343, 703), # Sex - Female
    (242, 680), # PtRel - Self
    (278, 680), # PtRel - Spouse
    (309, 680), # PtRel - Child
    (343, 680), # PtRel - Other
    (255, 655), # Pt Status - Single
    (300, 655), # Pt Status - Married
    (343, 655), # Pt Status - Other
    (255, 630), # Pt Status - Employed
    (300, 630), # Pt Status - Full-Time Student
    (343, 630), # Pt Status - Part-Time Student
    (255, 585), # Pt Condition - Employment Related - YES
    (300, 585), # Pt Condition - Employment Related - NO
    (255, 560), # Pt Condition - Auto Accident - YES
    (300, 560), # Pt Condition - Auto Accident - NO
    (255, 536), # Pt Condition - Other Accident - YES
    (300, 536), # Pt Condition - Other Accident - NO
    (492, 583), # Insured - Sex - Male
    (546, 583), # Insured - Sex - Female
    (135, 560), # Other Insured - Sex - Male
    (174, 560), # Other Insured - Sex - Female
    (380, 512), # Is there another health benefit plan? - YES
    (416, 512), # Is there another health benefit plan? - NO
    (378, 390), # Outside Lab - YES
    (416, 390), # Outside Lab - NO
    (124, 147), # locator 25 - SSN
    (140, 147), # locator 25 - EIN
    (276, 147), # locator 27 - YES
    (315, 147), # locator 27 - NO
    ]

DashLines = [ \
    (246, 701, 246, 718), # patient birthdate - MM/DD
    (268, 701, 268, 718), # patient birthdate - DD/YY
    (413, 582, 413, 600), # insured birthdate - MM/DD
    (433, 582, 433, 600), # insured birthdate - DD/YY
    (37, 558, 37, 576), # other insured date of birth
    (59, 558, 59, 576), # other insured date of birth
    (38, 439, 38, 456), # date current illness - MM/DD
    (59, 439, 59, 456), # date current illness - DD/YY
    (290, 439, 290, 456), # locator 15 - MM/DD
    (310, 439, 310, 456), # locator 15 - DD/YY
    (412, 439, 412, 456), # locator 16 - from - MM/DD
    (435, 439, 435, 456), # locator 16 - from - DD/YY
    (514, 439, 514, 456), # locator 16 - to - MM/DD
    (537, 439, 537, 456), # locator 16 - to - DD/YY
    (412, 414, 412, 431), # locator 18 - from - MM/DD
    (435, 414, 435, 431), # locator 18 - from - DD/YY
    (514, 414, 514, 431), # locator 18 - to - MM/DD
    (537, 414, 537, 431), # locator 18 - to - DD/YY
    (34, 290, 34, 307), # locator 24 - line 1 - date from - MM/DD
    (54, 290, 54, 307), # locator 24 - line 1 - date from - DD/YY
    (98, 290, 98, 307), # locator 24 - line 1 - date to - MM/DD
    (118, 290, 118, 307), # locator 24 - line 1 - date to - DD/YY
    (34, 266, 34, 283), # locator 24 - line 2 - date from - MM/DD
    (54, 266, 54, 283), # locator 24 - line 2 - date from - DD/YY
    (98, 266, 98, 283), # locator 24 - line 2 - date to - MM/DD
    (118, 266, 118, 283), # locator 24 - line 2 - date to - DD/YY
    (34, 242, 34, 259), # locator 24 - line 3 - date from - MM/DD
    (54, 242, 54, 259), # locator 24 - line 3 - date from - DD/YY
    (98, 242, 98, 259), # locator 24 - line 3 - date to - MM/DD
    (118, 242, 118, 259), # locator 24 - line 3 - date to - DD/YY
    (34, 218, 34, 235), # locator 24 - line 4 - date from - MM/DD
    (54, 218, 54, 235), # locator 24 - line 4 - date from - DD/YY
    (98, 218, 98, 235), # locator 24 - line 4 - date to - MM/DD
    (118, 218, 118, 235), # locator 24 - line 4 - date to - DD/YY
    (34, 194, 34, 211), # locator 24 - line 5 - date from - MM/DD
    (54, 194, 54, 211), # locator 24 - line 5 - date from - DD/YY
    (98, 194, 98, 211), # locator 24 - line 5 - date to - MM/DD
    (118, 194, 118, 211), # locator 24 - line 5 - date to - DD/YY
    (34, 170, 34, 187), # locator 24 - line 6 - date from - MM/DD
    (54, 170, 54, 187), # locator 24 - line 6 - date from - DD/YY
    (98, 170, 98, 187), # locator 24 - line 6 - date to - MM/DD
    (118, 170, 118, 187), # locator 24 - line 6 - date to - DD/YY
    (254, 290, 254, 307), # locator 24D - modifier - 1
    (254, 266, 254, 283), # locator 24D - modifier - 2
    (254, 242, 254, 259), # locator 24D - modifier - 3
    (254, 218, 254, 235), # locator 24D - modifier - 4
    (254, 194, 254, 211), # locator 24D - modifier - 5
    (254, 170, 254, 187), # locator 24D - modifier - 6
    (404, 170, 404, 310), # locator 24F - charges
    (422, 146, 422, 163), # locator 28 - total charge
    (491, 146, 491, 163), # locator 29 - amount paid
    (558, 146, 558, 163), # locator 30 - balance due
    ]

Labels = { \
    (Helvetica, 6) : helvetica_6_text,
    (Helvetica_Bold, 6) : helvetica_6_bold_text,
    (Helvetica_Oblique, 6) : helvetica_6_oblique_text,
    (Helvetica_Bold_Oblique, 6) : helvetica_6_bold_oblique_text,
    (Helvetica, 8) : helvetica_8_text,
    (Helvetica_Bold_Oblique, 8) : helvetica_8_bold_oblique_text,
    (Helvetica_Bold, 11) : helvetica_11_bold_text,
    }

Lines = { \
    0.25 : line_thin,
    0.5 : line_normal,
    1.25 : line_wide,
    1.75 : line_very_wide,
    }
