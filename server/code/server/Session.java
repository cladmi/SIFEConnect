import java.util.*;
import java.lang.*;
import java.security.SecureRandom;
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;
import java.security.*;
import java.sql.*;

public class Session {

    private int idTeam;
    private String sessionId;
    private Calendar timestamp;
	private int nombreConnectes;

    public Session(int id, String session) {
		idTeam = id;
		sessionId = session;
		timestamp = Calendar.getInstance();
		nombreConnectes = 1;
    }

	public boolean isValid(int id, String session, int expiryTime) {
		return ((id == idTeam) && 
				sessionId.equalsIgnoreCase(session) &&
				timestamp.after(Calendar.getInstance().add(Calendar.MINUTE, -expiryTime)));
	}

	
	public void update() {
		timestamp = Calendar.getInstance();
	}
				
	public void update(String session) {
		sessionId = session;
		timestamp = Calendar.getInstance();
	}



	public void retain() {
		nombreConnectes += 1;
		update();
	}

	public boolean release() {
		nombreConnectes -= 1;
		return (nombreConnectes == 0);
	}

	public int retainCount() {
		return nombreConnectes;
	}


    public int idTeam() {
	    return idTeam;
    }

    public String sessionId() {
	    return sessionId;
    }

	public boolean isExpired (int expiryTime) {
		return timestamp.before(Calendar.getInstance().add(Calendar.MINUTE, -expiryTime));
	}
}
