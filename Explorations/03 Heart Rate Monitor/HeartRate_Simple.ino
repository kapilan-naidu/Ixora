#define HR_Pin 0
#define HR_UPPERLIMIT 515
#define HR_LOWERLIMIT 512
int current_time;
int last_time =0; 
int BPM=0;
bool BPMTiming=false;
bool BeatComplete=false;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.println(analogRead(HR_Pin));
  //Serial.print("\t");
  //Serial.println(calc_BPM());
  delay(2);
}
int calc_BPM() {
  current_time=millis(); 
  //Returns the number of milliseconds passed since the Arduino board began running the current program. This number will overflow (go back to zero), after approximately 50 days.
  int value = analogRead(HR_Pin);
  if (value > HR_UPPERLIMIT)
  {
    if (BeatComplete)
    {
      float time_taken = float(current_time-last_time)/1000; // time taken from peak to peak in seconds
      BPM=int(60/time_taken); //freq=1/period
      BPMTiming=false;
      BeatComplete=false;
    }
    if(BPMTiming==false)
    {
      last_time=millis();
      BPMTiming=true;
    }
  }
  if((value < HR_LOWERLIMIT)&(BPMTiming))
    BeatComplete=true;
  return BPM;
}
