
import spacebrew.*;

String server="sandbox.spacebrew.cc";
String name="piano";
String description ="piano sending pitch and amp";


Spacebrew sb;

int pitch = 512;
int amp = 512;

void setup() {
  size(1280, 1024);
  background(0);
  textSize(72);

  sb = new Spacebrew( this );

  // declare your publishers
  sb.addPublish( "pianoAmp", "range", amp ); 
  sb.addPublish( "pianoPitch", "range", pitch ); 

  sb.connect(server, name, description );
}

void draw() {
  background(50);
  stroke(0);

  float diameter =(float(mouseY) / float(height)) * 200;
  ellipse(mouseX, mouseY, diameter, diameter);
  
  fill(255);
  text("pitch: ", mouseX + 100, mouseY);  
  text(pitch, mouseX + 400, mouseY);  

  text("amp: ", mouseX + 100, mouseY+100);  
  text(amp, mouseX + 400, mouseY+100);  

  
}

void mouseDragged() {
  
  
    amp = int(1024 * (float(mouseY) / float(height)));
    pitch = int(1024 * (float(mouseX) / float(width)));
    //println("sending");
    sb.send("pianoPitch", pitch);
    sb.send("pianoAmp", amp);

    float temp = float(pitch)/1024;    
    //println(temp);
    fill(temp*255);
  
}

