package MAIN;

import BRUTEFORCE.Bruteforce;
import CHAINE.Chaine;
import CHAINE.Table;

public class MAIN{
	public static void main(String[] args)
	{
		System.out.println("Start");
		// testBruteforce();
		/* Alice mdp: 45239142
		 * Time: 221 s
		 * Bob mdp: 39175522
		 * Time: 199
		 * Clara mdp: 17441945
		 * Time: 88
		 */
		
		testChaine();
		
		testTable();
		
	}
	
	@SuppressWarnings("unused")
	private static void testBruteforce() {
		Bruteforce Test = new Bruteforce("DD4B21E9EF71E1291183A46B913AE6F2");
		Bruteforce Alice = new Bruteforce("8FC92036B2963C604DC38B2DDB305148");
		Bruteforce Bob = new Bruteforce("367F3AC1129CC92DCBB8C4B9EA4EE55A");
		Bruteforce Clara = new Bruteforce("38251B4C8C210841C60CDE0B7E4C7A87");
		Test.attack();
		System.out.println("Test mdp: "+Test.getmdp()+"\nTime: "+Test.gettime());
		Alice.attack();
		System.out.println("Alice mdp: "+Alice.getmdp()+"\nTime: "+Alice.gettime());
		Bob.attack();		
		System.out.println("Bob mdp: "+Bob.getmdp()+"\nTime: "+Bob.gettime());
		Clara.attack();
		System.out.println("Clara mdp: "+Clara.getmdp()+"\nTime: "+Clara.gettime());
	}
	

	private static void testChaine() {
		Chaine Processor = new Chaine();
		int P999 = Processor.calculChaine(1);
		System.out.println("calculChaine(1): "+P999);
	}	
	
	private static void testTable() {
		Table T = new Table();
		for(int i=0; i<10; i++)
			System.out.println("Noeud["+i+"]=("+T.HashTable[i].px+","+T.HashTable[i].p999+")");
		String mdp;
		mdp = T.lookup("8FC92036B2963C604DC38B2DDB305148");
		System.out.println("Alice mdp: "+mdp+"\nTime: 0");
		mdp = T.lookup("367F3AC1129CC92DCBB8C4B9EA4EE55A");
		System.out.println("Bob mdp: "+mdp+"\nTime: 0");
		mdp = T.lookup("38251B4C8C210841C60CDE0B7E4C7A87");
		System.out.println("Clara mdp: "+mdp+"\nTime: 0");
	}
	
}