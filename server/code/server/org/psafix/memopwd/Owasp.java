 package org.psafix.memopwd;
 
 import java.security.MessageDigest;
 import java.security.NoSuchAlgorithmException;
 import java.io.IOException;
 import sun.misc.BASE64Decoder;
 import sun.misc.BASE64Encoder;
 import java.sql.*;
 import java.util.Arrays;
 import java.security.SecureRandom;
 
 public class Owasp {
   private final static int ITERATION_NUMBER = 1000;
 
   public Owasp() {
   }
 
   /**
    * Authenticates the user with a given login and password
    * If password and/or login is null then always returns false.
    * If the user does not exist in the database returns false.
    * @param con Connection An open connection to a databse
    * @param login String The login of the user
    * @param password String The password of the user
    * @return boolean Returns true if the user is authenticated, false otherwise
    * @throws SQLException If the database is inconsistent or unavailable (
    *           (Two users with the same login, salt or digested password altered etc.)
    * @throws NoSuchAlgorithmException If the algorithm SHA-1 is not supported by the JVM
    */
   public boolean authenticate(Connection con, String login, String password)
           throws SQLException, NoSuchAlgorithmException, java.io.UnsupportedEncodingException {
       boolean authenticated=false;
       PreparedStatement ps = null;
       ResultSet rs = null;
       try {
           boolean userExist = true;
           // INPUT VALIDATION
           if (login==null||password==null){
               // TIME RESISTANT ATTACK
               // Computation time is equal to the time needed by a legitimate user
               userExist = false;
               login="";
               password="";
           }
 
           ps = con.prepareStatement("SELECT passwd, salt FROM passTable WHERE login = ?");
           ps.setString(1, login);
           rs = ps.executeQuery();
           String digest, salt;
           if (rs.next()) {
               digest = rs.getString("passwd");
               salt = rs.getString("salt");
               // DATABASE VALIDATION
               if (digest == null || salt == null) {
                   throw new SQLException("Database inconsistant Salt or Digested Password altered");
               }
               if (rs.next()) { // Should not append, because login is the primary key
                   throw new SQLException("Database inconsistent two passTableS with the same login");
               }
           } else { // TIME RESISTANT ATTACK (Even if the user does not exist the
               // Computation time is equal to the time needed for a legitimate user
               digest = "000000000000000000000000000=";
               salt = "00000000000=";
               userExist = false;
           }
 
           byte[] bDigest = base64ToByte(digest);
           byte[] bSalt = base64ToByte(salt);
 
           // Compute the new DIGEST
           byte[] proposedDigest = getHash(ITERATION_NUMBER, password, bSalt);
 
           return Arrays.equals(proposedDigest, bDigest) && userExist;
       } catch (IOException ex){
           throw new SQLException("Database inconsistant Salt or Digested Password altered");
       }
       finally{
           close(rs);
           close(ps);
       }
   }
 
 
 
   /**
    * Inserts a new user in the database
    * @param con Connection An open connection to a databse
    * @param login String The login of the user
    * @param password String The password of the user
    * @return boolean Returns true if the login and password are ok (not null and length(login)<=100
    * @throws SQLException If the database is unavailable
    * @throws NoSuchAlgorithmException If the algorithm SHA-1 or the SecureRandom is not supported by the JVM
    */
   public boolean createUser(Connection con, String login, String password)
           throws SQLException, NoSuchAlgorithmException, java.io.UnsupportedEncodingException
   {
       PreparedStatement ps = null;
       try {
           if (login!=null&&password!=null&&login.length()<=100){
               // Uses a secure Random not a simple Random
               SecureRandom random = SecureRandom.getInstance("SHA1PRNG");
               // Salt generation 64 bits long
               byte[] bSalt = new byte[8];
               random.nextBytes(bSalt);
               // Digest computation
               byte[] bDigest = getHash(ITERATION_NUMBER,password,bSalt);
               String sDigest = byteToBase64(bDigest);
               String sSalt = byteToBase64(bSalt);
 
               ps = con.prepareStatement("INSERT INTO passTable (login, passwd, salt) VALUES (?,?,?)");
               ps.setString(1,login);
               ps.setString(2,sDigest);
               ps.setString(3,sSalt);
               ps.executeUpdate();
               return true;
           } else {
               return false;
           }
       } finally {
           close(ps);
       }
   }
 
 
   /**
    * From a password, a number of iterations and a salt,
    * returns the corresponding digest
    * @param iterationNb int The number of iterations of the algorithm
    * @param password String The password to encrypt
    * @param salt byte[] The salt
    * @return byte[] The digested password
    * @throws NoSuchAlgorithmException If the algorithm doesn't exist
    */
   public byte[] getHash(int iterationNb, String password, byte[] salt) throws NoSuchAlgorithmException, java.io.UnsupportedEncodingException {
       MessageDigest digest = MessageDigest.getInstance("SHA-1");
       digest.reset();
       digest.update(salt);
       byte[] input = digest.digest(password.getBytes("UTF-8"));
       for (int i = 0; i < iterationNb; i++) {
           digest.reset();
           input = digest.digest(input);
       }
       return input;
   }
 
 
   public void creerTable(Connection con) throws SQLException{
       Statement st = null;
       try {
           st = con.createStatement();
           st.execute("CREATE TABLE passTable (login VARCHAR(100) PRIMARY KEY, passwd VARCHAR(32) NOT NULL, salt VARCHAR(32) NOT NULL)");
       } finally {
           close(st);
       }
   }
 
 
 
   /**
    * Closes the current statement
    * @param ps Statement
    */
   public void close(Statement ps) {
       if (ps!=null){
           try {
               ps.close();
           } catch (SQLException ignore) {
           }
       }
   }
 
   /**
    * Closes the current resultset
    * @param ps Statement
    */
   public void close(ResultSet rs) {
       if (rs!=null){
           try {
               rs.close();
           } catch (SQLException ignore) {
           }
       }
   }
 
 
   /**
    * From a base 64 representation, returns the corresponding byte[] 
    * @param data String The base64 representation
    * @return byte[]
    * @throws IOException
    */
   public static byte[] base64ToByte(String data) throws IOException {
       BASE64Decoder decoder = new BASE64Decoder();
       return decoder.decodeBuffer(data);
   }
 
   /**
    * From a byte[] returns a base 64 representation
    * @param data byte[]
    * @return String
    * @throws IOException
    */
   public static String byteToBase64(byte[] data){
       BASE64Encoder endecoder = new BASE64Encoder();
       return endecoder.encode(data);
   }
}
