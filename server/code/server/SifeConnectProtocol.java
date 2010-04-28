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
	private static final int LOGIN = 0;
	private static final int LIST_COUNTRIES = 1;
	private static final int LIST_TEAMS = 2;
	private static final int NEWS = 3;
	private static final int POST = 4;
	private static final int DEL = 5;

	private int state = WAITING;
	private SessionMap savedSession;

	private DatabaseAccess db = new DatabaseAccess();


	public String processInput(String theInput) throws Exception {
		Class.forName("org.sqlite.JDBC");

		String theOutput = null;
		Map json; 
		if (state == WAITING) {
			System.out.println("State Waiting");
			theOutput = "Coucou";
			state = QUERY;
		} else if (state == DISCONNECT) {
			theOutput = "Bye.";
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
				return "Bye.";
			}
			/* END OF JSON PARSING */


			System.out.println("JsonString : ");
			System.out.println(JSONValue.toJSONString(json));

			// System.out.println(JSONValue.toJSONString(json));

			Connection connection = null;  
			switch (((Integer) json.get("action")).intValue()) {
				case LOGIN :
					// TODO
					// sauvegarder un session ID
					// login
					// passwd 
					int id;
					String login;
					String passwd;

					/* json reading */
					try {
						login = json.getString("login").toLowerCase();
						passwd = json.getString("passwd");
					} catch (JSONException e) {
						login = "";
						passwd = "";
					}

					// id == 0 => echec d'authentification ou erreur interne
					id = db.Authentificate(login, passwd); 	

					theOutput = "{'id' : " + id + "}";

					break;
				case LIST_COUNTRY :

					int id;
					String sessionId;
					try {
						id = json.getInt("id");
						sessionId = json.getString("sessionId");
					} catch (JSONException e) {
						id = 0;
						sessionId = "";
					}
						

					theOutput = db.listCountries();


					break;
				case NEWS :
					// sessionId
					// continent
					// pays
					// page

					break;
				case POST :
					// sessionId
					// msg

					break;
				case DEL :
					// sessionId
					// id

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

