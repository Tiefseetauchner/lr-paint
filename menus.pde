public enum Menu {
   None,
   Save,
   Quit
}

public abstract class MenuBase {
   protected int width;
   protected int height;

   protected String title;

   protected Grid content;

   public Menu menuType;

   public abstract void draw();
}

public class SaveMenu extends MenuBase {
   public SaveMenu() {
       width = 128;
       height = 64;

       title = "Save File";

       content = new Grid();
   }

   public void draw() {
      rect(32, 32, width, height);
   }
}

public class Grid {
   private int rows;
   private int columns;

   private GuiItem[] items;
}