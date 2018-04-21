package view;

import java.io.*;
import java.net.*;

class TCPClient {
	public TCPClient() throws Exception {
		System.out.println("coucou");
	    String sentence;
  	    String modifiedSentence;
	    BufferedReader inFromUser = new BufferedReader(new InputStreamReader(System.in));
	    Socket clientSocket = new Socket("192.168.43.171", 8888);
	    DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
	    BufferedReader inFromServer = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
	    sentence = inFromUser.readLine();
	    outToServer.writeBytes(sentence + '\n');
	    modifiedSentence = inFromServer.readLine();
	    System.out.println("FROM SERVER: " + modifiedSentence);
	    clientSocket.close();
	}
}