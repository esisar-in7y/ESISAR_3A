
// package calculchaine;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
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

    private static String crackPassword(String targetHash, Noeud[] table, MessageDigest digest) {
        byte[] targetBytes = String2Bytes(targetHash);
        int targetP999=0;
        Noeud targetNoeud;
        int candidatePx;
        String candidateHash;
        String candidatePwd;
        byte[] candidateBytes;
        for (int i = 0; i < 1000; i++) {
            targetP999 = reduction(targetBytes, i);
            targetNoeud = get(table, targetP999);
            if (targetNoeud != null) {
                candidatePx = targetNoeud.px;
                for (int j = 0; j <= i; j++) {
                    candidatePwd = String.format("%08d", candidatePx);
                    try {
                        candidateHash = hash(candidatePwd, digest);
                        if (candidateHash.equals(targetHash)) {
                            return candidatePwd;
                        }
                    } catch (NoSuchAlgorithmException e) {
                        e.printStackTrace();
                    }
                    candidateBytes = String2Bytes(candidateHash);
                    candidatePx = reduction(candidateBytes, j);
                }
            }
        }
        return null;
    }

    private static Noeud[] read() {
        Noeud[] table = new Noeud[1_000_003];
        try {
            File myObj = new File("table.txt");
            Scanner myReader = new Scanner(myObj);
            while (myReader.hasNextLine()) {
                String data = myReader.nextLine();
                String[] splited = data.split("\\s+");
                insert(table, Integer.parseInt(splited[1]),new Noeud(Integer.parseInt(splited[0]), Integer.parseInt(splited[1])));
            }
            myReader.close();
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
        return table;
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
        Noeud[] table = read();
        String[] to_find = {
                "38251B4C8C210841C60CDE0B7E4C7A87",
                "367F3AC1129CC92DCBB8C4B9EA4EE55A",
                "8FC92036B2963C604DC38B2DDB305148"
        };
        try {
            MessageDigest digest = MessageDigest.getInstance("MD5");
            for(String s : to_find){
                crackPassword(s, table, digest);
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }
}