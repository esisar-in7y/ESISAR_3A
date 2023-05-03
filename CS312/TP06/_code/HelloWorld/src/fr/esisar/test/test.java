package fr.esisar.test;

// import csv.CSVFormat;
// import csv.CSVRecord;
// import commons.csv.*;

import org.apache.commons.csv.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList; 
import java.util.List;
import java.util.UUID;
import java.io.StringReader;
import java.io.Reader;

public class test {
    public void Test() {
        Reader in = new StringReader("a,b,c");
        try {
            for (CSVRecord record : CSVFormat.DEFAULT.parse(in)) {
                for (String field : record) {
                    System.out.print("\"" + field + "\", ");
                }
                System.out.println();
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }
    // public List<Person> read(Path path) {
    // List<Person> list = List.of(); // Default to empty list.
    // try {
    // // Prepare list.
    // int initialCapacity = (int) Files.lines(path).count();
    // list = new ArrayList<>(initialCapacity);

    // // Read CSV file. For each row, instantiate and collect `Person`.
    // BufferedReader reader = Files.newBufferedReader(path,
    // StandardCharsets.UTF_8);
    // Iterable<CSVRecord> records =
    // CSVFormat.RFC4180.withFirstRecordAsHeader().parse(reader);
    // for (CSVRecord record : records) {
    // String givenName = record.get("givenName");
    // String surname = record.get("surname");
    // UUID id = UUID.fromString(record.get("id"));
    // String description = record.get("description");
    // // Instantiate `Person` object, and collect it.
    // Person person = new Person(givenName, surname, id, description);
    // list.add(person);
    // }
    // } catch (IOException e) {
    // e.printStackTrace();
    // }
    // return list;
    // }
}