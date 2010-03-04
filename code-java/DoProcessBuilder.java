import java.io.*;
import java.util.*;

public class DoProcessBuilder {
	public static void main(String args[]) throws IOException {
				
    	Process process = new ProcessBuilder("/usr/bin/rsync", "-rtv", "--delete","/Users/brian/from/", "/Users/brian/to/").start();
    	InputStream is = process.getInputStream();
    	InputStreamReader isr = new InputStreamReader(is);
    	BufferedReader br = new BufferedReader(isr);
    	String line;

		while ((line = br.readLine()) != null) {
			System.out.println(line);
		}

	}
}