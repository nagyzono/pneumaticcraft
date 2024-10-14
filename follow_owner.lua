function actionWait()
    while not drone.isActionDone()
    do
    sleep(1)
    end
end

function goto(x,y,z)
	drone.addArea(math.floor(x),math.floor(y),math.floor(z))
	drone.setAction("goto")
	actionWait()
	drone.clearArea()
end

drone = peripheral.wrap("left")
owner_pos = drone.getVariable('$owner_pos')

goto(owner_pos.x,owner_pos.y + 2,owner_pos.z)
