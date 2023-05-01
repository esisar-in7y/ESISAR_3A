package table;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;


public class table {
    public noeud[] table = new noeud[10061];

    public String Int2String(int i) {
        String str = String.format("%08d", i);
        return str;
    }

    public String hash(String str) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("MD5");
        byte[] hash = digest.digest(str.getBytes());
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02X", b));
        }
        return sb.toString();
    }

    public byte[] String2Bytes(String s) {
        // Conversion de s en un tableau de byte, le premier byte est 0x40 , le deuxième
        // 0x41 , et ainsi de suite
        int len = s.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4) + Character.digit(s.charAt(i + 1), 16));
        }
        return data;
    }

    private int reduction(byte[] bs, int num) {
        int res = num;

        int mult = 1;

        for (int i = 0; i < 8; i++) {
            res = res + mult * ((bs[i] + 256) % 10);
            mult = mult * 10;
        }
        return res % 100_000_000;
    }

    public int calculDeChaine(int px) // entier compris entre 1 et 99999999
    {
        int p999 = 0;
        for (int i = 0; i < 1000; i++) {
            String str = Int2String(px);
            String hash = "";
            try {
                hash = hash(str);
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            }
            byte[] bs = String2Bytes(hash);
            p999 = reduction(bs, i);
            px = p999;
        }
        return p999;
    }

    public int randomIndex() {
        Random r = new Random(0);
        int a0 = r.nextInt(100_000_000); // Genere un premier nombre entre 0 et 99_999_999
        System.out.println("A0=" + a0);
        int a1 = r.nextInt(100_000_000); // Genere un deuxième nombre entre 0 et 99_999_999
        System.out.println("A1=" + a1);
        return a0;
    }

    public table() {
        int randomNumber;
        for (int i = 0; i < 100_000_000; i++) {
            randomNumber = randomIndex();
            int p999 = calculDeChaine(randomNumber);
            int px = randomNumber;
            table[i] = new noeud(px, p999);
        }
    }

    public static void main(String[] args) {
        table t = new table();
        System.out.println(t.table[0].px);
        System.out.println(t.table[0].p999);
    }
}