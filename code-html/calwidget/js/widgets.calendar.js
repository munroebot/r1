//
// widgets.calendar.js
//
// Copyright (C) 2004, 2005 Tribador Mediaworks
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

// Set up namepace
//
if (!widgets) var widgets = {};

// widgets.Calendar class constructor
//
widgets.Calendar = function(id,defaultValue,linkto,format,edit,icon,iconpath) {
	this.NO_ICON = 0;
	this.ICON = 1;
	this.NO_EDIT = 0;
	this.EDIT = 1;
    this.id = id || "noid";
    this.defaultValue = defaultValue || "";
    this.linkto = linkto || "noid";
    this.format = format || "mm/dd/yyyy";
    this.edit = edit || 1;
    this.icon = icon || 1;
    this.iconpath = iconpath = "images/calwidget-icon.gif";
}

// widgets.Calendar class method showDebug()
//
widgets.Calendar.prototype.showDebug = function() {
    document.write("<pre class=\"debug\">Id: "+ this.id + "\nDefaultValue: " + this.defaultValue + "\nLinkTo: " + this.linkto + "\nFormat: " + this.format + "\nEDIT: " + this.edit + "\nIcon: " + this.icon +  "\nIconPath: " + this.iconpath + "</pre>");
}

widgets.Calendar.prototype.show = function() {

}