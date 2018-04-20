package view;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Point;
import java.awt.image.ImageObserver;
import java.io.File;
import java.io.IOException;
import java.util.Scanner;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JPanel;

public class Painting extends JLayeredPane {
	public void paintComponent(Graphics g){
		try {
			Image img = ImageIO.read(new File("Le_Kaid.jpg"));
			
			g.drawImage(img, 0, 0, this.getWidth(), this.getHeight(), this);
			
			/*Point origin1 = new Point(0, 0);
		    
		    Damage damage1 = new Damage();
		    JLabel label1 = new JLabel();
		    label1.setVerticalAlignment(JLabel.TOP);
		    label1.setHorizontalAlignment(JLabel.LEFT);
		    label1.setOpaque(true);
	        label1.setBackground(Color.CYAN);
	        label1.setForeground(Color.CYAN);
	        label1.setBounds(origin1.x, origin1.y, this.getWidth(), 300);
	        this.add(label1, 1);
	        
	        Point origin2 = new Point(this.getWidth()-400, 0);
		    
		    Damage damage2 = new Damage();
		    JLabel label2 = new JLabel();
		    label2.setVerticalAlignment(JLabel.TOP);
		    label2.setHorizontalAlignment(JLabel.LEFT);
		    label2.setOpaque(true);
	        label2.setBackground(Color.GREEN);
	        label2.setForeground(Color.GREEN);
	        label2.setBounds(origin2.x, origin2.y, 400, this.getHeight());
	        this.add(label2, 0);*/
	        
	    } catch (IOException e) {
	    	e.printStackTrace();
	    }                
	  } 
}
