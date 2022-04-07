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

void save() {
    int start = millis();
    
    // Alright ok, this is it bois! Here goes what we all been waitin' for! POG
    
    OutputStream outputStream = createOutput("outputImage.qoi");
    
    // ...
    
    // Ok, so... Write the header first I guess?
    try {
        outputStream.write("qoif".getBytes());
        
        // This will not work if your image is larger than 2,147,483,648 px
        // Please don't make 2,147,483,648 px large images in this program
        // Respect your sanity
        int imageWidth = width / pixelWidth;
        int imageHeight = (height - 50) / pixelHeight;
        
        // Write width information
        for (int i = 3; i >= 0; i--) {
            outputStream.write((byte)(imageWidth >> (i * 8)) & 0xff);
        }
        
        // Write height information
        for (int i = 3; i >= 0; i--) {
            outputStream.write((byte)(imageHeight >> (i * 8)) & 0xff);
        }
        
        // Write channel information
        outputStream.write(3);  
        
        // Write colorspace information
        outputStream.write(1);
        
        // The magic :tm: start
        
        color[] image = getImageAsArray();
        
        Integer[] lookup = new Integer[64];
        
        Integer prevPixel = color(0,0,0);
        
        int runLength = -1;
        
        for (int i = 0; i < image.length; i++) {
            Integer c = image[i];
            
            Integer nextPixel = i + 1 < image.length ? image[i + 1] : color(0,0,0);
            
            int r = (c >> 16) & 0xFF;
            int g = (c >> 8) & 0xFF;
            int b = c & 0xFF;
            
            int pR = (prevPixel >> 16) & 0xFF;
            int pG = (prevPixel >> 8) & 0xFF;
            int pB = prevPixel & 0xFF;
            
            int diffR = (((r - pR + 2) % 256) + 256) % 256;
            int diffG = (((g - pG + 2) % 256) + 256) % 256;
            int diffB = (((b - pB + 2) % 256) + 256) % 256;
            
            int diffGLumaUnbiased = (((g - pG) % 256) + 256) % 256;
            int diffRLuma = ((((r - pR) - diffGLumaUnbiased + 8) % 256) + 256) % 256;
            int diffGLuma = (((g - pG + 32) % 256) + 256) % 256;
            int diffBLuma = ((((b - pB) - diffGLumaUnbiased + 8) % 256) + 256) % 256;
            
            byte lookupIndex = (byte)((r * 3 + g * 5 + b * 7 + 255 * 11) % 64);
            
            if (runLength == 0x3c || (prevPixel == c && c != nextPixel)) {
                // QOI_OP_RUN
                runLength ++;
                outputStream.write(runLength & 0xff | 0xc0);
                runLength = -1;
            } else if (i + 1 != image.length && prevPixel == c && c == nextPixel) {
                // QOI_OP_RUN Next pixel same
                runLength ++;
            } else if (c == lookup[lookupIndex]) {
                // QOI_OP_INDEX
                outputStream.write(lookupIndex & 0x3F);
            } else if (diffR < 4 && diffG < 4 && diffB < 4) {
                // QOI_OP_DIFF
                outputStream.write(0x40 | (0x7F & ((diffR << 4) | (diffG << 2) | diffB)));
            } else if (diffRLuma < 16 && diffBLuma < 16 && diffGLuma < 64) {
                // QOI_OP_LUMA
                outputStream.write(0x80 | (diffGLuma & 0x3f));
                outputStream.write(((diffRLuma & 0x0f) << 4) | (diffBLuma & 0x0f));
            } else {
                // QOI_OP_RGB                    
                outputStream.write(0xFE);
                outputStream.write(r);
                outputStream.write(g);
                outputStream.write(b);
            }
            
            if (lookup[lookupIndex] == null)
                lookup[lookupIndex] = c;
            prevPixel = c;
        }
        
        // The magic :tm: end
        
        // EOF
        for (int i = 0; i < 7; i++)
            outputStream.write((byte) 0x00);
        outputStream.write((byte) 0x01);
        
        outputStream.flush();
        
        outputStream.close();
        
        int end = millis();
        
        int dur = end - start;
        println("save took " + dur + " ms");
    } catch(IOException e) {
        println("Well. Something went wrong. G R E A T");
        e.printStackTrace();
    }
}

color[] getImageAsArray() {
    int imageWidth = width / pixelWidth;
    int imageHeight = (height - 50) / pixelHeight;
    
    color[] out = new color[imageHeight * imageWidth];
    
    for (int ypoint = 0; ypoint < imageHeight; ypoint++) {
        for (int xpoint = 0; xpoint < imageWidth; xpoint++) {
            out[ypoint * imageWidth + xpoint] = get(xpoint * pixelWidth, ypoint * pixelHeight);
        }
    }
    
    return out;
}