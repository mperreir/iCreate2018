package view;

import java.awt.Color;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JPanel;

public class MyFrame extends JFrame implements MouseListener {
	JLayeredPane container;
	JComponent damage;
	
	public MyFrame() {
		this.setTitle("iCreate - 9h10");
		//this.setSize(720, 480);
		this.setExtendedState(JFrame.MAXIMIZED_BOTH);
	    this.setLocationRelativeTo(null);
	    this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	    
	    this.container = new Painting();
	    this.container.setBackground(Color.WHITE);
	    this.setContentPane(this.container);
	    this.container.setLayout(new BoxLayout(this.container, BoxLayout.LINE_AXIS));
	   

		Damage2 d2 = new Damage2();
		Damage3 d3 = new Damage3();
		Damage4 d4 = new Damage4();
		
	    /*Damage damage1 = new Damage();
	    JLabel label1 = new JLabel();
	    label1.setVerticalAlignment(JLabel.TOP);
	    label1.setHorizontalAlignment(JLabel.LEFT);
	    label1.setOpaque(true);
        label1.setBackground(Color.CYAN);
        label1.setForeground(Color.CYAN);
        label1.setBounds(0, 0, 1920, 300);
        this.container.add(label1, new Integer(0));
        label1.setVisible(true);*/
	    
	    this.damage = new Damage();
	    this.container.add(damage);
	    this.damage.setVisible(true);
	    
	    
	    /*int count = 0;
	    while (count <= 0) {
	    	System.out.println("Count = " + count);
	    	OtherDamage drawing = new OtherDamage();
		    this.setGlassPane(drawing);
		    drawing.setVisible(true);
		    count += 1;
	    }*/
	    
	    this.setVisible(true);
	}
	
	public JComponent getDamage() {
		return this.damage;		
	}
	
	public void setDamage(JComponent damage) {
	    this.container.remove(this.damage);
		this.damage = damage;
	    this.damage.setVisible(true);
	}
	
	public void setGlassPaneNew(JComponent comp) {
		this.setGlassPane(comp);
	}

	@Override
	public void mouseClicked(MouseEvent arg0) {

		Damage2 d2 = new Damage2();
		Damage3 d3 = new Damage3();
		Damage4 d4 = new Damage4();
		
		int count = 0;
		if (count==0) {
			this.setDamage(d2);
			count+=1;
		} else if (count==1) {
			this.setDamage(d3);
		} else if (count==2) {
			this.setDamage(d4);
		} else {
			this.damage.setVisible(false);
		}
		
	}

	@Override
	public void mouseEntered(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseExited(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mousePressed(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseReleased(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
	}
	
}
