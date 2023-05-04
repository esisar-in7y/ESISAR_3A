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
        int p999 = 0;
        for (int i = 0; i < 1000; i++) {
            String str = String.format("%08d", px);
            String hash = "";
            try {
                hash = hash(str, digest);
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            }
            byte[] bs = String2Bytes(hash);
            p999 = reduction(bs, i);
            px = p999;
        }
        return p999;
    }

    public static void main(String[] args) {
        try {
            MessageDigest digest = MessageDigest.getInstance("MD5");
            if(calculDeChaine(1, digest)==43183201){
                System.out.println("OK");
            }else{
                System.out.println("KO");
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }
}
