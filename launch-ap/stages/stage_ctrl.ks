function getCurrentDv {
    return ship:stagedeltav(ship:stagenum):current.
}

function getNextStageDv {
    return ship:stagedeltav(ship:stagenum - 1):current.
}

// No staging if the next stage has no delta-v
when getCurrentDv() = 0 and getNextStageDv() <> 0 then {
    wait 0.5.
    stage.
    preserve.
}
