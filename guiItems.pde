import java.util.function.Consumer;

public abstract class GuiItem {
  public abstract void draw(int x, int y, int w, int h);
}

public class Button extends GuiItem {
  private String title;
  private Consumer<String> clickAction;

  public Button(String title, Consumer<String> clickAction) {
    this.title = title;
    this.clickAction = clickAction;

    // Here goes registering a click listener... Man this will be *f u n*
  }

  public void draw(int x, int y, int w, int h) {
    fill(#aaaaaa);
    rectMode(CORNER);
    rect(x, y, w, h);

    fill(#000000);
    textSize(min(h, 40));
    textAlign(CENTER);
    text(title, x + w / 2, y + h / 1.5);
  }
}

public class PlaceholderGuiItem extends GuiItem {
  public void draw(int x, int y, int w, int h) {
  }
}
