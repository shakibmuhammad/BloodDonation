package com.blood.util;

import java.util.Arrays;
import java.util.regex.Pattern;

public final class Validator {
    private static final Pattern EMAIL = Pattern.compile("^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE = Pattern.compile("^(?:\\+?880|0)1[3-9]\\d{8}$");
    private static final Pattern USERNAME = Pattern.compile("^[A-Za-z0-9._-]{3,60}$");
    private static final String[] BLOOD_GROUPS = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
    private Validator() { }
    public static String clean(String value) { return value == null ? "" : value.trim(); }
    public static boolean email(String value) { return value != null && value.length() <= 160 && EMAIL.matcher(value.trim()).matches(); }
    public static boolean username(String value) { return value != null && USERNAME.matcher(value).matches(); }
    public static boolean phone(String value) { return value != null && PHONE.matcher(value.replaceAll("[ -]", "")).matches(); }
    public static boolean bloodGroup(String value) { return Arrays.asList(BLOOD_GROUPS).contains(value); }
    public static boolean required(String value, int max) { return value != null && !value.trim().isEmpty() && value.trim().length() <= max; }
    public static Long positiveId(String value) {
        try { long id = Long.parseLong(value); return id > 0 ? id : null; } catch (Exception ex) { return null; }
    }
    public static boolean password(String value) { return value != null && value.length() >= 8 && value.length() <= 100; }
}
