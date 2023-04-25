package IO;

import java.io.*;

public class FindArray {

    public void findElement(int[] array, int element) {
        // TODO : implement this method
        for (int i : array) {
            if (i == element) {
                System.out.println("Found");
                return;
            }
        }
        System.out.println("Not found");
    }
}
