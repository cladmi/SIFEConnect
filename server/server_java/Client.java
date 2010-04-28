package pse;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;

/**
 * Client pour l'annuaire consultable via le protocole TCP.
 * 
 * @author Adrien Oliva - Gaëtan Harter
 * @version 0.9.6
 * 
 */
public class Client {

	/**
	 * Récupère un chaîne de caractère sur l'entrée standard.
	 * 
	 * @return chaîne de caractère.
	 * @throws Exception
	 *             levé par BufferedReader.
	 */
	private static String getLine() throws Exception {
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		return br.readLine();
	}

	/**
	 * Envoie vers le serveur une chaine de caractère.
	 * 
	 * @param s
	 *            Socket de connexion avec le serveur.
	 * @param str
	 *            Chaîne à envoyer au serveur.
	 * @throws Exception
	 *             levé par OutputStream.
	 */
	private static void sendOut(Socket s, String str) throws Exception {
		ObjectOutputStream out = new ObjectOutputStream(s.getOutputStream());
		out.writeObject(str);
		out.flush();

	}

	/**
	 * Fonction principale initialisant la connexion avec l'hôte (choix de
	 * l'hôte possible à l'éxécution). Effectue ensuite en alternance, réception
	 * d'une String du serveur et envoie d'une String au serveur jusqu'à la
	 * réception de la séquence d'échappement (ici la chaîne "exit").
	 * 
	 * @param args
	 *            arguments de la fonction principale (non utilisés ici).
	 * @throws Exception
	 *             levé par les InputStream et OutputStream ainsi que lors de la
	 *             connexion avec le serveur.
	 */
	public static void main(String[] args) throws Exception {

		System.out.print("Entrer le nom du serveur hôte : ");
		String host = getLine();

		// Création du socket.
		System.out.print("Connexion avec l'hôte...");
		Socket s = new Socket(host, 20000);
		System.out.println("[DONE]");

		while (true) {

			ObjectInputStream in = new ObjectInputStream(s.getInputStream());
			String result = new String((String) in.readObject());

			if (result.contentEquals("exit")) {
				System.out.println("Au revoir.");
				break;
			} else {
				System.out.print(result);
			}

			sendOut(s, getLine());

		}

		System.out.println("Fin de la connexion");
		s.close();

	}
}
