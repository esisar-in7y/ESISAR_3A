package IO;

import java.io.*;
import java.util.NoSuchElementException;

public class FindArray {

    public int findElement(int[] array, int element) throws NoSuchElementException {
        try {
            for (int i = 0; i < array.length; i++) {
                if (i == element) {
                    System.out.println("Found");
                    return i;
                }
            }
            System.out.println("Not found");
        } catch (Exception e) {
            throw new NoSuchElementException();
        }
        return -1;
    }

    public int findPattern(String[] array) throws NoSuchElementException {
        for (String s : array) {
            try {
                return Integer.parseInt(s);
            } catch (Exception e) {}
        }
        System.out.println("Not found");
        throw new NoSuchElementException();
        return -1;
    }
}
