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

    private int m;
    private int k;
    private boolean[] filter = new boolean[m];

    public void bloomInit() {
        for (int i = 0; i < m; i++) {
            filter[i] = false;
        }
    }

    private int hash(String value, int numFonction) {
        int h1 = h1(value);
        int h2 = h2(value);
        int h = ((h1 + numFonction * h2) % m);
        h = (h + m) % m;
        return h;
    }

    private int h1(String value) {
        char val[] = value.toCharArray();
        int h = 0;
        for (int i = 0; i < val.length; i++) {
            h = 31 * h + val[i];
        }
        return h;
    }

    private int h2(String value) {
        char val[] = value.toCharArray();
        int h = 0;
        for (int i = 0; i < val.length; i++) {
            h = 57 * (h << 2) + val[i];
        }
        return h;
    }

    private void readFile() throws IOException {
        long start = System.currentTimeMillis();
        SeekableByteChannel sbc = Files.newByteChannel(Paths.get("./URL.txt"),
                StandardOpenOption.READ);
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

    private void insertURL(String URL) {
        for (int i = 0; i < k; i++) {
            int h = hash(URL, i);
            filter[h] = true;
        }
    }

    private boolean isPresent(String URL) {
        for (int i = 0; i < k; i++) {
            int h = hash(URL, i);
            if (!filter[h]) {
                return false;
            }
        }
        return true;
    }

    public static void main(String[] args) {
        bloom b = new bloom();
        b.m = 1000000;
        b.k = 10;
        b.filter = new boolean[b.m];
        b.bloomInit();
        try {
            b.readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
        b.insertURL("http://www.google.com");
        b.insertURL("http://www.amazon.com");
        b.insertURL("http://www.wikipedia.com");
        System.out.println(b.isPresent("http://www.google.com"));
        System.out.println(b.isPresent("http://www.amazon.com"));
        System.out.println(b.isPresent("http://www.wikipedia.com"));
    }
}