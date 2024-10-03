set wd to scriptpath():volume:name + ":/" + scriptpath():parent:segments:join("/").
cd(wd).

declare targetAlt to 80000.
set targetAltitude to targetAlt.

print("Loading libraries...").

run "0:/lib/lib_navball".

print("Initialising settings").

set throttleCtrl to 0.
set steeringCtrl to ship:facing:topvector.

lock throttle to throttleCtrl.

run "stages/countdown".
lock steering to steeringCtrl.
run "stages/stage_ctrl".
run "stages/launch".
run "stages/gravity_turn".
run "stages/coast".
run "stages/circularize".

clearscreen.
print "You should be in stable orbit now.".
print "Thank you for flying for Ev-Pilots.".
