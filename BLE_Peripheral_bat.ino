#include <ArduinoBLE.h>
BLEService newService("180A");  // Creating the service (Device Information)

BLEUnsignedCharCharacteristic shotType("2A58", BLERead | BLENotify); // Creating the Analog Value characteristic
BLEByteCharacteristic switchChar("2A57", BLERead | BLEWrite); // Creating the LED characteristic

const int ledPin = 2;
long previousMillis = 0;
bool shot = true;
bool vibration = false;
bool vibrationMiss = false;
const unsigned long eventInterval = 2500;
unsigned long previousTime = 0;

void setup() {
  //Serial.begin(9600);   // Init serial comm
 // while(!Serial);       // Start if we open the serial monitor
  pinMode(3, INPUT_PULLUP);// set pin as input
  pinMode(2, INPUT_PULLUP);// set pin as input
//  pinMode(LED_BUILTIN, OUTPUT); // Will be used to indicate when a central device is connected
//  pinMode(ledPin, OUTPUT);      // Led controlled by central device

  // Init ArduinoBLE library
  if(!BLE.begin()) {
   // Serial.println("Starting BLE failed");
    while(1);
  }

  BLE.setLocalName("SmartShot");  // Setting a name
  BLE.setAdvertisedService(newService);

  newService.addCharacteristic(switchChar);  // Add characteristics to the service
  newService.addCharacteristic(shotType);

  BLE.addService(newService);

  switchChar.writeValue(0);     // Set initial value for characteristics
  shotType.writeValue(0);

  BLE.advertise();    // Start advertising the service
 // Serial.println("Bluetooth device active, waiting for connections...");
}

void loop() {
  BLEDevice central = BLE.central();    // Wait for a BLE central

  if(central) {
  //  Serial.println("Connected to central: ");

   // Serial.println(BLE.address());  // Print the central's address

    digitalWrite(LED_BUILTIN, HIGH);   // Turn on the LED to indicate the connection


    while(central.connected()) {
   //   long currentMillis = millis();
//      if(currentMillis - previousMillis >= 200) {
//        previousMillis = currentMillis;
//
//        int randomValue = analogRead(A1);       // Read from analog pin and write value to randomReading characteristic
//        randomReading.writeValue(randomValue);
//        Serial.println(randomValue);
//
//        if(switchChar.written()) {    // Query if the characteristic value has been written by another BLE device.
//          if(switchChar.value()) {    // Any value other than 0
//            Serial.println("LED on");
//            digitalWrite(ledPin, HIGH);   // Turn on LED
//          } else {
//            Serial.println("LED off");
//            digitalWrite(ledPin, LOW);    // Turn off LED
//          }
//        }
//      }

int detectVibration = digitalRead(3);
  if(detectVibration == HIGH){
    
   //Serial.println("Vibration Sensed");
   vibration = true;
  } 
  else vibration = false;

  if (vibration)
  {
    unsigned long previousTime = millis();
     while(1)
    {
      unsigned long currentTime = millis();
      int detectShot = digitalRead(2); 
      vibrationMiss = true;

      if(detectShot == LOW){
      //  Serial.println("BASKET MADE: Bank Shot or Rim Shot"); 
        //send data over BLE
        int bankShot = 1;       // Read from analog pin and write value to randomReading characteristic
        shotType.writeValue(bankShot);
        shot = true;
        break;
      }

      if(currentTime - previousTime >= eventInterval)
      break;
    } 

    if(vibrationMiss && !shot)
      {
       // Serial.println("Shot Missed"); 
        vibrationMiss = false;
        //send data over BLE
        int miss = 0;       // Read from analog pin and write value to randomReading characteristic
        shotType.writeValue(miss);
      }                 
  }
  shot = false;

  int detectShot = digitalRead(2); 
  if(detectShot == LOW){
  // Serial.println("BASKET MADE: Swish Shot"); 
   //send data over BLE
   int swish = 3;       // Read from analog pin and write value to randomReading characteristic
   shotType.writeValue(swish);
  }
 
   delay(300);
    }
    
    digitalWrite(LED_BUILTIN, LOW);   // When the central disconnects, turns off the LED
   // Serial.print("Disconnected from cental: ");
   // Serial.println(central.address());
  }
}
