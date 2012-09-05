import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.File;
import java.io.IOException;
import java.lang.Character.UnicodeBlock;
import java.util.HashMap;
import java.util.Map;

import org.stathissideris.ascii2image.core.CommandLineConverter;

public class Jditaa {
    static Map<UnicodeBlock,Integer> widthMap;
    
    static {
        widthMap = new HashMap<UnicodeBlock,Integer>();
        widthMap.put(UnicodeBlock.ARROWS, 2);
        widthMap.put(UnicodeBlock.CJK_COMPATIBILITY, 2);
        widthMap.put(UnicodeBlock.CJK_COMPATIBILITY_FORMS, 2);
        widthMap.put(UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS, 2);
        widthMap.put(UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION, 2);
        widthMap.put(UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS, 2);
        widthMap.put(UnicodeBlock.ENCLOSED_CJK_LETTERS_AND_MONTHS, 2);
        widthMap.put(UnicodeBlock.HIRAGANA, 2);
        widthMap.put(UnicodeBlock.KATAKANA, 2);
    }

    public static int charWidth(char ch) {
        UnicodeBlock block = UnicodeBlock.of(ch);
        Integer w = widthMap.get(block);
        if (w != null) {
            return w;
        }
        return 1;
    }
    
    public static void jditaa(File in, File out) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(in));
        BufferedWriter writer = new BufferedWriter(new FileWriter(out));
        while (true) {
            String line = reader.readLine();
            if (line == null)
                break;
            StringBuilder s = new StringBuilder();
            for (int i = 0; i < line.length(); i++) {
                char ch = line.charAt(i);
                s.append(ch);
                if (Character.isHighSurrogate(ch)) {
                    i++;
                    s.append(line.charAt(i));
                } else {
                    int w = charWidth(ch);
                    for (int k = 1; k < w; k++)
                        s.append(' ');
                }
            }
            s.append('\n');
            writer.write(s.toString());
        }
        writer.close();
        reader.close();
    }
    
    public static void main(String[] args) {
        if (args.length >= 2) {
            try {
                int i = args.length - 2;
                File ditaaFile = new File(args[i]);
                if (ditaaFile.exists()) {
                    File tmpFile = File.createTempFile("temp", "ditaa");
                    tmpFile.deleteOnExit();
                    jditaa(ditaaFile, tmpFile);
                    System.out.println(ditaaFile + " --> " + tmpFile);
                    args[i] = tmpFile.getAbsolutePath();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        CommandLineConverter.main(args);
    }

}