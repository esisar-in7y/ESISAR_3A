import java.security.NoSuchAlgorithmException;
import java.util.Random;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter; // Import the FileWriter class
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.SeekableByteChannel;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

public class bloom {

    private  static int m=200_000_000;
    private  static int k=11;
    private static  boolean[] filter = new boolean[m];
    private static int fauxpositif=0;
    private static int nb_urls=0;

    public static  void bloomInit() {
        for (int i = 0; i < m; i++) {
            filter[i] = false;
        }
    }

    private static  int hash(String value, int numFonction) {
        int h1 = h1(value);
        int h2 = h2(value);
        int h = ((h1 + numFonction * h2) % m);
        h = (h + m) % m;
        return h;
    }
    private static  int h1(String value) {
        char val[] = value.toCharArray();
        int h = 0;
        for (int i = 0; i < val.length; i++) {
            h = 31 * h + val[i];
        }
        return h;
    }
    private static  int h2(String value) {
        char val[] = value.toCharArray();
        int h = 0;
        for (int i = 0; i < val.length; i++) {
            h = 57 * (h << 2) + val[i];
        }
        return h;
    }
    
    private static boolean isinfile(String url_to_find) throws IOException {
        long start = System.currentTimeMillis();
        SeekableByteChannel sbc = Files.newByteChannel(Paths.get("./infected-urls.txt"),StandardOpenOption.READ);
        int count = 0;
        // Lecture des 50 000 premiers octets du fichier
        ByteBuffer buf = ByteBuffer.allocate(50_000);
        int ret = sbc.read(buf);
        while (ret > 0) {
            // Conversion des 50_0000 octets en 1000 chaine de caractères
            for (int i = 0; i < 1000; i++) {
                String str = new String(buf.array(), i * 50, 50);
                // Suppression des espaces en fin de chaine
                str = str.trim();
                if(str.equals(url_to_find)) {
                	buf.clear();
                    sbc.close();
                	return true;
                }
                // Affichage de la chaine de caractères sur la console
                // System.out.println(str);
                count++;
            }
            // Lecture des 50_000 octets suivants
            buf.clear();
            ret = sbc.read(buf);
        }
        // Fermeture du fichier
        sbc.close();
        return false;
    }
    private static  void readFile() throws IOException {
        long start = System.currentTimeMillis();
        SeekableByteChannel sbc = Files.newByteChannel(Paths.get("./infected-urls.txt"),StandardOpenOption.READ);
        int count = 0;
        // Lecture des 50 000 premiers octets du fichier
        ByteBuffer buf = ByteBuffer.allocate(50_000);
        int ret = sbc.read(buf);
        while (ret > 0) {
            // Conversion des 50_0000 octets en 1000 chaine de caractères
            for (int i = 0; i < 1000; i++) {
                String str = new String(buf.array(), i * 50, 50);
                // Suppression des espaces en fin de chaine
                str = str.trim();
                insertURL(str);
                // Affichage de la chaine de caractères sur la console
                // System.out.println(str);
                count++;
            }
            // Lecture des 50_000 octets suivants
            buf.clear();
            ret = sbc.read(buf);
        }
        System.out.println("Nombre d'URL dans le fichier =" + count);
        System.out.println("Elapsed Time=" + (System.currentTimeMillis() - start) / 1000 + "s");
        // Fermeture du fichier
        sbc.close();
    }

    private static  void insertURL(String URL) {
    	//System.out.println("|"+URL+"|");
        for (int i = 0; i < k; i++) {
            filter[hash(URL, i)] = true;
        }
    }
    private static boolean are_presents() throws Exception {
        long start = System.currentTimeMillis();
        SeekableByteChannel sbc = Files.newByteChannel(Paths.get("./valides-urls.txt"),StandardOpenOption.READ);
        int count = 0;
        // Lecture des 50 000 premiers octets du fichier
        ByteBuffer buf = ByteBuffer.allocate(50_000);
        int ret = sbc.read(buf);
        while (ret > 0) {
            // Conversion des 50_0000 octets en 1000 chaine de caractères
            for (int i = 0; i < 1000; i++) {
                String str = new String(buf.array(), i * 50, 50);
                // Suppression des espaces en fin de chaine
                isPresent(str.trim());
                nb_urls++;
                // Affichage de la chaine de caractères sur la console
                // System.out.println(str);
                count++;
            }
            // Lecture des 50_000 octets suivants
            buf.clear();
            ret = sbc.read(buf);
        }
        // Fermeture du fichier
        sbc.close();
        return false;
    }
    

    private static  boolean isPresent(String URL) throws Exception{
        for (int i = 0; i < k; i++) {
            if (!filter[hash(URL, i)]) {
                return false;
            }
        }
        //go to check in file if realtrue
        // ohoh faux positif LOL
        fauxpositif++;
        return true;
    }

    public static void main(String[] args) {
        try {
        	for(int i=20;i<21;i++) {
        		k=i;
        		fauxpositif=0;
        		nb_urls=0;
        		bloomInit();
        		readFile();
        		are_presents();
        		System.out.println("k="+i+"|"+(fauxpositif*100.0f/nb_urls)+"%");
        	}
	        /*bloomInit();
	        readFile();
	        System.out.println(isPresent("http://sxv.aw/BFHuRvb"));
	        System.out.println(isPresent("http://www.google.com"));
	        System.out.println(isPresent("http://www.amazon.com"));
	        System.out.println(isPresent("http://www.wikipedia.com"));*/
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}