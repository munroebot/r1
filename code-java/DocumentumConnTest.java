import java.util.*;
import javax.naming.*;
import java.io.*;

import com.documentum.fc.client.*;
import com.documentum.fc.common.*;


public class DocumentumConnTest {
    public static void main(String[] args) {

        try {

            IDfSession dfcSession = null;

            IDfClient client = DfClient.getLocalClient();

            IDfLoginInfo loginInfo = new DfLoginInfo();
            loginInfo.setUser("brian");
            loginInfo.setPassword("adsm1234");

            System.out.println(client.newSession("ONT_DEV",loginInfo));

        } catch (Exception e) {
            System.err.println(e);
        }
    }
}