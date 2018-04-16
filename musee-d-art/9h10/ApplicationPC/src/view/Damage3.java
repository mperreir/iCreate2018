package view;

import java.awt.Color;
import java.awt.GradientPaint;
import java.awt.Graphics;
import java.awt.Graphics2D;
import javax.swing.JComponent;

public class Damage3 extends JComponent {
	public void paintComponent(Graphics g){
	    Graphics2D g2d = (Graphics2D)g;
	    GradientPaint gp = new GradientPaint(this.getWidth()-500, this.getHeight()-200, new Color(255, 0, 0, 128), this.getWidth()-600, this.getHeight()-300, new Color(0, 0, 0, 0), true);                
	    g2d.setPaint(gp);
	    g2d.fillRect(0, 0, this.getWidth(), this.getHeight());
	}
}
