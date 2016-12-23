/* 
  Saving Values from Arduino to a .csv File Using Processing - Pseduocode

  This sketch provides a basic framework to read data from Arduino over the serial port and save it to .csv file on your computer.
  The .csv file will be saved in the same folder as your Processing sketch.
  This sketch takes advantage of Processing 2.0's built-in Table class.
  This sketch assumes that values read by Arduino are separated by commas, and each Arduino reading is separated by a newline character.
  Each reading will have it's own row and timestamp in the resulting csv file. This sketch will write a new file a set number of times. Each file will contain all records from the beginning of the sketch's run.  
  This sketch pseduo-code only. Comments will direct you to places where you should customize the code.
  This is a beginning level sketch.

  The hardware:
  * Sensors connected to Arduino input pins
  * Arduino connected to computer via USB cord
        
  The software:
  *Arduino programmer
  *Processing (download the Processing software here: https://www.processing.org/download/
  *Download the Software Serial library from here: http://arduino.cc/en/Reference/softwareSerial

  Created 12 November 2014
  By Elaine Laguerta
  http://url/of/online/tutorial.cc

*/

import processing.serial.*;
Serial port;  
Table table; //table where we will read in and store values. You can name it something more creative!

int numReadings = 10; //keeps track of how many readings you'd like to take before writing the file. 
int readingCounter = 0; //counts each reading to compare to numReadings. 
 
String fileName;
void setup()
{
  fileName = str(year()) + str(month()) + str(day()) + str(second()) + ".csv";
  println("Output file is : " + fileName);
  
  // display serial port list for debugging/clarity
  // println(Serial.list());

  // get the first available port (use EITHER this OR the specific port code below)
  String portName = "/dev/cu.wchusbserial1410";
  
  // get a specific serial port (use EITHER this OR the first-available code above)
  //String portName = "COM4";
  
  // open the serial port
  port = new Serial(this, portName, 115200);
  
  table = new Table();
   
  table.addColumn("id"); //This column stores a unique identifier for each record. We will just count up from 0 - so your first reading will be ID 0, your second will be ID 1, etc. 
  
  table.addColumn("stamp");
  table.addColumn("millis");

  
  //the following are dummy columns for each data value. Add as many columns as you have data values. Customize the names as needed. Make sure they are in the same order as the order that Arduino is sending them!
  table.addColumn("sensor");
  table.addColumn("val1");
  table.addColumn("val2");
  table.addColumn("val3");
}

void serialEvent(Serial myPort){
  String val = myPort.readStringUntil('\n'); //The newline separator separates each Arduino loop. We will parse the data by each newline separator. 
  if (val!= null) { //We have a reading! Record it.
    val = trim(val); //gets rid of any whitespace or Unicode nonbreakable space
    print(">> " + val); //Optional, useful for debugging. If you see this, you know data is being sent. Delete if  you like. 
    String sensorVals[] = split(val, '\t'); //parses the packet from Arduino and places the valeus into the sensorVals array. I am assuming floats. Change the data type to match the datatype coming from Arduino. 
    
    if (sensorVals[0].equals("aworld") || sensorVals[0].equals("ypr")) {
      TableRow newRow = table.addRow(); //add a row for this new reading
      newRow.setInt("id", table.lastRowIndex());//record a unique identifier (the row's index)
      
      //record time stamp
      newRow.setInt("millis", millis());
      newRow.setString("stamp", str(year()) + "-" + str(month()) + "-" + str(day()) + " " + str(hour()) + ":" + str(minute()) + ":" + str(second()));
 
      newRow.setString("sensor", sensorVals[0]);
      newRow.setFloat("val1", float(sensorVals[1]));
      newRow.setFloat("val2", float(sensorVals[2]));
      newRow.setFloat("val3", float(sensorVals[3]));
      
      readingCounter++; //optional, use if you'd like to write your file every numReadings reading cycles
      
      //saves the table as a csv in the same folder as the sketch every numReadings. 
      if (readingCounter % numReadings ==0)//The % is a modulus, a math operator that signifies remainder after division. The if statement checks if readingCounter is a multiple of numReadings (the remainder of readingCounter/numReadings is 0)
      {
        saveTable(table, fileName); //Woo! save it to your computer. It is ready for all your spreadsheet dreams.
        println(" + => x");
      } else { 
        println(" +");
      }
    } else { println(""); }
   }
}

void draw()
{ 
   //visualize your sensor data in real time here! In the future we hope to add some cool and useful graphic displays that can be tuned to different ranges of values. 
}