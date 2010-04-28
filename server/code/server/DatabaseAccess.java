import java.util.*;
import java.sql.*;
import java.security.*;
import org.json.simple.*;

public class DatabaseAccess {



	private Connection connection;   
	private PreparedStatement pstmt;
	private ResultSet rset;




	/* return 0 if the User was not found */
	int Authentificate(String login, String passwd) throws SQLException, ClassNotFoundException {
		String hash;
		String storedSalt, storedHash;
		int storedId; // I use the 0 value for not found users

		Class.forName("org.sqlite.JDBC");
		/* sqlite reading */
		connection = DriverManager.getConnection("jdbc:sqlite3:passwd.db");  
		try {
			PreparedStatement pstmt = connection.prepareStatement("SELECT id, salt, hashedPasswd FROM account WHERE login = ?");
			pstmt.setString(1, login);
			rset = pstmt.executeQuery();

			if (rset.next()) {
				/* user found */
				storedSalt = rset.getString("salt");
				storedHash = rset.getString("hashedPasswd");
				storedId = rset.getInt("id");

			} else {
				/* user not found, I just put some values
				 * so it takes the same time */
				storedSalt = "00000000";
				storedHash = "000000000000";
				storedId = 0;
			}

			System.out.println("StoredSalt = " + storedSalt);
			System.out.println("StoredHash = " + storedHash);
			System.out.println("StoredId   = " + storedId);

			pstmt.close();
			rset.close();
			connection.close();  
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			digest.reset();
			digest.update(storedSalt.getBytes("UTF-8"));
			digest.update(passwd.getBytes("UTF-8"));
			hash = new String(digest.digest());

			if (hash.equals("storedHash"))
				return storedId;


			// if there is a problem, we return 0
		} catch (Exception e) {  
			e.printStackTrace();  
			try {
				pstmt.close();
				rset.close();
				connection.close();  
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		return 0;
	}


	Object selectList(int idContinent, int idCountry) throws SQLException, ClassNotFoundException {
		Class.forName("org.sqlite.JDBC");

		/* {[]} */
		JSONObject obj = new JSONObject();
		// session_id
		PreparedStatement pstmt = null;
		PreparedStatement pstmtCountry = null;
		PreparedStatement pst = null;
		ResultSet srs = null;
		ResultSet srsCountry = null;
		int idCountry;
		String country;
		int idContinent;
		String continent;

/* con */
		connection = DriverManager.getConnection("jdbc:sqlite:country.db");  


		try {
			pst = connection.prepareStatement("ATTACH DATABASE 'country.db' AS country");
			pstmt = connection.prepareStatement("SELECT id, name FROM continent ORDER BY name ASC");
			srs = pstmt.executeQuery();

			pstmtCountry = connection.prepareStatement("SELECT id, name FROM country WHERE idC = ? AND idC IN (SELECT idC FROM country.country) ORDER BY name ASC");

			pst.execute();
			pst.close();
			/* [{continent}, {...}] */
			LinkedList continentTable = new LinkedList();
			while (srs.next()) {
				/* 
				 * add a continent
				 */	
				idContinent = srs.getInt("id");
				continent = srs.getString("name");

				/* continent query */
				pstmtCountry.setInt(1, idContinent);
				srsCountry = pstmtCountry.executeQuery();

				LinkedList countryTable = new LinkedList();
				while (srsCountry.next()) {
					/* 
					 * add a country 
					 */
					idCountry = srsCountry.getInt("id");
					country = srsCountry.getString("name");

					/*
					 *	Need to check if there are teams in this country
					 *	Done by the SQL query
					 */

					/* {"id" : int, "name" : String} <= Country*/
					LinkedHashMap countryCell = new LinkedHashMap();
					countryCell.put("id", idCountry);
					countryCell.put("name", country);
					countryTable.add(countryCell);
				}
				if (countryTable.isEmpty()) {
					/* if there are no teams in this continent for the moment we put some text */
					LinkedHashMap countryCell = new LinkedHashMap();
					countryCell.put("id", 0);
					countryCell.put("name", "No teams for the moment");
					countryTable.add(countryCell);
				}

				/* {"id" : int, "name" : String, country : [...]} */
				LinkedHashMap continentCell = new LinkedHashMap();
				continentCell.put("id", idContinent);
				continentCell.put("name", continent);
				continentCell.put("country", countryTable);
				pstmtCountry.clearParameters();

				/* add and close */
				continentTable.add(continentCell);
				pstmtCountry.close();
				srsCountry.close();
				/* fin traitement continent */
			}						
			/* close the connection */
			pstmt.close();
			srs.close();
			connection.close();  
		} catch (Exception e) {  
			e.printStackTrace();  
		}



		return obj;

	}


}



