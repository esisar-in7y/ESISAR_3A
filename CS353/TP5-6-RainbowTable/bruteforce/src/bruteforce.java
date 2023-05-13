import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter; // Import the FileWriter class
import java.io.IOException;

public class bruteforce {
	public static void main(String[] args) throws NoSuchAlgorithmException {
		Noeud[] table = loadfromfile();
		String hash_string = args[0];
		byte[] hash_bytes = hash_string.getBytes();
		Noeud found = null;
		int px;
		String str;
		byte[] hash = hash_bytes;
		MessageDigest digest = MessageDigest.getInstance("MD5");
		for (int i = 0; i < 1000; i++) {
			px = reduction(hash, i);
			found = getin(table, px);
			if (found != null) {
				// check from start
				String str_tmp;
				int px_tmp = found.px;
				byte[] hash_tmp;
				for (int j = 0; j < 1000; j++) {
					str_tmp = String.format("%08d", px_tmp);
					hash_tmp = digest.digest(str_tmp.getBytes());
					if(hash_tmp.equals(hash_bytes)) {
						System.out.println(hash_string+" "+str_tmp);
						return;
					}
					px_tmp = reduction(hash_tmp, j);
				}

			}
			str = String.format("%08d", px);
			hash = digest.digest(str.getBytes());
		}
	}

	private static Noeud getin(Noeud[] table, int p999) {
		for (Noeud tmp : table) {
			if (tmp == null)
				return null;
			else if (tmp.p999 == p999) {
				return tmp;
			}
		}
		return null;
	}

	private static boolean isin(Noeud[] table, int p999) {
		boolean is_in = false;
		for (Noeud tmp : table) {
			if (tmp == null)
				break;
			else if (tmp.p999 == p999) {
				is_in = true;
				break;
			}
		}
		return is_in;
	}

	public static Noeud[] loadfromfile() {
		Noeud[] table = new Noeud[1_000_003];
		int i = 0;
		try {
			Scanner scanner = new Scanner(new File("filename.txt"));
			while (scanner.hasNextLine()) {
				String[] parts = scanner.nextLine().split(" ");
				int p999 = Integer.parseInt(parts[0]);
				int px = Integer.parseInt(parts[1]);
				table[i] = new Noeud(px, p999);
				i++;
			}
			scanner.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return table;
	}

	public static void writetofile(Noeud[] table) {
		try {
			FileWriter myWriter = new FileWriter("filename.txt");
			for (Noeud no : table) {
				if (no == null)
					continue;
				myWriter.write(no.p999 + "");
				myWriter.write(" ");
				myWriter.write(no.px + "");
				myWriter.write("\n");
			}
			myWriter.close();
			System.out.println("Successfully wrote to the file.");
		} catch (IOException e) {
			System.out.println("An error occurred.");
			e.printStackTrace();
		}
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

	public static int calculChaine(int px) throws NoSuchAlgorithmException {
		String str;
		byte[] hash;
		MessageDigest digest = MessageDigest.getInstance("MD5");
		for (int i = 0; i < 1000; i++) {
			str = String.format("%08d", px);
			hash = digest.digest(str.getBytes());
			px = reduction(hash, i);
		}
		return px;
	}
}