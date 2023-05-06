package BRUTEFORCE;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Duration;
import java.time.Instant;

public class Bruteforce{

	private MessageDigest digest;
	private String targetHash;
	private String mdp;
	private long time;
	
	public Bruteforce(String hash)
	{
		try {
			digest = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			System.exit(1);
		}
		this.targetHash=hash;
		this.mdp="";
		this.time=0;
	}
	
	public String getmdp() {
		return this.mdp;
	}
	
	public long gettime() {
		return this.time;
	}
	
	private String hash(String str) {
		byte[] hash = digest.digest(str.getBytes());
		// Affichage
		StringBuilder sb = new StringBuilder();
		for (byte b : hash){
			sb.append(String.format("%02X", b));
		}
		return sb.toString();
	}	
	
	public String attack() {
		String str,hash;
		Instant debut = Instant.now();
		for (int i=0; i< 99999999; i++ ) {
			str = String.format("%08d", i);
			hash = hash(str);
			if (this.targetHash.equals(hash)) {
				this.time = Duration.between(debut, Instant.now()).getSeconds();
				this.mdp = str;
				return str;
			}
		}
		
		return "";
	}
}