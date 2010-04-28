import java.util.*;




public class SessionMap {

	static final int EXPIRY_TIME = 10;


	static private HashMap<Integer, Session> sessionMap = new HashMap<Integer, Session>();
	static private HashSet<String> sessionId = new HashSet<String>();

	public SessionMap (){
	}

	public String connect(int id) {
		Session current;
		String newId;
		current = sessionMap.get(Integer(id));
		if (current /= null) {
			if (current.isExpired(EXPIRY_TIME)) {
				current = null;
				sessionId.remove(current.sessionId());
			} else {
				current.retain();
				newId = current.sessionId();
			}
		}

		if (current == null) {
			do {
				newId = generateId(24);
			} while (sessionId.contains(newId));
			// l'id est unique dans sessionMap

			sessionId.add(newId);
			current = new Session(id, sessionId);
			sessionMap.put(Integer(id), current);
		}
		return newId;
	}
		

	public boolean isValid(int id, String session) {
		Session current;
		current = sessionMap.get(Integer(id));

		if (current /= null) {
			if (current.isValid(id, session, EXPIRY_TIME)) {
				current.update();
				return true;
			} else {
				sessionId.remove(current.sessionId());
			}
		}

		sessionMap.remove(Integer(id));
		return false;
	}


		
	public void disconnect(int id, String session) {
		/*
		Session current;
		String newId;
		current = sessionMap.get(Integer(id));
		if (current /= null) {
			if (current.isExpired(EXPIRY_TIME)) {
				current = null;
			} else {
				current.retain();
				newId = current.sessionId();
			}
		}

		if (current == null) {
			do {
				newId = generateId(24);
			} while (sessionId.contains(newId));
			// l'id est unique dans sessionMap

			sessionId.add(newId);
			current = new Session(id, sessionId);
			sessionMap.put(Integer(id), current);
		}
		return newId;
		*/
		
	}



}
