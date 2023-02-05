public enum Menu {
  None,
    Save,
    Quit
}

public abstract class MenuBase {
  protected int menuWidth;
  protected int menuHeight;

  protected String title;

  protected Grid content;

  public Menu menuType;

  public abstract void draw();
}

public class SaveMenu extends MenuBase {
  public SaveMenu() {
    menuWidth = width - 100;
    menuHeight = 200;

    title = "Save File";
    
    Button saveButton = new Button("Save", (s) -> {});

    content = new Grid(2, 1, new GuiItem[]{new PlaceholderGuiItem(), saveButton}, 10, 50, menuWidth - 20, menuHeight - 60);
  }

  public void draw() {
    rectMode(CORNER);
    fill(0, 0, 0, 100);
    rect(0, 0, width, height);
    
    push();
    translate(width / 2 - menuWidth / 2, height / 2 - menuHeight / 2);
    
    fill(#505050);
    rect(0, 0, menuWidth, menuHeight);
    
    fill(#ffffff);
    textAlign(LEFT);
    textSize(40);
    text(title, 10, 35);
    
    content.draw();
    
    pop();
  }
}

public class Grid {
  private int rows;
  private int columns;

  private int x;
  private int y;
  private int gridWidth;
  private int gridHeight;
  
  // For now this'll be hardcoded, I don't see a real benefit of exposing this
  private int padding = 5;

  // Keep in mind this wraps, so two rows and two columns will result in 4 items, the first are at the top and the others are at the bottom
  private GuiItem[] items;

  public Grid(int rows, int columns, GuiItem[] items, int x, int y, int w, int h) {
    if (items.length > rows * columns) {
      throw new IllegalArgumentException("there can't be more gui items than spaces in the grid");
    }

    this.rows = rows;
    this.columns = columns;
    this.items = items;
    this.x = x;
    this.y = y;
    this.gridWidth = w;
    this.gridHeight = h;
  }

  public void draw() {
    int itemWidth = (gridWidth - padding * (columns - 1)) / columns;
    int itemHeight = (gridHeight - padding * (rows - 1)) / rows;
    
    for (int i = 0; i < items.length; i++) {
      items[i].draw(x + i % columns * (itemWidth + padding), y + i / columns * (itemHeight + padding), itemWidth, itemHeight);
    }
  }
}
