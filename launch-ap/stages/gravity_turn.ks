clearScreen.

print "Stage: Gravity turn".
print "".

// Control throttle to keep AP at 50-60 seconds ahead.
// Start pitching to 5 degrees, increase angle and aim for ~45 deg at 10km
// Aim for 10 degrees at 60km

set startAlt to ship:altitude.

print "Starting altitude is " + round(startAlt, 0) + " meters.".

function printStatus {
    declare parameter pitchTarget.
    set pitchActual to pitch_for(ship).
    
    print "Target pitch: " + round(pitchTarget, 3) + " deg     " at (0, 5).
    print "Actual pitch: " + round(pitchActual, 3) + " deg     " at (0, 6).
    print "Pitch error:  " + round(abs(pitchTarget - pitchActual), 3) + " deg      " at (0, 7).
}

function getThrottleValue {
    if ship:orbit:apoapsis >= 80000 {
        return 0.
    }

    return min(1, max(0, -0.1 * ship:orbit:eta:apoapsis + 6)).
}

until ship:altitude > 10000 and pitch_for(ship) >= 45 {
    set pitchTarget to ((-40) / (10000 - startAlt)) * ship:altitude + 85 + ((40 * startAlt) / (10000 - startAlt)).
    set steeringCtrl to heading(90, pitchTarget).
    printStatus(pitchTarget).
    set throttleCtrl to getThrottleValue().
}

set startAlt to ship:altitude.
print "Transitional altitude is " + round(startAlt) + " meters.".

until ship:altitude > 60000 and pitch_for(ship) < 11 and pitch_for(ship) > 9 {
    set pitchTarget to ((-35) / (60000 - startAlt)) * ship:altitude + 45 + ((35 * startAlt) / (60000 - startAlt)).
    set steeringCtrl to heading(90, pitchTarget).
    printStatus(pitchTarget).
    set throttleCtrl to getThrottleValue().
}