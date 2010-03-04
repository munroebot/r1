/**

CRWMS NAB Spider
05/30/2007
Brian Munroe <brian.munroe@ymp.gov>

Creates a flat list of all internet address permutations for EXIM processing

*/

import lotus.domino.*;
import java.util.*;

public class JavaAgent extends AgentBase {
	public void NotesMain() {

		String x = null;
		String subject = "NAB Output";
		Vector mailRecp = new Vector();
		//mailRecp.addElement("brian.munroe@ymp.gov");
		mailRecp.addElement("new-valid-users@magorian.ymp.gov");

		try {
			Session session = getSession();
			AgentContext agentContext = session.getAgentContext();
			Database db = session.getDatabase("ydln1", "names.nsf");
			DocumentCollection dc = db.search("Form = 'Person'");
      		Document doc = dc.getFirstDocument();
      		while (doc != null) {
				// Process the FullName field
				Vector item = doc.getItemValue("FullName");
        			for (Enumeration values = item.elements(); values.hasMoreElements();) {
        				String j = (String)values.nextElement();
					if (j.endsWith("@rw.doe.gov")) {
						j = j.substring(0,j.indexOf("@rw.doe.gov"));
					}

					if (j.endsWith("@ymp.gov")) {
						j = j.substring(0,j.indexOf("@ymp.gov"));
					}

        			if (j.startsWith("CN=") == false) {
        				x += j.replace(' ','.').toLowerCase().trim() + "\n";
        			}
          		}

          		// Process the ShortName field
          		Vector junky = doc.getItemValue("ShortName");
          		for (Enumeration e = junky.elements(); e.hasMoreElements();) {
					String jj = (String)e.nextElement();
					if (jj.endsWith("@rw.doe.gov")) {
						jj = jj.substring(0,jj.indexOf("@rw.doe.gov"));
					}

					if (jj.endsWith("@ymp.gov")) {
						jj = jj.substring(0,jj.indexOf("@ymp.gov"));
					}

					x += jj.replace(' ','.').toLowerCase().trim() + "\n";
				}

				// Process the InternetAddress field
          		if (doc.getItemValueString("InternetAddress") != null) {
					String ia = "";
					if (doc.getItemValueString("InternetAddress").endsWith("@rw.doe.gov")){
						ia = (String)doc.getItemValueString("InternetAddress");
						ia = ia.substring(0,ia.indexOf("@rw.doe.gov")).toLowerCase() + "\n";
					}

					if (doc.getItemValueString("InternetAddress").endsWith("@ymp.gov")){
						ia = (String)doc.getItemValueString("InternetAddress");
						ia = ia.substring(0,ia.indexOf("@ymp.gov")).toLowerCase() +"\n";
					}

					x += ia;
					ia = "";
				}
          	doc = dc.getNextDocument();
			}

			// Now send the email
			Document memo = db.createDocument();
        		memo.appendItemValue("Form", "Memo");
			memo.appendItemValue("Subject",subject);
			RichTextItem rtBody = memo.createRichTextItem("Body");
			rtBody.appendText(x);
			memo.send(true,mailRecp);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
