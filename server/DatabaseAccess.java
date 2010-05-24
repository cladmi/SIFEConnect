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
			connection = DriverManager.getConnection("jdbc:sqlite:/database/accounts.db");  
			passwordCorrect = owasp.authenticate(connection, login.toLowerCase(), passwd);
			System.out.println("password correct : " + passwordCorrect);
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

		if (connAccepted) {
				try {
					connection = DriverManager.getConnection("jdbc:sqlite:/database/teams.db");
					pstmt = connection.prepareStatement("SELECT idTeam, nameTeam FROM team WHERE login = ?;");
					pstmt.setString(1, login.toLowerCase());
					rset = pstmt.executeQuery();
					if (rset.next()) {
						id = rset.getInt("idTeam");
						name = rset.getString("nameTeam");
						if (! rset.next()) {
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
				object.put("STATUS","CONNECTION_ACCEPTED");
		}
		return returnValue;
	}

	public boolean isValid(int id, String session) {
		return (Sessions.isValid(id, session));
	}


	public String listCountries() throws SQLException, ClassNotFoundException {
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
		
		String selectFrance;
		String selectEurope;
		
		if (Global.onlyFrance) {
			selectFrance = "WHERE nameCountry = 'France'";
			selectEurope = "WHERE nameContinent = 'Europe'";
		} else {
			selectFrance = "";
			selectEurope = "";
		}


		try {
			connection = DriverManager.getConnection("jdbc:sqlite:/database/countries.db");  
			pst = connection.prepareStatement("ATTACH DATABASE '/database/teams.db' AS T");
			pst.execute();
			pst.close();

			pstmt = connection.prepareStatement("SELECT idContinent, nameContinent FROM continent " + selectEurope + " ORDER BY nameContinent ASC");
			srs = pstmt.executeQuery();

			pstmtCountry = connection.prepareStatement("SELECT idCountry, nameCountry FROM country WHERE idContinent = ? AND idCountry IN (SELECT idCountry FROM team " + selectFrance + " ) ORDER BY nameCountry ASC");


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

				/* {"id" : idContinent, "name" : continentName, country : [...]} */
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

	public String listTeams(int idCountry) throws SQLException, ClassNotFoundException {
		Class.forName("org.sqlite.JDBC");

		JSONObject obj = null;

		// attach database
		PreparedStatement pst = null;
		// teams query
		PreparedStatement pstmt = null;
		ResultSet srs = null;
		// countries query
		PreparedStatement psTeam = null;
		ResultSet rsTeam = null;

		String country;
		int idTeam;
		String nameTeam;

		try {
			if (idCountry == -1) 
				throw new Exception("idCountry == -1");

			connection = DriverManager.getConnection("jdbc:sqlite:/database/countries.db");  
			pst = connection.prepareStatement("ATTACH DATABASE '/database/teams.db' AS T");
			pst.execute();
			pst.close();

			pstmt = connection.prepareStatement("SELECT nameCountry FROM country WHERE idCountry = " + idCountry);
			srs = pstmt.executeQuery();

			psTeam = connection.prepareStatement("SELECT idTeam, nameTeam FROM team WHERE idCountry = " + idCountry + " ORDER BY nameTeam ASC");

			/* {"header" : countryName, "idCountry" : idCountry,  "rows" : []} */
			obj = new JSONObject();
			if (srs.next()) {
				obj.put("header", srs.getString("nameCountry"));
				obj.put("idCountry", new Integer(idCountry));
			} else {
				throw new Exception("idCountry not found");
			}
			srs.close();
			pstmt.close();

			rsTeam = psTeam.executeQuery();
			/* [{teams}, {...}] */
			JSONArray teamTable = new JSONArray();
			while (rsTeam.next()) {

				idTeam = rsTeam.getInt("idTeam");
				nameTeam = rsTeam.getString("nameTeam");

				/* {"id" : int, "name" : String} <= Country*/
				JSONObject teamCell = new JSONObject();
				teamCell.put("id", new Integer(idTeam));
				teamCell.put("name", nameTeam);
				teamTable.add(teamCell);
			}

			/* add and clear */
			/* fin traitement continent */
			obj.put("rows", teamTable);
			/* close the connection */
			rsTeam.close();
			psTeam.close();
			connection.close();  

			return obj.toString();
		} catch (Exception e) {  
			e.printStackTrace();  
		}
		return "{\"STATUS\":\"DATA_ERROR\"}";
	}


	public String listNews(int id, int idList, int listType, int page) throws SQLException, ClassNotFoundException {
		Class.forName("org.sqlite.JDBC");

		JSONObject obj = null;

		// attach database
		PreparedStatement pst = null;
		// countries query
		PreparedStatement psNews = null;
		ResultSet rsNews = null;

		String country;
		int idTeam;
		String nameTeam;
		String nameCountry;
		String grepNews = null;
		String headerColums = null;
		long dateMsg;
		String textMsg = null;
		int idMsg = 0;
		String selectFrance;
		if (Global.onlyFrance) {
			selectFrance = " AND C.nameCountry = 'France' ";
		} else {
			selectFrance = "";
		}

		try {
			if (idList == -1) {
				throw new Exception("idList incorrect");
			}

			switch (listType) {
				case (Global.NEWS_TEAM) :
					grepNews = " AND M.idTeam = " + idList + " ";
					headerColums = "nameTeam";
					break;
				case (Global.NEWS_COUNTRY) :
					grepNews = " AND C.idCountry = " + idList + " ";
					headerColums = "nameCountry";
					break;
				case (Global.NEWS_CONTINENT) :
					grepNews = " AND W.idContinent = " + idList + " ";
					headerColums = "nameContinent";
					break;
				case (Global.NEWS_WORLD) :
					grepNews = "";
					break;
				//default :
				//	throw new Exception("listType incorrect");
				//break;
			}

			connection = DriverManager.getConnection("jdbc:sqlite:/database/msgs.db");  
			pst = connection.prepareStatement("ATTACH DATABASE '/database/teams.db' AS T");
			pst.execute();
			pst.close();
			pst = connection.prepareStatement("ATTACH DATABASE '/database/countries.db' AS C");
			pst.execute();
			pst.close();

			/* {"header" : typeListNews, "Previous" : int/null, "Next" : int/null", "sections":[]} */
			obj = new JSONObject();


			
			psNews = connection.prepareStatement("SELECT M.idMsg, M.idTeam, M.msg, M.date, M.like, M.dislike, T.nameTeam, C.nameCountry, W.nameContinent FROM msg M, team T, country C, continent W WHERE M.idTeam = T.idTeam AND T.idCountry = C.idCountry AND C.idContinent = W.idContinent " + selectFrance + grepNews + " ORDER BY date DESC LIMIT ? OFFSET ?");

			psNews.setInt(1, (Global.NEWS_PER_PAGE + 1));
			psNews.setInt(2, (Global.NEWS_PER_PAGE * (page - 1)));
			// on en récupère un de plus, pour permettre de savoir s'il y en a d'autres

			rsNews = psNews.executeQuery();

			if (rsNews.next()) {
				if (listType == Global.NEWS_WORLD) {
					obj.put("header", "World News");
				} else {

					obj.put("header", rsNews.getString(headerColums) + " News");
				}


				/* [{msgs}, {...}] */
				JSONArray msgTable = new JSONArray();
				int i = 0;
				do  {

					idTeam = rsNews.getInt("idTeam");
					nameTeam = rsNews.getString("nameTeam");
					nameCountry = rsNews.getString("nameCountry");
					dateMsg = rsNews.getDate("date").getTime();
					textMsg = rsNews.getString("msg");
					idMsg = rsNews.getInt("idMsg");

					/* {"id" : int, "name" : string, "date" : long, "rows" : [{"text" : String}]}*/
					JSONObject msgCell = new JSONObject();
					msgCell.put("id", new Integer(idTeam));
					msgCell.put("name", nameTeam);
					msgCell.put("country", nameCountry);
					msgCell.put("date", new Long(dateMsg));

					JSONArray rowsTable = new JSONArray();

					JSONObject textCell = new JSONObject();
					textCell.put("text", textMsg);
					textCell.put("id", new Integer(idMsg));

					rowsTable.add(textCell);

					msgCell.put("rows", rowsTable); 
					msgTable.add(msgCell);
					i++;
				} while ((i < Global.NEWS_PER_PAGE) && (rsNews.next()));
				obj.put("sections",msgTable);

				if (page == 1) {
					obj.put("previous", null);
				} else {
					obj.put("previous", new Integer(page -1));
				}
				
				if ((i == Global.NEWS_PER_PAGE) && rsNews.next()) {
					// on a 10 msgs et il y en a encore un autre
					obj.put("next", new Integer(page + 1));
				} else {
					obj.put("next", null);
				}

				/* close the connection */
				rsNews.close();
				psNews.close();
				connection.close();  

			} else {
				obj.put("STATUS","DATA_ERROR");
			}
			return obj.toString();
		} catch (Exception e) {  
			e.printStackTrace();  
		}
		return "{\"STATUS\":\"DATA_ERROR\"}";
	}

	public String postMessage(int teamId, String msg) throws ClassNotFoundException {
		Class.forName("org.sqlite.JDBC");

		int idTeam;
		String nameTeam;

		// message query

		try {
			connection = DriverManager.getConnection("jdbc:sqlite:/database/msgs.db");  

			pstmt = connection.prepareStatement("INSERT INTO msg (idTeam, msg, date, like, dislike) values (" + teamId + ", ?, ?, 0, 0)");
			pstmt.setString(1, msg);
			pstmt.setDate(2, new java.sql.Date(Calendar.getInstance().getTimeInMillis()));
			pstmt.executeUpdate();
			pstmt.close();

			return "{\"STATUS\":\"MESSAGE_POSTED\"}";
		} catch (Exception e) {  
			e.printStackTrace();  
		}
		return "{\"STATUS\":\"DATA_ERROR\"}";
	}

	public String del(int idMsg, int path) throws ClassNotFoundException {
		Class.forName("org.sqlite.JDBC");

		// message query
		try {
			connection = DriverManager.getConnection("jdbc:sqlite:database/msgs.db");  
			pstmt = connection.prepareStatement("DELETE FROM msg WHERE msg=?");
			pstmt.setInt(1, idMsg);
			pstmt.executeUpdate();
			pstmt.close();

			return "{\"STATUS\":\"MSG_DELETED\"," +
					"\"path\":" + path + "," + 
					"\"id\":" + idMsg+ "}";

		} catch (Exception e) {  
			e.printStackTrace();  
		}
		return "{\"STATUS\":\"DATA_ERROR\"}";
	}

	public void disconnect(int id, String session) {
		disconnect(id, session);
	}

}



