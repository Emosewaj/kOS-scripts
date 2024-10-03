clearscreen.

function shipPointsAtNode {
    parameter manNode.

    return vDot(manNode:burnvector:normalized, ship:facing:forevector:normalized) >= cos(5).
}

print "Stage: Circularization".
print "".

until not allNodes:length {
    remove nextNode.
    wait 0.
}

// this is the part that gets complicated so I'm gonna leave myself comments

// Circular orbit velocity
set vTarget to sqrt(ship:body:mu / (ship:body:radius + ship:apoapsis)).

// Current velocity at apoapsis.
set vActual to velocityAt(ship, time:seconds + ship:orbit:eta:apoapsis):orbit:mag.

set circNode to node(time:seconds + ship:orbit:eta:apoapsis, 0, 0, vTarget - vActual).
add circNode.
set steeringCtrl to circNode:burnvector.

// Dot product of two normalised vectors is 1 if they face the same direction, cos(5) allows for 5 degrees of offset
// idek how to explain how those two things are corelated, just believe me
// learned by reading this and experimenting with the same method
// https://github.com/xeger/kos-ramp/blob/master/ramp/lib_util.ks#L212
wait until shipPointsAtNode(circNode).

set totalIsp to 0.
set totalMassFlowRate to 0.
for engine in ship:engines {
    if engine:ignition and not engine:flameout {
        set totalIsp to totalIsp + engine:isp.
        set totalMassFlowRate to totalMassFlowRate + engine:maxMassFlow.
    }
}

// Calculate half burn duration using derivative of ideal rocket equation
set halfDv to circNode:deltav:mag / 2.
set massAfterHalfBurn to ship:mass * constant:e ^ (-halfDv / (totalIsp * constant:g0)).
set massPropellant to ship:mass - massAfterHalfBurn.
set halfBurnDuration to massPropellant / totalMassFlowRate.

set startBurnAt to circNode:time - halfBurnDuration.
kuniverse:timewarp:warpto(startBurnAt - 10).
until time:seconds >= startBurnAt {
    set steeringCtrl to circNode:burnvector.
}

set throttleCtrl to 0.
set minDeltav to circNode:deltav:mag.
set maxThrottle to 1.
until circNode:deltav:mag < 0.05 {
    if not shipPointsAtNode(circNode)
        set maxThrottle to 0.
    else
        set maxThrottle to 1.

    set minDeltav to min(minDeltav, circNode:deltav:mag).
    set steeringCtrl to circNode:burnvector.
    // Throttle goes down as deltaV in the node decreases based on ship mass and engine thrust
    set throttleCtrl to min(maxThrottle, minDeltav * ship:mass / ship:availablethrust).
}
set throttleCtrl to 0.
remove circNode.