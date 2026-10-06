package com.shopsphere.web;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

public final class UrlConnectionDemo {
    private UrlConnectionDemo() {}
    public static String read(String urlText) throws Exception {
        URL url = new URL(urlText);
        URLConnection connection = url.openConnection();
        connection.setConnectTimeout(3000);
        connection.setReadTimeout(3000);
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
            StringBuilder out = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null && out.length() < 4000) out.append(line).append(System.lineSeparator());
            return out.toString();
        }
    }
    public static void main(String[] args) throws Exception {
        System.out.println(read(args.length == 0 ? "https://example.com" : args[0]));
    }
}
