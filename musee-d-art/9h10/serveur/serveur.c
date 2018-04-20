#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <netinet/in.h>
#include <unistd.h>
#include <string.h>

#define ANSI_COLOR_RED "\x1b[31m" //Couleur rouge pour affichage d'erreur
#define ANSI_COLOR_RESET "\x1b[0m" //Couleur de texte classique

void doprocessing (int sock1, int sock2); //fonction qui se lance dès qu'une nouvelle donnée TCP est reçue. Elle filtre la trame reçue.

int main( int argc, char *argv[] ) {
	printf(ANSI_COLOR_RESET); //remet la couleur de terminal par défaut
	
	int sockfd, sock1, sock2, portno, clilen; //protocole TCP

	char buffer[256], message[100];

	struct sockaddr_in serv_addr, cli_addr;

	int n, pid, v;
	
	/* First call to socket() function */
	sockfd = socket(AF_INET, SOCK_STREAM, 0);
   
	if (sockfd < 0) {
		perror("ERROR opening socket");
		exit(1);
   	}else{
		printf("socket open\n");
	}

	/* Initialize socket structure */
	bzero((char *) &serv_addr, sizeof(serv_addr));
	portno = 8888;
   
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = INADDR_ANY;
	serv_addr.sin_port = htons(portno);

	/* Now bind the host address using bind() call.*/
   	if (bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0) {
		perror("ERROR on binding");
		exit(1);
	}else{
		printf("bind successful\n");
	}
	
	/* Now start listening for the clients, here
	* process will go in sleep mode and will wait
	* for the incoming connection
	*/
   
	listen(sockfd,5);
	clilen = sizeof(cli_addr);

	sock1 = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen);

	sprintf(message, "En attente d'un client");
	v = write(sock1,message,sizeof(message));//écriture sur la socket de buffer

	if (sock1 < 0){
		exit(1);
	}

	printf("client1 connecté\n");

	while(1){

		sock2 = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen);

		if (sock2 < 0){
			exit(1);
		}

		printf("client2 connecté\n");
	
		/* Create child process */
		pid = fork();
	
		if (pid < 0) {
			perror("ERROR on fork");
			exit(1);
		}
	      
	      	if (pid == 0) {
			/* This is the client process */
			doprocessing(sock1, sock2);
			close(sockfd);	
	      	}

	}
}

/* void doprocessing (int sock, char noCourse[2]);
- sock est la socket sur laquelle communique le processus

Cette fonction récupère les données écrites sur la socket
*/

void doprocessing (int sock1, int sock2) {
	
	int n, i, etat, j, length;
	char buffer[256], buf[4];
	bzero(buffer,256);
	memset(buffer, 0, sizeof(buffer));
	while(read(sock2,buffer,255)>0){
		if (n < 0) {
			perror("ERROR reading from socket");
			exit(1);
		}

		n = write(sock1,buffer,sizeof(buffer));//écriture sur la socket de buffer
		printf("message = %s\n", buffer);
		
		if (n < 0) {
			perror("ERROR writing to socket");
			exit(1);
		}
		memset(buffer, 0, sizeof(buffer));
 	}  
	
}


