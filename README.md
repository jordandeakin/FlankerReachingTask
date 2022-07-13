# RDK Reaching

This code runs a mouse tracking/stylus flanker task using random dot kinematograms (RDKs). Participants must determine whether the coherent motion in the center RDK is leftwards or rightwards moving. To respond, participants move the cursor towards one of two response boxes. This task manipulates motion coherence randomly across trials. The experiment can be quit by pressing q during a trial.


## Output
Saves a .mat file to the current folder. This file contains a data struct with fields 'trialSequence' and 'demographics'.
"Demographics" stores participant age, gender and participant number.
"trialSequence" is a table containing the following variables:


<strong> Trial </strong> - Trial number<br>
<strong> Coherence </strong> - Motion Coherence<br>
<strong> Practice </strong> - 1 = Practice | 0 = Experimental<br>
<strong> TargetDir </strong> - Target Direction<br>
<strong> Congruency </strong> - 1 = Congruent | 2 = Incongruent<br>
<strong> FlankerDir </strong> - Flanker Direction<br>
<strong> Acc </strong> - Accuracy: 0 = Incorrect, 1 = Correct<br>
<strong> RT </strong> - Reaction time in seconds<br>
<strong> MousePathX </strong> - x coordinates of cursor.<br>
<strong> MousePathY </strong> - y coordinates of cursor.<br>


## How to Run
```matlab
% For Arrangement 1
startReaching(1)

% For Arrangement 2
startReaching(2)
```

## Spatial Arrangement Options
This code has two options for different spatial arrangements.
1. Items are displayed in the centre of the screen and the response boxes are eitherside.
 
![alt text](https://github.com/jordandeakin/FlankerReachingTask/blob/master/img/Arrangement1.jpg?raw=true)

2. Items are displayed at the top of the screen and the response boxes are below.

![alt text](https://github.com/jordandeakin/FlankerReachingTask/blob/master/img/Arrangement2.jpg?raw=true)


## Trial Sequence
A trial begins by asking the participant to move the cursor to the red start box.

<img src="https://github.com/jordandeakin/FlankerReachingTask/raw/master/img/StartBox.jpg" width="355" height="200" />

Once the cursor enters the start box, they are prompted to click to start the trial. Once clicked, a fixation cross is displayed for 500ms.

<img src="https://github.com/jordandeakin/FlankerReachingTask/raw/master/img/Wait.jpg" width="355" height="200" />
          
The flanker array is presented and participants respond by moving towards one of the response boxes.

<img src="https://github.com/jordandeakin/FlankerReachingTask/raw/master/img/Arrangement1.jpg" width="355" height="200" />

In practice trials, auditory feedback is given. 