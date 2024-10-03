clearscreen.

print "Stage: Countdown".
print "".

from {local countdown is 9.} until countdown = -1 step {set countdown to countdown - 1.} do {
  print "Launch to " + round(targetAltitude / 1000, 1) + " km orbit in T-" + countdown + " seconds..." at (0,3).
  wait 1.
}
