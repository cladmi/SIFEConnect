import java.util.*;
import java.sql.*;
import java.security.*;
import org.json.simple.*;

import org.psafix.memopwd.Owasp;

public class DatabaseAccess {

	private Connection connection;   
	private PreparedStatement pstmt;
	private ResultSet rset;
	private SessionMap Sessions = new SessionMap();


	boolean Auth(String login, String passwd) {
		boolean passwordCorrect = false;
		Owasp owasp = new Owasp();
		try {
			Class.forName("org.sqlite.JDBC");
			connection = DriverManager.getConnection("jdbc:sqlite:accounts.db");  
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
		boolean returnValue = false;
		int id;
		String name;
		String session;

		try {
			connection = DriverManager.getConnection("jdbc:sqlite:teams.db");
			pstmt = connection.prepareStatement("SELECT idTeam, nameTeam FROM team WHERE login = ?;");
			pstmt.setString(1, login.toLowerCase());
			rset = pstmt.executeQuery();
			if (rset.next()) {
				System.out.println("on a trouve le login"); //DEBUG
				id = rset.getInt("idTeam");
				name = rset.getString("nameTeam");
				if (! rset.next()) {
					System.out.println("on a bien un seul login"); // DEBUG
					// if there is only one row for login
					session = Sessions.connect(id);
					object.put("id", new Integer(id));
					object.put("name", name);
					object.put("sessionId", session);
					returnValue = true;
				}
			}
			rset.close();
			pstmt.close();
			connection.close();
		} catch (SQLException e) {
			e.printStackTrace();  
		}
		return returnValue;
	}

	boolean isValid(int id, String session) {
		return (Sessions.isValid(id, session));
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
			pst.execute();
			pst.close();

			pstmt = connection.prepareStatement("SELECT idContinent, nameContinent FROM continent ORDER BY nameContinent ASC");
			srs = pstmt.executeQuery();

			pstmtCountry = connection.prepareStatement("SELECT idCountry, nameCountry FROM country WHERE idContinent = ? AND idCountry IN (SELECT idCountry FROM team) ORDER BY nameCountry ASC");


			/* {"header" : "World", "sections" : []} */
			obj = new JSONObject();
			obj.put("header", "World");

			/* [{continent}, {...}] */
			JSONArray continentTable = new JSONArray();
			while (srs.next()) {

				idContinent = srs.getInt("idContinent");
				continent = srs.getString("nameContinent");

				/* countries query */
				pstmtCountry.setInt(1, idContinent);
				srsCountry = pstmtCountry.executeQuery();

				JSONArray countryTable = new JSONArray();
				while (srsCountry.next()) {
					/* 
					 * add a country 
					 */
					idCountry = srsCountry.getInt("idCountry");
					country = srsCountry.getString("nameCountry");

					/* {"id" : int, "name" : String} <= Country*/
					JSONObject countryCell = new JSONObject();
					countryCell.put("id", new Integer(idCountry));
					countryCell.put("name", country);
					countryTable.add(countryCell);
				}
				if (countryTable.isEmpty()) {
					/* if there are no teams in this continent for the moment we put some text */
					JSONObject countryCell = new JSONObject();
					countryCell.put("id", new Integer(0));
					countryCell.put("name", "No teams for the moment");
					countryTable.add(countryCell);
				}

				/* {"id" : int, "name" : String, country : [...]} */
				JSONObject continentCell = new JSONObject();
				continentCell.put("id", idContinent);
				continentCell.put("name", continent);
				continentCell.put("rows", countryTable);

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



