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

// Please for the love of god leave this at powers of two
int pixelWidth = 16;
int pixelHeight = 16;

void setup() {
    background(255);
    // This too. Powers of two. The height 2^N+50
    // I will know if you cheated
    // I will be very disappointed
    // And also delete your hardrive
    // Now, you might say: Lena! Just calculate the image size, no more problems!
    // Well, you would be WRONG
    // Processing, this stupid piece of garbage doesn't like this:
    // size(imageWidth * pixelWidth, imageHeight * pixelHeight + 50);
    // Cuz "Use only numbers (not variables) for the size() command."
    // SO LEAVE THE NUMBERS HERE ALONE
    // Or at least don't pester me with it
    size(512, 562);
    
    for (int i = 0; i < 8; i++) {
        colors[i + 8] = color(random(0, 255), random(0, 255), random(0, 255));
    }
    
    updateColorSelect();
}

void draw() {
    if (mousePressed && (mouseButton == LEFT)) {
        if (mouseY < height - 50) {
            fill(colors[currentColorIndex]);
            rect(mouseX - (mouseX % pixelWidth), mouseY - (mouseY % pixelHeight), pixelWidth, pixelHeight);
        }
    }
}

void updateColorSelect() {
    int boxWidth = (width / colors.length);
    
    for (int i = 0; i < colors.length; i++) {
        noStroke();
        fill(colors[i]);
        rect(i * boxWidth, height - 50, boxWidth, 50);
    }
    
    stroke(255, 255, 255);
    strokeWeight(3);
    noFill();
    rect((currentColorIndex * boxWidth) + 1,(height - 50) + 1, boxWidth - 2, 48);
    noStroke();
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
        // Key S pressed => save
        case 83:
            save();
            break;
        case 81:
            exit();
            break;
        case 82:
            for (int i = 0; i < 8; i++) {
                colors[i + 8] = color(random(0, 255), random(0, 255), random(0, 255));
            }
            background(255);
            updateColorSelect();
            break;
        default:
        println("Lmao this key doesn't do anything lol: " + event.getKeyCode());
        break;
    }
}