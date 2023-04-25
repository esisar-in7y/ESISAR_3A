package IO;

import java.io.*;
import java.util.NoSuchElementException;

public class FindArray {

    public int findElement(int[] array, int element) throws NoSuchElementException {
        // TODO : implement this method
        try {
			for (int i = 0; i < array.length; i++) {
                if (i == element) {
                    System.out.println("Found");
                    return i;
                }
            }
            System.out.println("Not found");
		} 
        catch(Exception e) {
            throw new NoSuchElementException();
        }
        return -1;
    }
}
