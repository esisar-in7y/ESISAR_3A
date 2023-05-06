
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
    // private static String crackPassword(String targetHash, Noeud[] table,
    // MessageDigest digest) throws NoSuchAlgorithmException {
    // for (int i = 999; i >= 0; i--) {
    // byte[] targetBytes = String2Bytes(targetHash);
    // int targetInt = reduction(targetBytes, i);
    // for (int j = i; j < 1000; j++) {
    // targetBytes = String2Bytes(hash(String.format("%08d", targetInt), digest));
    // targetInt = reduction(targetBytes, j);
    // }
    // Noeud node = get(table, targetInt);

    // if (node != null) {
    // int candidateInt = node.px;
    // String candidateHash;

    // for (int j = 0; j <= i; j++) {
    // String candidateStr = String.format("%08d", candidateInt);
    // if(
    // candidateStr.equals("17441945") ||
    // candidateStr.equals("45239142") ||
    // candidateStr.equals("39175522")
    // ){
    // System.out.println("candidatePx:"+candidateStr);
    // }
    // candidateHash = hash(candidateStr, digest);

    // if (candidateHash.equals(targetHash)) {
    // return candidateStr;
    // }

    // byte[] candidateBytes = String2Bytes(candidateHash);
    // candidateInt = reduction(candidateBytes, j);
    // }
    // }
    // }

    // return null;
    // }

    // private static String crackPassword(String targetHash, Noeud[] table,
    // MessageDigest digest) throws NoSuchAlgorithmException {
    // for (int i = 0; i < 1000; i++) {
    // int p = reduction(String2Bytes(targetHash), i);
    // Noeud noeud = get(table, p);

    // if (noeud != null) {
    // int p1 = noeud.px;
    // int p2 = noeud.p999;
    // for (int j = 0; j < 1000; j++) {
    // String potentialPassword = String.format("%08d", p1);
    // if(
    // potentialPassword.equals("17441945") ||
    // potentialPassword.equals("45239142") ||
    // potentialPassword.equals("39175522")
    // ){
    // System.out.println("candidatePx:"+potentialPassword);
    // }
    // String potentialHash = hash(potentialPassword, digest);
    // if (potentialHash.equals(targetHash)) {
    // return potentialPassword;
    // }
    // p1 = reduction(String2Bytes(potentialHash), p2);
    // p2++;
    // }
    // }

    // targetHash = hash(String.format("%08d", reduction(String2Bytes(targetHash),
    // i)), digest);
    // }

    // return "Password not found";
    // }

    private static String crackPassword(String targetHash, Noeud[] table, MessageDigest digest) {
        System.out.println("Cracking " + targetHash);
        byte[] targetBytes = String2Bytes(targetHash);
        int targetP999 = 0;
        Noeud targetNoeud;
        int candidatePx;
        String candidateHash;
        String candidatePwd;
        byte[] candidateBytes;
        byte[] bytes;
        String str;
        try {
            for (int i = 999; i >= 0; i--) {
                targetP999 = reduction(targetBytes, i);
                for (int j = i; j < 999; j++) {
                //TODO
                str = String.format("%08d", targetP999);
                bytes = String2Bytes(hash(str,digest));
                targetP999 = reduction(bytes,j);
                }
                targetNoeud = get(table, targetP999);
                // System.out.println("targetNoeud:"+targetNoeud);
                if (targetNoeud != null) {
                    // System.out.println("Found " + targetNoeud.px + " " + targetNoeud.p999);
                    candidatePx = targetNoeud.px;
                    // System.out.println("targetHash:"+targetHash);
                    for (int k = 1; k < 1000; k++) {
                        candidatePwd = String.format("%08d", candidatePx);
                        if (candidatePwd.equals("17441945")) {
                            System.out.println("candidatePx:" + candidatePx + " targetPx:" + targetP999
                                    + "candidatePwd:" + candidatePwd);
                        }
                        candidateHash = hash(candidatePwd, digest);
                        // System.out.println("candidateHash:"+candidateHash);
                        if (candidateHash.equals(targetHash)) {
                            return candidatePwd;
                        }
                        candidateBytes = String2Bytes(candidateHash);
                        // System.out.println("candidateBytes:"+candidateBytes);
                        candidatePx = reduction(candidateBytes, k);
                        // System.out.println("candidatePx:"+candidatePx);
                    }
                }
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
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
                // insert(table, Integer.parseInt(splited[1]),new
                // Noeud(Integer.parseInt(splited[1]), Integer.parseInt(splited[0])));
                insert(table, Integer.parseInt(splited[1]),
                        new Noeud(Integer.parseInt(splited[0]), Integer.parseInt(splited[1])));
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
            for (String s : to_find) {
                System.out.println("Answer:" + crackPassword(s, table, digest));
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }
}
