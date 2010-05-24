import java.util.Scanner;
import org.psafix.memopwd.Owasp;
import java.sql.*;

import java.lang.*;



public class manageUser {
	static Connection conn = null;
	static PreparedStatement ps = null;
	static Connection conn2 = null;
	static PreparedStatement ps2 = null;
	static ResultSet rs = null;
	static Owasp ow = new Owasp();

	public static void main(String[] args) throws Exception {
		Class.forName("org.sqlite.JDBC");

		int choice = 0;
		String input = null;
		Scanner sc = new Scanner(System.in);

		String login;
		String passwd;
		String name;
		int country;



		if (args.length != 0) {
			 /* manageUser teamName login	*/
			login = args[1];
			
			/*
			conn = DriverManager.getConnection("jdbc:sqlite:/database/countries.db");
			ps = conn.prepareStatement("select idCountry from country where idCountry=");
			ps.setString(1, country);
			rs = ps.executeQuery();

			System.out.println("Choisir l'entier représentant le pays parmis : ");
			while (rs.next()) {
				System.out.println(rs.getInt("idCountry") + " - " + rs.getString("nameCountry")); 
			}
			rs.close();
			ps.close();
			conn.close();
			*/

			name = args[0];
			login = args[1];
			passwd = args[1];
			country = 33;



			addUser(country,login,name,passwd);


			System.out.println("We add '" + name + "' : login = '" + login + "'");
		} else {
			while (choice != 42) {
				System.out.println("Choose an option :");
				System.out.println(" 1 - Create Table Table");
				System.out.println(" 3 - Create User");
				System.out.println("*******");
				System.out.println(" 42 - Quit the interface");
				System.out.print("Choice : ");
				choice = sc.nextInt();


				switch (choice) {
					///* // table allready exists
					case (1) :
						conn = DriverManager.getConnection("jdbc:sqlite:/database/accounts.db");
						ow.createTable(conn);
						conn.close();
						break;
						//	*/
					case (3) :
						System.out.println("login : ");
						login = sc.nextLine();
						login = sc.nextLine();
						System.out.println("password : ");
						passwd = sc.nextLine();
						System.out.println("name : ");
						name = sc.nextLine();

						conn = DriverManager.getConnection("jdbc:sqlite:/database/countries.db");
						ps = conn.prepareStatement("select idCountry, nameCountry from country");
						rs = ps.executeQuery();

						System.out.println("Choisir l'entier représentant le pays parmis : ");
						while (rs.next()) {
							System.out.println(rs.getInt("idCountry") + " - " + rs.getString("nameCountry")); 
						}
						rs.close();
						ps.close();
						conn.close();

						System.out.print("Country Number : ");
						country = sc.nextInt();


						System.out.println("You are going to add the user : \" login : " + login + ", password : " + passwd + ", name : " + name + ", country n° : " + country + " Continue {y/n} ?");
						input = sc.nextLine();
						input = sc.nextLine();
						if (input.equals("y")) {
							System.out.println("adding the user, don't interrupt");

							addUser(country,login,name,passwd);
							conn2.close();
						} else {
							System.out.println(" Creation abandonned");
						}
						break;
					default :
						;
						break;
				}
			}




		}

	}


	static void addUser(int country, String login, String name, String passwd) throws Exception {

		conn = DriverManager.getConnection("jdbc:sqlite:/database/teams.db");
		conn2 = DriverManager.getConnection("jdbc:sqlite:/database/accounts.db");
		ps = conn.prepareStatement("INSERT INTO team (idCountry, login, nameTeam) values (?, ?, ?)");
		ps.setInt(1, country);
		ps.setString(2, login);
		ps.setString(3, name);

		ps.executeUpdate();
		ow.createUser(conn2, login, passwd);

		ps.close();
		conn.close();
		conn2.close();
	};
}
