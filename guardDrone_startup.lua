function getActions()
    actions=drone.getAllActions()
    actionsConcat=table.concat(actions,", ")
    actionsConcat=actionsConcat:gsub("pneumaticcraft:","")
    print(actionsConcat)
end

function getPos()
    return drone.getDronePositionVec()
end

function renameDrone(name)
	drone.setRenameString(name)
	drone.setAction("rename")
	actionWait()
end

function actionWait()
    while not drone.isActionDone()
    do
    sleep(1)
    end
end

function standby()
	drone.setAction("standby")
	actionWait()
end

function checkInventory(count, operator)
	drone.setCount(count)
	drone.setOperator(operator)
	drone.setAction("drone_condition_item")
	return drone.evaluateCondition()
end

function checkPressure(count, operator)
	drone.setCount(count)
	drone.setOperator(operator)
	drone.setAction("drone_condition_pressure")
	return drone.evaluateCondition()
end

function importFromInventory(x,y,z)
    drone.addArea(x,y,z)
	drone.setSide("up", true)
	drone.setUseCount(true)
	drone.setCount(1)
    drone.setAction("inventory_import")
	actionWait()
	drone.clearArea()
end

function getAmmo(x,y,z)
	if checkInventory(0, "=") then
		renameDrone("out of ammo")
		goto(x,y + 1,z)
		importFromInventory(x,y,z)
	end
end

function forceRefuel(x,y,z)
	if checkPressure(3, "<=") then
		renameDrone("out of pressure")
		goto(x,y,z)
		actionWait()
		standby()
		while not checkPressure(10, "=")
		do
			sleep(2)
		end
	end
end

function goto(x,y,z)
	drone.addArea(math.floor(x),math.floor(y),math.floor(z))
	drone.setAction("goto")
	actionWait()
	drone.clearArea()
	drone.abortAction()
end

function setGuardPos(modifier)
	return {x=start_pos.x,y=start_pos.y + modifier,z=start_pos.z}
end

function guard(guard_pos)
    standby()
    drone.abortAction()
    drone.addWhitelistText("@mob")
    drone.addArea(
        guard_pos.x - 25,
        guard_pos.y - 7,
        guard_pos.z - 25,
        guard_pos.x + 25,
        guard_pos.y + 7,
        guard_pos.z + 25,
        "filled"
    )
    drone.setAction("entity_attack")
    actionWait()
    drone.clearArea()
    drone.clearWhitelistText()
end

function resetDrone()
    drone.setAction("standby")
    sleep(2)
    drone.clearArea()
    drone.clearWhitelistText()
end



function droneGuard()
	drone = peripheral.wrap("left")
	resetDrone()
	renameDrone("Guard routine starting...")
	standby()
	start_pos = getPos()
	guard_pos = setGuardPos(0)
	sleep(2)
	while true
	do
		resetDrone()
		forceRefuel(2237, 79, -1071)
		getAmmo(2261, 76, -1070)
		goto(guard_pos.x, guard_pos.y, guard_pos.z)
		renameDrone("Guard")
		guard(guard_pos)
	end
end

droneGuard()
