package com.blood.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DBConnection {
    private static final Properties SETTINGS = new Properties();
    static {
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in == null) throw new IllegalStateException("db.properties is missing from the application classpath");
            SETTINGS.load(in);
            Class.forName(SETTINGS.getProperty("jdbc.driver", "oracle.jdbc.OracleDriver"));
        } catch (Exception ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }
    private DBConnection() { }
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(SETTINGS.getProperty("jdbc.url"),
                SETTINGS.getProperty("jdbc.username"), SETTINGS.getProperty("jdbc.password"));
    }
}
