// Define the digital pins to which the solenoids are connected
const int solenoidPins[] = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11}; // Change these to the appropriate pin numbers for your solenoids

// Variables for tracking button presses
boolean buttonPressed[10] = {false}; // One entry for each button
unsigned long buttonPressTimes[10];

void setup() {
  // Set the solenoid pins as outputs
  for (int i = 0; i < 10; i++) {
    pinMode(solenoidPins[i], OUTPUT);
    digitalWrite(solenoidPins[i], LOW);
  }
  Serial.begin(9600);
}

void loop() {
  // Check if the button is clicked and start the delay timer
  if (Serial.available() > 0) {
    int buttonIndex = Serial.read() - '0'; // Convert character to integer
    if (buttonIndex >= 1 && buttonIndex <= 10) {
      buttonPressed[buttonIndex - 1] = true;
      buttonPressTimes[buttonIndex - 1] = millis();
    } else if (buttonIndex == 0) {
      // Reset all button presses when the '0' command is received
      for (int i = 0; i < 10; i++) {
        buttonPressed[i] = false;
      }
    }
  }

  // Check if X min have passed since the button press and activate the solenoid (change for delay to wind pulse)
  for (int i = 0; i < 10; i++) {
    if (buttonPressed[i] && (millis() - buttonPressTimes[i] >= 480000)) {
      activateSolenoid(i + 1);
      buttonPressed[i] = false;
    }
  }
}

void activateSolenoid(int buttonIndex) {
  digitalWrite(solenoidPins[buttonIndex - 1], HIGH);
  delay (15000); // Activate the solenoid for X milliseconds
  digitalWrite(solenoidPins[buttonIndex - 1], LOW); // Deactivate the solenoid (has to be longer than HIGH delay)
  delay (1000);
}