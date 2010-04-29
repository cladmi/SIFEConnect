import java.util.*;
import java.sql.*;
import java.security.*;
import org.json.simple.*;

import org.psafix.memopwd.Owasp;

public class DatabaseAccess {

	private Connection connection;   
	private PreparedStatement pstmt;
	private ResultSet rset;


	boolean Auth(String login, String passwd) {
		boolean passwordCorrect = false;
		Owasp owasp = new Owasp();
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			Class.forName("org.sqlite.JDBC");
			connection = DriverManager.getConnection("jdbc:sqlite3:passwd.db");  
			passwordCorrect = owasp.authenticate(connection, login.toLowerCase(), passwd);
			connection.close();
			// password checked
			
			return passwordCorrect;

		} catch (Exception e) {  
			e.printStackTrace();  
		}
		return false;
	}

	public boolean getInfos(String login, JSONObject object, boolean connAccepted) {


		return false;
	}


	String listCountries() throws SQLException, ClassNotFoundException {
		Class.forName("org.sqlite.JDBC");

		JSONObject obj = null;
		
		// attach database
		PreparedStatement pst = null;
		// continents query
		PreparedStatement pstmt = null;
		ResultSet srs = null;
		// countries query
		PreparedStatement pstmtCountry = null;
		ResultSet srsCountry = null;

		int idCountry;
		String country;
		int idContinent;
		String continent;


		try {
			connection = DriverManager.getConnection("jdbc:sqlite:countries.db");  
			pst = connection.prepareStatement("ATTACH DATABASE 'teams.db' AS T");
			pstmt = connection.prepareStatement("SELECT idContinent, nameContinent FROM continent ORDER BY nameContinent ASC");
			srs = pstmt.executeQuery();

			pstmtCountry = connection.prepareStatement("SELECT idCountry, nameCountry FROM country WHERE idContinent = ? AND idCountry IN (SELECT idCountry FROM T.teams) ORDER BY nameCountry ASC");

			pst.execute();
			pst.close();

			/* {"header" : "World", "sections" : []} */
			obj = new JSONObject();
			obj.put("header", "World");

			/* [{continent}, {...}] */
			LinkedList continentTable = new LinkedList();
			while (srs.next()) {

				idContinent = srs.getInt("id");
				continent = srs.getString("name");

				/* countries query */
				pstmtCountry.setInt(1, idContinent);
				srsCountry = pstmtCountry.executeQuery();

				LinkedList countryTable = new LinkedList();
				while (srsCountry.next()) {
					/* 
					 * add a country 
					 */
					idCountry = srsCountry.getInt("id");
					country = srsCountry.getString("name");

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
				continentCell.put("row", countryTable);

				/* add and clear */
				continentTable.add(continentCell);
				srsCountry.close();
				pstmtCountry.clearParameters();
				/* fin traitement continent */
			}						
			obj.put("section", continentTable);
			/* close the connection */
			pstmtCountry.close();
			srs.close();
			pstmt.close();
			connection.close();  
			
			return obj.toString();
		} catch (Exception e) {  
			e.printStackTrace();  
		}
		return null;
	}
}



