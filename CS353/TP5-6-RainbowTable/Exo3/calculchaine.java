// package calculchaine;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter; // Import the FileWriter class
import java.io.IOException;

public class calculchaine {

    private static String hash(String str, MessageDigest digest) throws NoSuchAlgorithmException {
        byte[] hash = digest.digest(str.getBytes());
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02X", b));
        }
        return sb.toString();
    }

    private static byte[] String2Bytes(String s) {
        // Conversion de s en un tableau de byte, le premier byte est 0x40 , le deuxième
        // 0x41 , et ainsi de suite
        int len = s.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4) + Character.digit(s.charAt(i + 1), 16));
        }
        return data;
    }

    private static int reduction(byte[] bs, int num) {
        int res = num;
        int mult = 1;
        for (int i = 0; i < 8; i++) {
            res = res + mult * ((bs[i] + 256) % 10);
            mult = mult * 10;
        }
        return res % 100_000_000;
    }

    private static int calculDeChaine(int px, MessageDigest digest) // entier compris entre 1 et 99999999
    {
        String int_str;
        String hash = "";
        byte[] bs;
        for (int i = 0; i < 1000; i++) {
            int_str = String.format("%08d", px);
            try {
                hash = hash(int_str, digest);
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            }
            bs = String2Bytes(hash);
            px = reduction(bs, i);
        }
        return px;
    }
    private static void write(Noeud[] table) {
        try {
			FileWriter myWriter = new FileWriter("table.txt");
			for (Noeud tmp : table) {
				if (tmp != null){
                    myWriter.write(tmp.px + " " + tmp.p999 + "\n");
                }
			}
			myWriter.close();
			System.out.println("Successfully wrote to the file.");
		} catch (IOException e) {
			System.out.println("An error occurred.");
		}
    }
    private static Noeud get(Noeud[] table, int p999) {
        int i = 0;
        while (table[(p999 + i) % table.length] != null) {
            if (table[(p999 + i) % table.length].p999 == p999) {
                return table[(p999 + i) % table.length];
            }
            i++;
        }
        return null;
	}
    private static void insert(Noeud[] table, int p999, Noeud noeud) {
        int i = 0;
        while (table[(p999 + i) % table.length] != null) {
            i++;
        }
        table[(p999 + i) % table.length] = noeud;
    }
    public static void main(String[] args) {
        Random r = new Random(0);
        Noeud[] table = new Noeud[1_000_003];
        int px = 0;
        int p999=0;
        try {
            MessageDigest digest = MessageDigest.getInstance("MD5");
            for (int i = 0; i < 1_000_000 /*1_000_000*/; i++) {
                if (i % 100 == 0) {
                    System.out.print(i+":"+(i*100.0f/1_000_000) + "\r");
                    System.out.flush();
                }
                px = r.nextInt(100_000_000);
                p999=calculDeChaine(px, digest);
                if(get(table, p999)==null){
                    insert(table, p999,new Noeud(px, p999));
                }
            }
            write(table);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }
}
