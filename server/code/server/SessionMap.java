import java.util.*;


public class SessionMap {
   static private HashMap<String,Session> sessionMap;

   public SessionMap (){
      if (sessionMap == null) 
	 sessionMap = new HashMap<String, Session>();
   }
}
