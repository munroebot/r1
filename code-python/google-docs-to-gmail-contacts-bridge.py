#!/usr/bin/env python
# -*- coding: utf-8 -*-

try: 
  from xml.etree import ElementTree
except ImportError:  
  from elementtree import ElementTree

import gdata.spreadsheet.service
import gdata.service
import atom.service
import gdata.spreadsheet
import atom

class Contact(object):

    def __init__(self):

        self._first_name = ""
        self._last_name = ""
        self._home_address = ""
        self._home_city = ""
        self._home_state = ""
        self._home_zip = ""
        self._home_phone = ""
        self._mobile_phone = ""
        self._work_phone = ""
        self._home_email = ""
        self._work_email = ""

    @property
    def first_name(self):
        return self._first_name
    
    @first_name.setter
    def first_name(self,value):
        self._first_name = value

    @property
    def last_name(self):
        return self._last_name
    
    @last_name.setter
    def last_name(self,value):
        self._last_name = value

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
        return self._home_address + ", " + self._home_city + ", " + \
        self._home_state + ", " + self._home_zip 

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


class ContactBridge(object):

    def __init__(self,email=None,password=None,spreadsheet=None,worksheet=None):

        # Authenticate
        self.s_client = gdata.spreadsheet.service.SpreadsheetsService()
        self.s_client.email = email
        self.s_client.password = password
        self.s_client.ProgrammaticLogin()

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

            c = Contact()

            for key in entry.custom:

                if key == 'firstname':
                    c.first_name = entry.custom[key].text
                
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
           
                if key == 'mobiephone':
                    c.mobile_phone = entry.custom[key].text

                if key == 'workphone':
                    c.work_phone = entry.custom[key].text

                if key == 'homeemail':
                    c.home_email = entry.custom[key].text

                if key == 'workemail':
                    c.work_email = entry.custom[key].text

            contact_list.append(c)
   
        return contact_list

def main():
    cb1 = ContactBridge(email='',password='',spreadsheet='Addressbook',worksheet='master')
    contacts = cb1.get_spreadsheet_contacts()
    print contacts[11].full_home_address
    #cb1.import_into_google_contacts(contacts)

if __name__ == '__main__': main()

