package CHAINE;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Chaine{

	private MessageDigest digest;
	@SuppressWarnings("unused")
	private long time;
	
	public Chaine()
	{
		try {
			digest = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			System.exit(1);
		}
		this.time=0;
	}
	
	
	public byte[] hashbytes(String str) {
		return digest.digest(str.getBytes());
	}
	

	public String bytes2str(byte[] hash) {
		StringBuilder sb = new StringBuilder();
		for (byte b : hash){
			sb.append(String.format("%02X", b));
		}
		return sb.toString();
	}	
	

	public byte[] str2bytes(String str) {
		int len = str.length();
		byte[] data = new byte[len / 2];
		for (int i = 0; i < len; i += 2) {
			data[i/2] = (byte) ((Character.digit(str.charAt(i), 16) << 4) + Character.digit(str.charAt(i+1), 16));
		}
		return data;
	}
	
	public int reduction(byte[] bs,int num) {
		int res = num;
		int mult = 1;
		for (int i = 0; i <8 ; i++){
			res = res+mult*( (bs[i]+256) % 10);
			mult = mult*10;
			}
		return res % 100000000;
	}
	
	public int calculChaine(int px) {
		if(px>99999999) px=99999999;
		byte[] bytes;
		for (int i = 0; i <1000 ; i++){
			String str = String.format("%08d", px);
			/*
			String hash = hash(str);
			bytes = str2bytes(hash);
			*/
			bytes = hashbytes(str);
			px = reduction(bytes,i);
		}
		
	return px;
	}
	
	public int calculChaine(int px, int start) {
		return calculChaine(px, start, 1000);
	}
	
	public int calculChaine(int px, int start, int to) {
		if(px>99999999) px=99999999;
		byte[] bytes;
		for (int i = start; i <to ; i++){
			String str = String.format("%08d", px);
			bytes = hashbytes(str);
			px = reduction(bytes,i);
		}
		
	return px;
	}
	
	public int calculChaine(int px, int start, int to, boolean afficher) {
		if(px>99999999) px=99999999;
		byte[] bytes;
		for (int i = start; i <to ; i++){
			String str = String.format("%08d", px);
			bytes = hashbytes(str);
			px = reduction(bytes,i);
			if(afficher) {
				System.out.println(str+" -> "+bytes2str(bytes)+" -> "+px);
			}
		}
		
	return px;
	}
}