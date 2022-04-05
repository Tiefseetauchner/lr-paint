color[] colors = {
    color(0,0,0),
        color(255, 255, 255),
        color(255, 0, 0),
        color(0, 255, 0),
        color(0, 0, 255),
        color(255, 255, 0),
        color(255, 0, 255),
        color(0, 255, 255),
    };
int currentColorIndex = 0;

// Please for the love of god leave this at powers of two
int pixelWidth = 8;
int pixelHeight = 8;

void setup() {
    background(255);
    size(512, 562);
    
    updateColorSelect();
}

void draw() {
    if (mousePressed) {
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
    strokeWeight(9);
    noFill();
    rect((currentColorIndex * boxWidth) + 4,(height - 50) + 4, boxWidth - 8, 42);
    noStroke();
}


void mouseWheel(MouseEvent event) {
    currentColorIndex = (((currentColorIndex + event.getCount()) % colors.length) + colors.length) % colors.length;
    
    updateColorSelect();
}

void mousePressed(MouseEvent event) {
    if (event.getButton() == 39) {
        println("Thank you for choosing this fucking hellhole of a program!");
        
        exit();
    }
}