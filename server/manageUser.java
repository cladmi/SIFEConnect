import java.util.Scanner;
import org.psafix.memopwd.Owasp;
import java.sql.*;


public class manageUser {

	public static void main(String[] args) throws Exception {
		Class.forName("org.sqlite.JDBC");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Owasp ow = new Owasp();

		int choice = 0;
		String input = null;
		Scanner sc = new Scanner(System.in);

		while (choice != 42) {
			System.out.println("Choose an option :");
			System.out.println(" 1 - Create Table Table");
			System.out.println(" 2 - List login, passwd, salt");
			System.out.println(" 3 - Create User");
			System.out.println("*******");
			System.out.println(" 42 - Quit the interface");
			System.out.print("Choice : ");
			choice = sc.nextInt();


			switch (choice) {
				///* // table allready exists
				case (1) :
					conn = DriverManager.getConnection("jdbc:sqlite:database/accounts.db");
					ow.createTable(conn);
					conn.close();
					break;
				//	*/
				case (3) :
					conn = DriverManager.getConnection("jdbc:sqlite:database/accounts.db");
//					ow.createUser(conn, "cladmi", "bite");
					conn.close();
					break;
				default :
					;
					break;
			}




		}

	}
}
