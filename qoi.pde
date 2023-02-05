color[] colors = {
  #000000,
  #ffffff,
  #ff0000,
  #00ff00,
  #0000ff,
  #ffff00,
  #ff00ff,
  #00ffff,
  #000000,
  #000000,
  #000000,
  #000000,
  #000000,
  #000000,
  #000000,
  #000000,
};
int currentColorIndex = 0;

int drawPixelWidth = 16;
int drawPixelHeight = 16;

int imageWidth = 32;
int imageHeight = 32;

color imageData[];

MenuBase currentMenu;

void settings() {
  size(imageWidth * drawPixelWidth, imageHeight * drawPixelHeight + 50);
}

void setup() {
  background(255);

  for (int i = 0; i < 8; i++) {
    colors[i + 8] = color(random(0, 255), random(0, 255), random(0, 255));
  }

  imageData = new color[imageWidth * imageHeight];

  for (int i = 0; i < imageWidth * imageHeight; i++)
    imageData[i] = #FFFFFF;

  updateColorSelect();
}

void draw() {
  drawImage();
  updateColorSelect();

  if (currentMenu == null) {
    if (mousePressed && (mouseButton == LEFT)) {
      if (mouseY < height - 50) {
        imageData[constrain(mouseX / drawPixelWidth, 0, imageWidth - 1) + constrain((mouseY / drawPixelHeight), 0, imageHeight - 1) * imageWidth] = colors[currentColorIndex];
      }
    }
  } else {
    currentMenu.draw();
  }
}


//TODO change highlight color to inverse of selected
void updateColorSelect() {
  int boxWidth = (width / colors.length);

  for (int i = 0; i < colors.length; i++) {
    noStroke();
    fill(colors[i]);
    rect(i * boxWidth, height - 50, boxWidth, 50);
  }

  colorMode(HSB, 255, 255, 255);

  color current = colors[currentColorIndex];
  stroke(color((hue(current) + 128) % 256, saturation(current), (brightness(current) + 128) % 256));
  strokeWeight(3);
  noFill();

  rect((currentColorIndex * boxWidth) + 1, (height - 50) + 1, boxWidth - 2, 48);

  noStroke();
  colorMode(RGB, 255, 255, 255);
}

void mouseWheel(MouseEvent event) {
  currentColorIndex = (((currentColorIndex + event.getCount()) % colors.length) + colors.length) % colors.length;

  updateColorSelect();
}

void mousePressed(MouseEvent event) {
  if (event.getButton() == 39) {
    println("This button is depricated because IT FUCKS. ME. UP.");
  }
}

void keyPressed(KeyEvent event) {
  switch(event.getKeyCode()) {
  case 83:
    // Key S pressed => save
    currentMenu = new SaveMenu();
    //save();
    break;
  case 81:
    // Key Q pressed => Quit menu or application
    if (currentMenu != null)
      currentMenu = null;
    else
      exit();
    break;
  case 82:
    // Key r pressed => Reset canvas
    for (int i = 0; i < 8; i++) {
      colors[i + 8] = color(random(0, 255), random(0, 255), random(0, 255));
    }
    for (int i = 0; i < imageWidth * imageHeight; i++)
      imageData[i] = #FFFFFF;
    updateColorSelect();
    break;
  default:
    println("Lmao this key doesn't do anything lol: " + event.getKeyCode());
    break;
  }
}

void drawImage() {
  for (int i = 0; i < imageHeight; i++) {
    for (int j = 0; j < imageWidth; j++) {
      fill(imageData[i * imageWidth + j]);
      rect(j * drawPixelWidth, i * drawPixelHeight, j * drawPixelWidth + drawPixelWidth, i * drawPixelHeight + drawPixelHeight);
    }
  }
}
