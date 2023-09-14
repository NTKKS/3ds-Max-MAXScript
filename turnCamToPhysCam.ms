cam = $
target = (cam.name+".Target")
target = getNodeByName target
actionMan.executeAction 0 "40068"  -- Views: Camera View
max vpt camera
actionMan.executeAction 0 "40182"
max vpt persp user
clearSelection()
macros.run "Lights and Cameras" "PhysicalCamera_CreateFromView"
physCam = $
physTarget = (physCam.name+".Target")
physTarget = getNodeByName physTarget

physCam.parent = cam
physTarget.parent = target