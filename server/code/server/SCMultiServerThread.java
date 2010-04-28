/*
 * Copyright (c) 1995 - 2008 Sun Microsystems, Inc.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 *   - Neither the name of Sun Microsystems nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */ 

import java.net.*;
import java.io.*;

public class SCMultiServerThread extends Thread {
	private Socket socket = null;

	public SCMultiServerThread(Socket socket) {
		super("SCMultiServerThread");
		this.socket = socket;
	}

	public void run() {

		String outputLine, inputLine;
		try {
				
			BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

			PrintWriter out = new PrintWriter(socket.getOutputStream(), true);




			SifeConnectProtocol scp = new SifeConnectProtocol();
			outputLine = scp.processInput(null);
			out.println(outputLine);

			System.out.println("et bimeuh");

			while ((inputLine = (String) in.readLine()) != null) {
				outputLine = scp.processInput(inputLine);
				out.println(outputLine);
				if (((String) outputLine).equals("END"))
					break;
			}

			/* end of connection */
			out.close();
			in.close();
			socket.close();

		} catch (Exception e) {
		//} catch (IOException e) {
			e.printStackTrace();
		}
	}
}


/*
   import java.io.ObjectOutputStream;
   import java.net.ServerSocket;
   import java.net.Socket;

   public class SimpleSocketServer {

	   public static void main(String args[]) throws Exception {
		   ServerSocket serverSocket;
		   int portNumber = 1777;
		   Socket socket;
		   String str;

		   str = " <?xml version=\"1.0\" encoding=\"UTF-8\"?>";
		   str += "<ticketRequest><customer custID=\"1\">";
		   str += "</ticketRequest>";

		   serverSocket = new ServerSocket(portNumber);

		   System.out.println("Waiting for a connection on " + portNumber);

		   socket = serverSocket.accept();

		   ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream());

		   out.writeObject(str);
		   out.close();

		   socket.close();

	   }
   }

*/ 
