import processing.serial.*;

Serial arduino; // Serial object to communicate with Arduino

// Variables for tracking stopwatch times
int[] buttonStartTimes = new int[10];
boolean[] buttonRunning = new boolean[10];

void setup() {
  // Open a connection to Arduino using the same port and baud rate
  arduino = new Serial(this, Serial.list()[2], 9600);
  // Set the window size
  size(1250, 500);
}

void draw() {
  // Draw buttons and stopwatches
  background(255);
  for (int i = 0; i < 10; i++) {
    drawButton(i + 1, "Well " + (i + 1), 40 + i * 120, 40);
  }
  drawResetButton("Reset", 528, 160);
}

void drawButton(int buttonIndex, String label, int x, int y) {
  fill(200);
  rect(x, y, 100, 50);
  fill(0);
  textSize(16);
  text(label, x + 30, y + 15);

  // If the stopwatch is running for this button, update the label with elapsed time
  if (buttonRunning[buttonIndex - 1]) {
    float elapsedTime = (millis() - buttonStartTimes[buttonIndex - 1]) / 1000.0;
    int minutes = int(elapsedTime / 60);
    int seconds = int(elapsedTime) % 60;
    String timeString = nf(minutes, 2) + ":" + nf(seconds, 2);
    text(timeString, x + 32, y + 40);
  }
}

void drawResetButton(String label, int x, int y) {
  fill(200);
  rect(x, y, 200, 120);
  fill(0);
  textSize(32);
  text(label, x + 60, y + 70);
}

void mousePressed() {
  // Check if any button is clicked
  for (int i = 0; i < 10; i++) {
    if (checkButton(i + 1, 40 + i * 120, 40)) {
      // Start the corresponding stopwatch
      buttonStartTimes[i] = millis();
      buttonRunning[i] = true;
      sendCommand(i + 1);
    }
  }
  
  // Check if the "Reset" button is clicked
  if (checkButton(1, 548, 160)) {
    // Reset all stopwatches
    for (int i = 0; i < 10; i++) {
      buttonRunning[i] = false;
    }
    sendCommand(0); // Send '0' as a reset command to the Arduino
  }
}

boolean checkButton(int buttonIndex, int x, int y) {
  return (mouseX > x && mouseX < x + 100 && mouseY > y && mouseY < y + 50);
}

void sendCommand(int command) {
  // Send the command to the Arduino
  arduino.write(command + '0'); // Convert the integer to a character and send
}
