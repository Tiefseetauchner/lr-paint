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
int pixelHeight = 4;

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

void keyPressed(KeyEvent event) {
    switch(event.getKeyCode()) {
        // Key S pressed => save
        case 83:
            save();
            break;
        default:
        println("Lmao this key doesn't do anything lol");
        break;
    }
}

void save() {
    // Alright ok, this is it bois! Here goes what we all been waitin' for! POG
    
    OutputStream outputStream = createOutput("outputImage.qoi");
    
    // ...
    
    // Ok, so... Write the header first I guess?
    
    // Ight, anyone reading this, due to me being fucking STUPID and choosing Processing, 
    // I have to convert my bytes I create to chars and write them cuz that's the only way
    // I found to feed processing raw data. Y A Y
    // Side effect I haven't reached yet, I'll have to split my ints into bytes... that's
    // gonna be.... Interesting.
    
    // OMFG Char only helps me to 128 DAMMIT
    
    // But hey! Magic is easy enough, thank god
    outputStream.write("qoif".getBytes());
    
    // This will not work if your image is larger than 2,147,483,648 px
    // Please don't make 2,147,483,648 px large images in this program
    // Respect your sanity
    int imageWidth = width / pixelWidth;
    int imageHeight = (height - 50) / pixelHeight;
    
    // Write width infor    mation
    for (int i = 3; i >= 0; i--) {
        outputStream.write((byte)(imageWidth >> (i * 8)) & 0xff);
    }
    
    // Write height information
    for (int i = 3; i >= 0; i--) {
        outputStream.write((byte)(imageHeight >> (i * 8)) & 0xff);
    }
    
    outputStream.flush();
    
    outputStream.close();
}