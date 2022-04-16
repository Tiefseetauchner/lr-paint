public abstract class GuiItem {
    public int row;
    public int column;
    public int colStretch;
    public int rowStretch;

    public abstract void draw();
}

public class Button extends GuiItem {
    public void draw() {
        
    }
}