package util;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FileHandler {

    private static final String DATA_FOLDER =
            System.getProperty("user.home") + File.separator + "HomeTutorData";

    private static File getFile(String fileName) throws IOException {
        File folder = new File(DATA_FOLDER);

        if (!folder.exists()) {
            folder.mkdirs();
        }

        File file = new File(folder, fileName);

        if (!file.exists()) {
            file.createNewFile();
        }

        return file;
    }

    public static void writeToFile(String fileName, String data) {
        try {
            FileWriter writer = new FileWriter(getFile(fileName), true);
            writer.write(data + System.lineSeparator());
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static List<String> readFromFile(String fileName) {
        List<String> records = new ArrayList<>();

        try {
            BufferedReader reader = new BufferedReader(new FileReader(getFile(fileName)));
            String line;

            while ((line = reader.readLine()) != null) {
                records.add(line);
            }

            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return records;
    }

    public static void overwriteFile(String fileName, List<String> records) {
        try {
            FileWriter writer = new FileWriter(getFile(fileName), false);

            for (String record : records) {
                writer.write(record + System.lineSeparator());
            }

            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}