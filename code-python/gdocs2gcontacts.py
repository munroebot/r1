#!/usr/bin/env python
# -*- coding: utf-8 -*-

try: 
  from xml.etree import ElementTree
except ImportError:  
  from elementtree import ElementTree

import atom
import atom.service
import gdata.contacts
import gdata.contacts.service
import gdata.spreadsheet
import gdata.spreadsheet.service

import csv

class Contact(object):

    def __init__(self):

        self._first_name = None
        self._partner_name = None
        self._last_name =  None
        self._home_address = None 
        self._home_city = None
        self._home_state = None 
        self._home_zip = None
        self._home_phone = None
        self._mobile_phone = None
        self._work_phone = None
        self._home_email = None
        self._work_email = None

    @property
    def first_name(self):
        return self._first_name
    
    @first_name.setter
    def first_name(self,value):
        self._first_name = value

    @property
    def partner_name(self):
        return self._partner_name
    
    @partner_name.setter
    def partner_name(self,value):
        self._partner_name = value

    @property
    def last_name(self):
        return self._last_name
    
    @last_name.setter
    def last_name(self,value):
        self._last_name = value

    @property
    def full_name(self):
        if self._first_name != None and self._last_name != None:
            return "%s %s" % (self._first_name, self._last_name)
        else:
            return self._first_name

    @property
    def home_address(self):
        return self._home_address
    
    @home_address.setter
    def home_address(self,value):
        self._home_address = value

    @property
    def home_city(self):
        return self._home_city
    
    @home_city.setter
    def home_city(self,value):
        self._home_city = value

    @property
    def home_state(self):
        return self._home_state
    
    @home_state.setter
    def home_state(self,value):
        self._home_state = value

    @property
    def home_zip(self):
        return self._home_zip
    
    @home_zip.setter
    def home_zip(self,value):
        self._home_zip = value

    @property
    def full_home_address(self):
        if self._home_address != None and self.home_city != None and self._home_state != None and self._home_zip != None:
            return "%s, %s, %s, %s" % (self._home_address, self._home_city, self._home_state, self._home_zip)
        else:
            return None

    @property
    def home_phone(self):
        return self._home_phone
    
    @home_phone.setter
    def home_phone(self,value):
        self._home_phone = value

    @property
    def mobile_phone(self):
        return self._mobile_phone
    
    @mobile_phone.setter
    def mobile_phone(self,value):
        self._mobile_phone = value

    @property
    def work_phone(self):
        return self._work_phone
    
    @work_phone.setter
    def work_phone(self,value):
        self._work_phone = value

    @property
    def home_email(self):
        return self._home_email
    
    @home_email.setter
    def home_email(self,value):
        self._home_email = value

    @property
    def work_email(self):
        return self._work_email
    
    @work_email.setter
    def work_email(self,value):
        self._work_email = value


def is_gmail_contact(entry):
    
    return_value = True
    is_gmail = entry.custom['gmail'].text

    if is_gmail != None and (is_gmail == 'n' or is_gmail == 'N'):
        return_value = False

    return return_value
 
class ContactBridge(object):

    def __init__(self,email=None,password=None,spreadsheet=None,worksheet=None):

        # Authenticate
        self.s_client = gdata.spreadsheet.service.SpreadsheetsService()
        self.s_client.email = email
        self.s_client.password = password
        self.s_client.ProgrammaticLogin()

        self.c_client = gdata.contacts.service.ContactsService()
        self.c_client.email = email
        self.c_client.password = password
        self.c_client.ProgrammaticLogin()

        # Initialize Spreadsheet -> Worksheet object
        self.s_client_query = gdata.spreadsheet.service.DocumentQuery()
        self.s_client_query['title-exact'] = 'true'

        self.s_client_query['title'] = spreadsheet        
        self.spreadsheet_feed = self.s_client.GetSpreadsheetsFeed(query=self.s_client_query)
        self.spreadsheet_key = self.spreadsheet_feed.entry[0].id.text.rsplit('/', 1)[1]

        self.s_client_query['title'] = worksheet
        self.worksheet_feed = self.s_client.GetWorksheetsFeed(key=self.spreadsheet_key,query=self.s_client_query)
        self.worksheet_key = self.worksheet_feed.entry[0].id.text.rsplit('/', 1)[1]

        self.address_feed = self.s_client.GetListFeed(self.spreadsheet_key,self.worksheet_key) 

    def get_spreadsheet_contacts(self):
        contact_list = []

        for i, entry in enumerate(self.address_feed.entry):

            if is_gmail_contact(entry) == False:
                continue
        
            c = Contact()

            for key in entry.custom:
                
                if key == 'firstname':
                    c.first_name = entry.custom[key].text

                if key == 'partnername':
                    c.partner_name = entry.custom[key].text
                
                if key == 'lastname':
                    c.last_name = entry.custom[key].text

                if key == 'homeaddress':
                    c.home_address = entry.custom[key].text

                if key == 'homecity':
                    c.home_city = entry.custom[key].text

                if key == 'homestate':
                    c.home_state = entry.custom[key].text

                if key == 'homezip':
                    c.home_zip = entry.custom[key].text

                if key == 'homephone':
                    c.home_phone = entry.custom[key].text
           
                if key == 'mobilephone':
                    c.mobile_phone = entry.custom[key].text

                if key == 'workphone':
                    c.work_phone = entry.custom[key].text

                if key == 'homeemail':
                    c.home_email = entry.custom[key].text

                if key == 'workemail':
                    c.work_email = entry.custom[key].text

            contact_list.append(c)
   
        return contact_list
    
    def push_to_gcontacts(self,contacts):
 
        i = 0 
        
        for x in contacts:

            c1 = gdata.contacts.ContactEntry(title=atom.Title(text=x.full_name))

            if (x.home_email != None):
                c1.email.append(gdata.contacts.Email(address=x.home_email,primary='true', rel=gdata.contacts.REL_HOME))
            
            if (x.work_email != None):
                c1.email.append(gdata.contacts.Email(address=x.work_email,rel=gdata.contacts.REL_WORK))

            if (x.full_home_address != None):
                c1.structured_postal_address.append(gdata.contacts.PostalAddress(primary='true',text=x.full_home_address, rel=gdata.contacts.REL_HOME))

            if (x.home_phone != None):
                c1.phone_number.append(gdata.contacts.PhoneNumber(primary='true',text=x.home_phone,rel=gdata.contacts.REL_HOME))
            
            if (x.mobile_phone != None):
                c1.phone_number.append(gdata.contacts.PhoneNumber(text=x.mobile_phone,rel=gdata.contacts.PHONE_MOBILE))

            self.c_client.CreateContact(c1)
            i += 1
        
        print "Pushed %d spreadsheet contacts into Google Contacts" % (i)

    def push_to_csv(self, contacts=None, filename=None, with_partner_name=False):
        
        partner_name_header = ""
        partner_name = ""

        if with_partner_name == True:
            partner_name_header = "Partner_Name"
    
        if filename != None:
            writer = csv.writer(open(filename, 'wb'), delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
            writer.writerow(["First_Name", "Last_Name", "Home_Address", "Home_City", "Home_State", "Home_Zip"])

            for contact in contacts:
                
                if with_partner_name == True and contact.partner_name != None:
                    partner_name = "and " + contact.partner_name + " "
                else:
                    partner_name = ""

                writer.writerow([contact.first_name, contact.last_name, contact.home_address, contact.home_city, contact.home_state, contact.home_zip])

def main():

    e = ''
    p = ''

    cb1 = ContactBridge(email=e,password=p,spreadsheet='Addressbook',worksheet='master')
    contacts = cb1.get_spreadsheet_contacts()
    #cb1.push_to_csv(contacts,filename="/Users/bmunroe/test.csv")

    #cb1.push_to_gcontacts(contacts)

if __name__ == '__main__': main()

