package CHAINE;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.time.Duration;
import java.time.Instant;
import java.util.Objects;
import java.util.Random;

public class Table{

	public Noeud[] HashTable;
	public int nb_entry;
	public long time;
	
	public Table(){
		Instant debut = Instant.now();
		File file = new File("myarray.ser");
	    if(file.exists())
	    	loadTableFromFile();
	    else
	    	generateTable();
	    
		this.time = Duration.between(debut, Instant.now()).getSeconds();
		System.out.println("Table loaded in "+this.time+"seconds");
	}
	
	
	public void saveTableToFile(){
		System.out.println("Saving Table to myarray.ser");
		try {
			ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream("myarray.ser"));
			out.writeObject(HashTable);
			out.flush();
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		System.out.println("Done");
	}
	
	public void loadTableFromFile(){
		System.out.println("Loading Table from myarray.ser");
		try {
			ObjectInputStream in = new ObjectInputStream(new FileInputStream("myarray.ser"));
			this.HashTable = (Noeud[]) in.readObject();
			in.close();
		} catch (ClassNotFoundException | IOException e) {
			e.printStackTrace();
		}
		
		this.nb_entry = 1_000_000;
		for(int i=0; i<1_000_003; i++)
			if(Objects.isNull(HashTable[i])) {
				this.nb_entry = i;
				break;
			}
		System.out.println("Loaded "+this.nb_entry+" entries");
		System.out.println("Done");
	}
	
	
	public void generateTable(){
		HashTable = new Noeud[1_000_003];
		Chaine C = new Chaine();
		Random r = new Random(0);
		int j=0;
		System.out.println("Generating Table");
		Instant debut = Instant.now();
		for(int i=0; i<999_999; i++) {
			int a = r.nextInt(100_000_000);
			int b = C.calculChaine(a);
			boolean present = false;
			for (Noeud n : HashTable) if(n != null) if(n.p999 == b) { present=true; break; }
			if ( ! present ) {
				//System.out.println("Hash:" + j + " - i:" + i);
				HashTable[j] = new Noeud(a,b);
				j++;
			}
		}
		this.nb_entry = j;
		this.time = Duration.between(debut, Instant.now()).getSeconds();
		System.out.println(j+"entries generated in "+this.time+"secondes");
		
		saveTableToFile();
	}

	
	public String lookup(String hash_str)
	{
		Chaine C = new Chaine();
		byte[] bytes;
		int p999=0, px=0;
		String tmp;
		Instant debut = Instant.now();
		for(int i=0; i<1000; i++) {
			
			bytes = C.str2bytes(hash_str);
			p999 = C.reduction(bytes, 999-i);
			p999 = C.calculChaine(p999,1000-i);
			
			
			//if p999 is in list target_index = xx;
			for(int j =0; j<this.nb_entry; j++)
				if(HashTable[j].p999 == p999) {
					//System.out.println("Found matching Chain");
					//System.out.println("i="+i+" j="+j);
					// nb_reduc -> 1000-i;
					
					px = HashTable[j].px;					
					px = C.calculChaine(px,0,999-i);
					

					tmp = C.bytes2str(C.hashbytes(String.format("%08d", px)));
					if(tmp.equals(hash_str)) {
						//System.out.println("Found matching hash: " + tmp);
						//System.out.println("in chain at index: " + j);
						this.time = Duration.between(debut, Instant.now()).getSeconds();
						return String.format("%08d", px);
					}
					break;
				}
		}
			
		this.time = Duration.between(debut, Instant.now()).getSeconds();
		return "Not found";
	}
	
}