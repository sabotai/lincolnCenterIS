//created from spacebrew base and dan ellis' SinePiano code dpwe@ee.columbia.edu



import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioOutput out;

import spacebrew.*;

String server="sandbox.spacebrew.cc";
String name="Fountain Master";
String description ="i want all the notes";

Spacebrew sb;

int howMany = 5;
int[] numInstruments = new int[howMany];
float[] instrumentValue = new float[howMany];


float pitch = 0;
float amp = 0;

void setup() {
  size(1280, 1024);

  // instantiate the sb variable
  sb = new Spacebrew( this );

  // add each thing you publish to
  // sb.addPublish( "buttonPress", "boolean", buttonSend ); 

  // add each thing you subscribe to
  sb.addSubscribe( "pitch", "range" );
  sb.addSubscribe( "amp", "range" );


  // connect to spacebrew
  sb.connect(server, name, description );

  //assign the amplitude values for each of the instruments
  for (int i = 0; i < howMany; i++) {
    instrumentValue[i] = i * 0.5;
  }



  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
}

void draw() {
}
void playSound() {
}

void onRangeMessage( String name, int value ) {

  if ((pitch == 0) || (amp == 0)) {
    println("received_" + name + "_" + value + "_");

    if (name.equals("pitch")) {
      println("pitch is " + value);
      pitch = value;
    }

    if (name.equals("amp")) {
      println("amp is " + float(value)/1024);
      amp = float(value)/1024;
    }
  } else {
    println("receiving pitch and amp");

    SineWave mySine;
    MyNote newNote;

    background((pitch/1024) * 255);

    if (pitch > 0) {
      newNote = new MyNote(pitch, amp);
    }

    amp = 0;
    pitch = 0;
  }
}


void stop()
{
  out.close();
  minim.stop();

  super.stop();
}

class MyNote implements AudioSignal
{
  private float freq;
  private float level;
  private float alph;
  private SineWave sine;

  MyNote(float pitch, float amplitude)
  {
    freq = pitch;
    level = amplitude;
    sine = new SineWave(freq, level, out.sampleRate());
    alph = 0.9;  // Decay constant for the envelope
    out.addSignal(this);
  }

  void updateLevel()
  {
    // Called once per buffer to decay the amplitude away
    level = level * alph;
    sine.setAmp(level);

    // This also handles stopping this oscillator when its level is very low.
    if (level < 0.01) {
      out.removeSignal(this);
    }
    // this will lead to destruction of the object, since the only active 
    // reference to it is from the LineOut
  }

  void generate(float [] samp)
  {
    // generate the next buffer's worth of sinusoid
    sine.generate(samp);
    // decay the amplitude a little bit more
    updateLevel();
  }

  // AudioSignal requires both mono and stereo generate functions
  void generate(float [] sampL, float [] sampR)
  {
    sine.generate(sampL, sampR);
    updateLevel();
  }
}



