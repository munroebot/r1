
import win32com.client
import getpass, sys
import gobject
import gtk
from gtk import TRUE, FALSE

description = 'List Store'

COLUMN_FIXED       = 0
COLUMN_NUMBER      = 1
COLUMN_SEVERITY    = 2
COLUMN_DESCRIPTION = 3
data = []

def create_model():
    store = gtk.ListStore(gobject.TYPE_STRING,gobject.TYPE_STRING,gobject.TYPE_STRING,gobject.TYPE_STRING)
    for item in data:
        iter = store.append()
        store.set(iter, COLUMN_FIXED, item[0],COLUMN_NUMBER, item[1],COLUMN_SEVERITY, item[2],COLUMN_DESCRIPTION, item[3])
    return store

def sayhi(treeview, iter, path):
    print iter

def add_columns(treeview):
    model = treeview.get_model()

    # column for fixed toggles

    column = gtk.TreeViewColumn('Last Name', gtk.CellRendererText(),
                                text=COLUMN_FIXED)
    treeview.append_column(column)

    # column for bug numbers
    column = gtk.TreeViewColumn('First Name', gtk.CellRendererText(),
                                text=COLUMN_NUMBER)

    treeview.append_column(column)

    # columns for severities
    column = gtk.TreeViewColumn('Desk Phone', gtk.CellRendererText(),
                                text=COLUMN_SEVERITY)
    treeview.append_column(column)

    # column for description
    column = gtk.TreeViewColumn('Organization', gtk.CellRendererText(),
                                 text=COLUMN_DESCRIPTION)
    treeview.append_column(column)

def main():
    try:
        pwd = sys.argv[1]
        searchString = sys.argv[2]
    except:
        pwd = getpass.getpass(prompt="Please enter your Lotus Notes password: ")
        searchString = raw_input("Enter Search Criteria: ")

    session = win32com.client.Dispatch("Lotus.NotesSession")
    session.Initialize(pwd)

    path = "crwmsContact.nsf"
    server = ""

    db = session.getDatabase(server,path)
    docCollection = db.FTSearch(searchString.lower() + '*', 0,8,512)

    i = 1
    dirtyFlag = False

    while (i <= docCollection.Count):
        doc = docCollection.GetNthDocument(i)

        lastname = doc.GetItemValue("lastname")[0].lower()
        firstname = doc.GetItemValue("firstname")[0].lower()

        if (searchString.lower() in firstname or searchString.lower() in lastname):
            dirtyFlag = True

        if(doc.GetItemValue("Form")[0] == "Main Form" and dirtyFlag):
            #print "%s, %s" % (doc.GetItemValue("lastname")[0].capitalize(),doc.GetItemValue("firstname")[0].capitalize())
            data.append([doc.GetItemValue("lastname")[0].capitalize(),doc.GetItemValue("firstname")[0].capitalize(),doc.GetItemValue("phone")[0],doc.GetItemValue("org")[0]])

        i = i + 1
        dirtyFlag = False

    win = gtk.Window(gtk.WINDOW_TOPLEVEL)
    win.connect('destroy', lambda win: gtk.main_quit())

    win.set_title('Search Results')
    win.set_border_width(8)

    vbox = gtk.VBox(FALSE, 8)
    win.add(vbox)

    sw = gtk.ScrolledWindow()
    sw.set_shadow_type(gtk.SHADOW_ETCHED_IN)
    sw.set_policy(gtk.POLICY_NEVER,
                   gtk.POLICY_AUTOMATIC)
    vbox.pack_start(sw)

    model = create_model()

    treeview = gtk.TreeView(model)
    treeview.set_rules_hint(TRUE)
    treeview.set_search_column(COLUMN_DESCRIPTION)
    treeview.connect("row-activated", sayhi)

    sw.add(treeview)

    add_columns(treeview)

    win.set_default_size(280, 250)

    win.show_all()
    win.show()
    gtk.main()


main()