function actionWait()
    while not drone.isActionDone()
    do
    sleep(1)
    end
end

function checkInventory(count, operator)
	drone.setCount(count)
	drone.setOperator(operator)
	drone.setAction("drone_condition_item")
	return drone.evaluateCondition()
end

function pickup(x,y,z)
  drone.addArea(x,y,z)
	drone.setSide("up", true)
	drone.setUseCount(true)
	drone.setCount(1)
  drone.setAction("inventory_import")
	actionWait()
	drone.clearArea()
end

function getPos()
    return drone.getDronePositionVec()
end


drone = peripheral.wrap("left")
start_pos = getPos()
pickup(start_pos.x,start_pos.y,start_pos.z)
