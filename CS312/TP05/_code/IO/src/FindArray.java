package IO;

import java.io.*;
import java.util.NoSuchElementException;

public class FindArray {

    public void findElement(int[] array, int element) {
        // TODO : implement this method
        try {
			for (int i : array) {
                if (i == element) {
                    System.out.println("Found");
                    return;
                }
            }
            System.out.println("Not found");
		} 
        catch(Exception e) {
            throw new NoSuchElementException();
        }
    }
}
