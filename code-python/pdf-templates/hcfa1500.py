#!/usr/bin/env python
# hcfa1500.py

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
__version__="0.1"
"""
hcfa1500 is used to generate pdf versions of the industry-standard
HCFA-1500 form used to process medical claims.  This module requires
ReportLab's PDFgen library (http://www.reportlab.com) and assumes 
the library will be in your Python path.
"""

from reportlab.pdfgen.canvas import Canvas

inch = INCH = 72
cm = CM = inch / 2.54
Courier = 'Courier'
Helvetica = 'Helvetica'
Helvetica_Bold = 'Helvetica-Bold'
Helvetica_Bold_Oblique = 'Helvetica-BoldOblique'

from stat1500 import CheckBoxes, DashLines, Labels, Lines
from flds1500 import XYPosition

class Form:
    def __init__(self, **kw):
        self.pdfpath = kw.get('pdfpath', 'hcfa1500.pdf')
        self.verbose = kw.get('verbose', 0)
        self.text_font = kw.get('typeface', Courier)
        self.text_size = kw.get('fontsize', 10)
        self.canvas = Canvas(self.pdfpath)
        self.__draw_dash_lines()
        self.__draw_lines()
        self.__draw_special()
        self.__draw_check_boxes()
        self.__draw_text_labels()

    def assign_carrier(self, line1='', line2='', line3='', line4=''):
        """
        Just a convenience method, illustrating how to display
        the carrier information on the form.  An example of how
        this might be invoked:

            form.assign_carrier("Medicare",
                                "P.O. Box 830140",
                                "Birmingham, AL 35283-0140")

        The user may also choose to override this method by taking 
        direct control over self.canvas.
        """
        c = self.canvas
        y = 805
        i = 0
        for line in (line1, line2, line3, line4):
            t = c.beginText(300, y - 10*i)
            t.setFont(Helvetica, 8)
            t.textOut(line)
            c.drawText(t)
            i = i + 1

    def __draw_check_boxes(self):
        c = self.canvas
        c.setLineWidth(0.25)
        for x, y in CheckBoxes:
            c.rect(x, y, 10, 10, stroke=1)

    def __draw_dash_lines(self):
        c = self.canvas
        c.setLineWidth(0.25)
        c.setDash(3,3)
        for x1, y1, x2, y2 in DashLines:
            c.line(x1, y1, x2, y2)
        c.setDash()

    def __draw_lines(self):
        c = self.canvas
        for width, lines in Lines.items():
            c.setLineWidth(width)
            for x1, y1, x2, y2 in lines:
                c.line(x1, y1, x2, y2)

    def __draw_special(self):
        c = self.canvas
        # Locator 14 - arrowtip hack
        c.saveState()
        c.rotate(-45)
        c.setFillColorRGB(0, 0, 0) # black fill
        c.rect(-254, 380, 14, 14, stroke=0, fill=1)
        c.rotate(45)
        c.setFillColorRGB(1, 1, 1) # white fill
        c.rect(98, 436, 12, 21, stroke=0, fill=1)
        c.restoreState()
        # PICA alignment boxes
        c.setLineWidth(0.25)
        c.rect(14, 748, 7, 9, stroke=1)
        c.rect(21, 748, 7, 9, stroke=1)
        c.rect(28, 748, 7, 9, stroke=1)
        c.setLineWidth(0.25)
        c.rect(561, 748, 7, 9, stroke=1)
        c.rect(568, 748, 7, 9, stroke=1)
        c.rect(575, 748, 7, 9, stroke=1)

    def __draw_text_labels(self):
        c = self.canvas
        for (font, size), label in Labels.items():
            for x, y, text in label:
                t = c.beginText(x, y)
                t.setFont(font, size)
                t.textOut(text)
                c.drawText(t)

    def populate(self, dict):
        """
        Populate the data fields on this form from the passed
        dict values.
        """
        c = self.canvas
        for k, v in dict.items():
            if not XYPosition.has_key(k):
                if self.verbose:
                    print "populate() item not found: ", k
                continue
            x, y = XYPosition[k]
            t = c.beginText(x, y)
            t.setFont(self.text_font, self.text_size)
            t.textOut(v)
            c.drawText(t)

    def save(self):
        self.canvas.save()

if __name__ == '__main__':    
    from flds1500 import test_pattern
    form = Form()
    form.assign_carrier("Medicare",
                        "P.O. Box 830140",
                        "Birmingham, AL  35283-0140")
    form.populate(test_pattern())
    form.save()
