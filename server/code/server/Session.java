import java.util.*;
import java.lang.*;
import java.security.SecureRandom;
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;
import java.security.*;
import java.sql.*;

public class Session {

    private static HashSet<String> existingSession;
    private String sessionId;
    private int idTeam;
    private long timestamp;
    public static String byteToBase64(byte[] data){
	BASE64Encoder endecoder = new BASE64Encoder();
	return endecoder.encode(data);
    }

    public Session (int id) throws NoSuchAlgorithmException {
	byte[] bSalt;
	if (existingSession == null) {
	    existingSession = new HashSet<String>();
	}

	do {
	    SecureRandom random = SecureRandom.getInstance("SHA1PRNG");
	    bSalt = new byte[32];
	    random.nextBytes(bSalt);
	    sessionId = byteToBase64(bSalt);
	} while (existingSession.contains(sessionId));

	existingSession.add(sessionId);
	idTeam = id;
	java.util.Date today = new java.util.Date();
	timestamp = (new java.sql.Timestamp(today.getTime())).getTime();

    }

    String sessionId() {
	    return sessionId;
    }

    int idTeam() {
	    return idTeam;
    }

    long timestamp() {
	    return timestamp;
    }



}
