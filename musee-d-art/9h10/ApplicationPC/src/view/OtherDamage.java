package view;

import java.awt.Color;
import java.awt.GradientPaint;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.color.ColorSpace;
import java.util.Arrays;
import java.util.Scanner;

import javax.swing.JComponent;

public class OtherDamage extends JComponent {
	public void paintComponent(Graphics g){
		Scanner sc = new Scanner(System.in);
    	System.out.println("Enter coordinates :");
    	String entry = sc.nextLine();
    	System.out.println("You have entered : " + entry);
    	
    	String delimiters = "[,;]";
		String[] tokens = entry.split(delimiters);
		int x = Integer.parseInt(tokens[0]);
		int y = Integer.parseInt(tokens[1]);
		
		g.fillOval(x, y, 40, 40);
	    sc.close();
	    /*Graphics2D g2d = (Graphics2D)g;
	    GradientPaint gp = new GradientPaint(200, 200, Color.CYAN, 200, 500, new Color(0, 0, 0, 0));                
	    g2d.setPaint(gp);
	    g2d.fillRect(0, 0, this.getWidth(), this.getHeight());*/
	}
}
