import java.awt.*;
import java.awt.event.*;
import java.awt.datatransfer.*;
import javax.swing.*;
import java.io.*;
import java.util.*;
import java.awt.datatransfer.DataFlavor;
import java.io.IOException;
import java.awt.datatransfer.DataFlavor;
import processing.sound.*;

String OriginText = "";
String transText = "";

final static Map<Character, String> map = new HashMap();
boolean _play = false;
SinOsc  osc;
float freq=440;
char currentChar;
String transTextCp = "";
void setup(){
   fullScreen();
   background(100,100,100);
   osc = new SinOsc(this);
   osc.freq(freq);
   drawOriginText(example);
   for (String[] pair : code)
            map.put(pair[0].charAt(0), pair[1].trim());
}

void drawOriginText(String input){
  OriginText = input;
  textSize(20);
  text(input,20,height/7,width-20,height/3);
}
void drawTransText(String input){
  transText = input;
  textSize(20);
  text(input,20,height/1.8,width-20,height/3);
}
void draw(){
  background(100,100,100);
  String heading = "Translate to Morse";
  stroke(153);
  textSize(44);
  text(heading,(width/2-heading.length()*11),height/8);
  textSize(20);
  fill(0,0,0);
  rect(20,height/2,100,50);
  fill(255,255,255);
  text("Translate",25,height/2 + 30);
  fill(0,0,0);
  rect(20,height/12,100,50);
  fill(255,255,255);
  text("Clipboard",25,height/12 + 30);
  fill(0,0,0);
  rect(140,height/2,100,50);
  fill(255,255,255);
  text("Copy",160,height/2 + 30);
  fill(0,0,0);
  rect(260,height/2,100,50);
  fill(255,255,255);
  text("Play",290,height/2 + 30);
  drawOriginText(OriginText);
  drawTransText(transText);
    
}

void play(){
  int interval = 100;
  
  for (char letter : transTextCp.toCharArray())
  {
   currentChar = letter;
   transText += str(letter);
  
   if(letter == '-'){
     osc.play();
     delay(3*interval);
     osc.stop();
     delay(interval);
   }else if(letter == '.'){
       osc.play();
       delay(interval);
       osc.stop();
       delay(interval);
   }else if(letter == '/'){
       // after each word
       delay(7*interval);
       
   }else if(letter == ' '){
      // after each character
       delay(3*interval);
   
   }
   else{
       print("character not found: " + letter);
   }
   if(!_play){
     break;
   }
   
  
  }
  osc.stop();
}

void mouseReleased() {
  if(mouseX >= 20 && mouseY >= height/2 && mouseX <= 120 && mouseY <= height/2 + 50){
    translateToMorse(OriginText);
  }
  if(mouseX >= 260 && mouseY >= height/2 && mouseX <= 360 && mouseY <= height/2 + 50){
    if(!_play){ 
    transTextCp = transText;
    transText = "";
    }
   
    _play = !_play;
    thread("play");
  
  }
  if(mouseX >= 140 && mouseY >= height/2 && mouseX <= 240 && mouseY <= height/2 + 50){
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    StringSelection stringSelection = new StringSelection(transText);
    clipboard.setContents(stringSelection, stringSelection);
  }
  if(mouseX >= 20 && mouseY >= height/12 && mouseX <= 120 && mouseY <= height/12 + 50){
     Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
                //odd: the Object param of getContents is not currently used
                Transferable contents = clipboard.getContents(null);
                boolean hasTransferableText = (contents != null) && contents.isDataFlavorSupported(DataFlavor.stringFlavor);
                if (hasTransferableText) {
                    try {
                        String result = "";
                        result = (String) contents.getTransferData(DataFlavor.stringFlavor);
                        if(result.length() > 200){
                           OriginText = "The maximum text length is 200 character!"; 
                        }else{
                          OriginText = result;
                        }
                        
                       
                    } catch (UnsupportedFlavorException ex) {
                        System.out.println(ex);
                        ex.printStackTrace();
                    } catch (IOException ex) {
                        System.out.println(ex);
                        ex.printStackTrace();
                    }
                }

  }
}


void translateToMorse(String input){
  transText = "";  
   for (char letter : input.toCharArray())
  {
 
    transText += map.get(Character.toUpperCase(letter)) + " ";
    
  }
  
  drawTransText(transText);
 
 
  
}
