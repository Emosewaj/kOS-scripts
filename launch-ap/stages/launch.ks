clearscreen.

print "Stage: Launch".
print "".
print "Liftoff!".

set throttleCtrl to 1.
set steeringCtrl to heading(90, 90).

wait until ship:velocity:surface:mag >= 100 or ship:altitude >= 1000.
