/*
 * Copyright (c) 1995 - 2008 Sun Microsystems, Inc.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 *   - Neither the name of Sun Microsystems nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */ 

import java.net.*;
import java.io.*;
import java.sql.*;
import java.security.*;
import java.util.*;
import java.lang.*;
import org.json.simple.*;
import org.json.simple.parser.*;
//import java.security.MessageDigest;

/*
   import java.io.ObjectOutputStream;
   import java.net.ServerSocket;
   import java.net.Socket;
   */
public class SifeConnectProtocol {
	ContainerFactory containerFactory = new ContainerFactory(){
		public List creatArrayContainer() {
			return new LinkedList();
		}

		public Map createObjectContainer() {
			return new LinkedHashMap();
		}

	};


	private static final int WAITING = 0;
	private static final int QUERY = 1;
	private static final int DISCONNECT = 2;

	/* Actions */
	private static final int LOGIN = 1;
	private static final int LIST_COUNTRIES = 2;
	private static final int LIST_TEAMS = 3;
	private static final int NEWS = 4;
	private static final int POST = 5;
	private static final int DEL = 6;
	private static final int DECO = 7;

	private int state = WAITING;

	private DatabaseAccess db = new DatabaseAccess();



	public String processInput(String theInput) throws Exception {
		Class.forName("org.sqlite.JDBC");

		String theOutput = null;
		Map json = null; 
		int id = 0;
		String login = null;
		String passwd = null;
		String sessionId = null;
		Number idNumber;
		int idCountry;
		int idContinent;
		int idTeam;
		int idList;
		int page;

		if (state == WAITING) {
			theOutput = "Coucou";
			state = QUERY;
		} else if (state == DISCONNECT) {
			theOutput = "END";
			/////// on va déconnecter tout 
			state = WAITING;
		} else if (state == QUERY) {
			/* JSON PARSING */
			JSONParser parser = new JSONParser();
			try {
				json = (Map) parser.parse(theInput, containerFactory);
			} catch(ParseException pe) {
				System.out.println(pe);
				// TODO
				return "END";
			}
			/* END OF JSON PARSING */




			Connection connection = null;  
			switch (((Number) json.get("action")).intValue()) {
				case LOGIN :
					// login
					// passwd 

					JSONObject object = new JSONObject();
					/* json reading */
					login = ((String) json.get("login")).toLowerCase();
					passwd = (String) json.get("passwd");
					if ((login == null) || (passwd == null)) {
						login = "";
						passwd = "";
					}


					boolean connAccepted = db.Auth(login, passwd);

					// if connAccepted 
					// add to the object "id" -> id, "sessionId" -> sid, "name" -> name, 
					// if return value == false, nothing has been added
					// user hasn't been found
					connAccepted = db.getInfos(login.toLowerCase(), object, connAccepted);

					if (connAccepted) {
						theOutput = object.toString();
					} else {
						theOutput = "{\"STATUS\":\"CONNECTION_REFUSED\"}";
					}

					break;
				case LIST_COUNTRIES :
					// id
					// sessionId

					// erreur s'il n'y a pas d'intValue…
					idNumber = (Number) json.get("id");
					sessionId = (String) json.get("sessionId");

					if ((idNumber != null) && (sessionId != null)) {
						id = idNumber.intValue();
					} else {
						id = 0;
						sessionId = "";
					}

					if (db.isValid(id, sessionId)) {
						theOutput = db.listCountries();
					} else {
						theOutput = "{\"STATUS\":\"UNKNOWN_SESSION\"}";
					}
					break;
				case LIST_TEAMS :
					// id
					// sessionId
					// country

					idNumber = (Number) json.get("id");
					sessionId = (String) json.get("sessionId");
					Number countryNumber = (Number) json.get("country");

					if ((idNumber != null) && (sessionId != null)) {
						id = idNumber.intValue();
					} else {
						id = 0;
						sessionId = "";
					}

					if (countryNumber != null) {
						idCountry = countryNumber.intValue();
					} else {
						idCountry = -1;
					}

					if (db.isValid(id, sessionId)) {
						theOutput = db.listTeams(idCountry);

					// renvoyer le id pays aussi, c'est important pour  la généralisation éventuelle
					} else {
						theOutput = "{\"STATUS\":\"SESSION_ERROR\"}";
					}
					break;
				case NEWS :
					// id
					// sessionId
					//// continent
					//// pays
					// team
					// page
					int listType = 0;



					idNumber = (Number) json.get("id");
					sessionId = (String) json.get("sessionId");
					Number continentNumber = (Number) json.get("continent");
					countryNumber = (Number) json.get("country");
					Number teamNumber = (Number) json.get("team");
					Number pageNumber = (Number) json.get("page");

					if ((idNumber != null) && (sessionId != null)) {
						id = idNumber.intValue();
					} else {
						id = 0;
						sessionId = "";
					}

					if (teamNumber != null && teamNumber.intValue() > 0) {
						idList = teamNumber.intValue();
						listType = Global.NEWS_TEAM;
					} else if (countryNumber != null && countryNumber.intValue() > 0) {
						idList = countryNumber.intValue();
						listType = Global.NEWS_COUNTRY;
					} else if (continentNumber != null && continentNumber.intValue() > 0) {
						idList = continentNumber.intValue();
						listType = Global.NEWS_CONTINENT;
					} else {
						idList = 0;
						listType = Global.NEWS_WORLD;
					}

					if (pageNumber != null) {
						page = pageNumber.intValue();
					} else {
						page = 1;
					}

					if (db.isValid(id, sessionId)) {
						theOutput = db.listNews(id, idList, listType, page);
					} else {
						theOutput = "{\"STATUS\":\"UNKNOWN_SESSION\"}";
					}
					break;
				case POST :
					// id
					// sessionId
					// textMsg
					String textMsg = null;

					// erreur s'il n'y a pas d'intValue…
					idNumber = (Number) json.get("id");
					sessionId = (String) json.get("sessionId");
					textMsg = (String) json.get("text");
					if ((idNumber != null) && (sessionId != null) && (textMsg != null)) {
						id = idNumber.intValue();
					} else {
						id = 0;
						sessionId = "";
						textMsg = "";
					}
					if (db.isValid(id, sessionId)) {
						theOutput = db.postMessage(id, textMsg);
					} else {
						theOutput = "{\"STATUS\":\"UNKNOWN_SESSION\"}";
					}
					break;
				case DEL :
					// id
					// sessionId
					// idMsg

					// erreur s'il n'y a pas d'intValue…
					idNumber = (Number) json.get("id");
					sessionId = (String) json.get("sessionId");
					if ((idNumber != null) && (sessionId != null)) {
						id = idNumber.intValue();
					} else {
						id = 0;
						sessionId = "";
					}
					if (db.isValid(id, sessionId)) {
						;
						//theOutput = db.del(msg);
					} else {
						theOutput = "{\"STATUS\":\"UNKNOWN_SESSION\"}";
					}
					break;
				case DECO :
					// id
					// sessionId

					// erreur s'il n'y a pas d'intValue…
					idNumber = (Number) json.get("id");
					sessionId = (String) json.get("sessionId");
					if ((idNumber != null) && (sessionId != null)) {
						id = idNumber.intValue();
					} else {
						id = 0;
						sessionId = "";
					}
					if (db.isValid(id, sessionId)) {
						db.disconnect(id, sessionId);
						theOutput = "{\"STATUS\":\"DISCONNECTED\"}";
					} else {
						theOutput = "{\"STATUS\":\"UNKNOWN_SESSION\"}";
					}
					break;
				default :

					break;
			}


			// obj.writeJSONString(out);

			state = DISCONNECT;	
		}
		return theOutput;
	}

}

