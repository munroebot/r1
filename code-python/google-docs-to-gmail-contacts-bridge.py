#!/bin/python
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

def PrintFeed(feed):
    for i, entry in enumerate(feed.entry):
        if isinstance(feed, gdata.spreadsheet.SpreadsheetsCellsFeed):
            print '%s %s\n' % (entry.title.text, entry.content.text)
        elif isinstance(feed, gdata.spreadsheet.SpreadsheetsListFeed):
            print '%s %s %s' % (i, entry.title.text, entry.content.text)
            # Print this row's value for each column (the custom dictionary is
            # built from the gsx: elements in the entry.) See the description of
            # gsx elements in the protocol guide.
            print 'Contents:'
            for key in entry.custom:
                print '  %s: %s' % (key, entry.custom[key].text)
                print '\n',
        else:
            print '%s %s\n' % (i, entry.title.text)

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

    def dump_to_csv(self):
        PrintFeed(self.address_feed)

def main():
    cb1 = ContactBridge(spreadsheet='Addressbook',worksheet='Iphone prep')
    cb1.dump_to_csv()

if __name__ == '__main__': main()

