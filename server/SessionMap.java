import java.util.*;
import java.lang.Integer;



public class SessionMap {

	static final int EXPIRY_TIME = 10;


	static private HashMap<Integer, Session> sessionMap = new HashMap<Integer, Session>();
	static private HashSet<String> sessionId = new HashSet<String>();

	public SessionMap (){
	}

	public String connect(int id) {
		// even if id = 0, we generate a new key, time resistant attack
		Session current = null;
		String newId = null;
		current = sessionMap.get(new Integer(id));

		if (current != null) {
			if (current.isExpired(EXPIRY_TIME)) {
				// on enlève le sessionId expiré
				sessionId.remove(current.sessionId());
				current = null;
			} else {
				/* on accepte plusieurs connections sur un compte
				 * en même temps, on propage donc le sessionId
				 */
				current.retain();
				newId = current.sessionId();
			}
		}
		if (current == null) {
			do {
				newId = Global.idGenerator.generateId(24);
			} while (sessionId.contains(newId));
			// l'id est unique dans sessionMap
			if (id != 0) {
				sessionId.add(newId);
				current = new Session(id, newId);
				sessionMap.put(new Integer(id), current);
			} else {
				return "";
			}
		}
		return newId;
	}


	public boolean isValid(int id, String session) {
		Session current = sessionMap.get(new Integer(id));
		if (current != null) {
			if (current.isValid(id, session, EXPIRY_TIME)) {
				current.update();
				return true;
			} else {
				sessionId.remove(current.sessionId());
			}
		}

		// session expirée ou inexistante, on essaye d'enlever la clé
		sessionMap.remove(new Integer(id));
		return false;
	}



	public void disconnect(int id, String session) {
		Session current = sessionMap.get(new Integer(id));
		if (current != null && 
				((current.isValid(id, session, EXPIRY_TIME) && 
				  current.release()) 
				 || current.isExpired(EXPIRY_TIME))) {
					// la session a expiré, ou on est le dernier propriétaire de cette session
					sessionId.remove(current.sessionId());
					sessionMap.remove(new Integer(id));
				 } 
				 // la session est encore valide, elle ne nous appartient pas, ou il y a encore(?) quelqu'un de connecté

	}



}
