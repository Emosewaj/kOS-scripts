clearScreen.

print "Stage: Coasting to AP target".
print "".

// Keep pushing with current or minimum engine thrust
set throttleCtrl to max(throttleCtrl, 0.1).
until ship:apoapsis >= targetAltitude {
    set steeringCtrl to ship:prograde.
}
set throttleCtrl to 0.

print "Stage: Coasting to edge of atmosphere" at (0,0).
set kuniverse:timewarp:mode to "PHYSICS".
set kuniverse:timewarp:warp to 3.
wait until ship:altitude >= 70000.
set kuniverse:timewarp:warp to 0.
set kuniverse:timewarp:mode to "RAILS".