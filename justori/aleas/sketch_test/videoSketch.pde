import processing.video.*;

Movie mov;
PGraphics offscreen;

public class videoSketch extends AbstractSketch {

    public videoSketch (final PApplet parent, final int width, final int height, Movie Mov) {
        super(parent, width, height);
        mov = Mov;
        mov.loop();
    }

    @Override
    public void draw() {
        graphics.beginDraw();
        graphics.background(255);
        graphics.image(mov, 0, 0);
        graphics.endDraw();
    }
    
     @Override
    public void keyEvent(KeyEvent event) {

    }

    @Override
    public void mouseEvent(MouseEvent event) {

    }

    @Override
    public void setup() {

    }

    void movieEvent(Movie m) {
        m.read();
    }
}
