public abstract class GuiItem {
  public abstract void draw(int x, int y, int w, int h);
}

public class Button extends GuiItem {
  public void draw(int x, int y, int w, int h) {
    fill(123, 60, 20);
    rectMode(CORNER);
    rect(x, y, w, h);
  }
}
