public class DateLabel {
    public static void main(String[] args) {
	java.util.Date today = new java.util.Date();
	System.out.println(today.toString());
	java.sql.Timestamp ts1 = new java.sql.Timestamp(today.getTime());
	java.sql.Timestamp ts2 = java.sql.Timestamp.valueOf("2005-04-06 09:01:10");

	System.out.println(ts1.toString());
	System.out.println(ts2.toString());

	long tsTime1 = ts1.getTime();
	long tsTime2 = ts2.getTime();

	System.out.println(tsTime1);
	System.out.println(tsTime2);

	Calendar calendar = Calendar.getInstance();
	java.sql.Timestamp ourJavaTimestampObject = new java.sql.Timestamp(calendar.getTime().getTime());
	         

    }
}

