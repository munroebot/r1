import java.io.*;
import java.util.ArrayList;

class ObjectOutputFileStream {
    public static void main(String[] args) {

        ArrayList al = new ArrayList();
        for (int i=0;i<100000;++i) {
            al.add(new Integer(i));
        }

        //FileInputStream in = new FileInputStream("out.file.name");
        //ObjectInputStream oin = new ObjectInputStream(in);
        //ArrayList a2  = (ArrayList) oin.readObject();
        //oin.close();

        try {
            FileOutputStream fos = new FileOutputStream("out.file.name");
            ObjectOutputStream oos = new ObjectOutputStream(fos);
            oos.writeObject(al);
            oos.close();
        } catch (Exception e) {

        }
    }
}