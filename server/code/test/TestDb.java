import java.sql.*;

public class TestDb {


	public static void main(String[] args) throws Exception {
		Connection connection;   
		PreparedStatement pstmt;
		ResultSet rset;
		Statement st;
		Class.forName("org.sqlite.JDBC");
		/* sqlite reading */
		connection = DriverManager.getConnection("jdbc:sqlite:test.db");  
		st = connection.createStatement();
		st.execute("ATTACH DATABASE 'test2.db' as t2");

		pstmt = connection.prepareStatement("SELECT t1.name, tt.name " +
				" FROM test t1, t2.test2 tt " +
				" WHERE t1.id = tt.idt");
		rset = pstmt.executeQuery();

		while (rset.next()) {
			System.out.println(rset.getString(1) + rset.getString(2));
		} 
		pstmt.close();
		rset.close();
		connection.close();  
	}
}
