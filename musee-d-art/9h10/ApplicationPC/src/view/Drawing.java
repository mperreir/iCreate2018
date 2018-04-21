package view;

import java.awt.Graphics;
import java.util.Scanner;

import javax.swing.JComponent;

public class Drawing extends JComponent {
	public void paintComponent(Graphics g){		
    	Scanner sc = new Scanner(System.in);
    	System.out.println("Enter coordinates :");
    	String entry = sc.nextLine();
    	System.out.println("You have entered : " + entry);
    	
    	String delimiters = "[,;]";
		String[] tokens = entry.split(delimiters);
		int x = Integer.parseInt(tokens[0]);
		int y = Integer.parseInt(tokens[1]);
		
		g.fillOval(x, y, 50, 50);
	    sc.close();
	}
}
