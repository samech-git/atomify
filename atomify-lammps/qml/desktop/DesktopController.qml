import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Logic 2.0
import QtQml 2.2

Entity {
    id: root
    signal pressed

    property Camera camera
    property real linearSpeed: 40.0
    property real lookSpeed: 500.0
    property real zoomSpeed: 20.0
    property real zoomLimit: 2.0
    property real moveSpeed: 1.0

    QtObject {
        id: d
        readonly property vector3d firstPersonUp: Qt.vector3d(0, 1, 0)
    }

    function zoomDistance(firstPoint, secondPoint) {
        var u = secondPoint.minus(firstPoint); u = u.times(u);
        return u.x + u.y + u.z;
    }

    KeyboardDevice {
        id: keyboardSourceDevice
    }

    MouseDevice {
        id: mouseSourceDevice
        sensitivity: 0.001
    }

    components: [
        LogicalDevice {
            actions: [
                Action {
                    id: noMouseButtonAction
                    ActionInput {
                        sourceDevice: mouseSourceDevice
                        buttons: [MouseEvent.NoButton]
                    }
                },
                Action {
                    id: leftMouseButtonAction
                    ActionInput {
                        sourceDevice: mouseSourceDevice
                        buttons: [MouseEvent.LeftButton]
                    }
                },
                Action {
                    id: rightMouseButtonAction
                    ActionInput {
                        sourceDevice: mouseSourceDevice
                        buttons: [MouseEvent.RightButton]
                    }
                },
                Action {
                    id: middleMouseButtonAction
                    ActionInput {
                        sourceDevice: mouseSourceDevice
                        buttons: [MouseEvent.MiddleButton]
                    }
                },
                Action {
                    id: shiftAction
                    ActionInput {
                        sourceDevice: keyboardSourceDevice
                        buttons: [Qt.Key_Shift]
                    }
                },
                Action {
                    id: controlAction
                    ActionInput {
                        sourceDevice: keyboardSourceDevice
                        buttons: [Qt.Key_Control]
                    }
                },
                Action {
                    id: altAction
                    ActionInput {
                        sourceDevice: keyboardSourceDevice
                        buttons: [Qt.Key_Alt]
                    }
                }
            ] // actions

            axes: [
                // Mouse
                Axis {
                    id: mouseXAxis
                    AnalogAxisInput {
                        sourceDevice: mouseSourceDevice
                        axis: MouseDevice.X
                    }
                },
                Axis {
                    id: mouseYAxis
                    AnalogAxisInput {
                        sourceDevice: mouseSourceDevice
                        axis: MouseDevice.Y
                    }
                },
                // Keyboard
                Axis {
                    id: keyboardXAxis
                    ButtonAxisInput {
                        sourceDevice: keyboardSourceDevice
                        buttons: [Qt.Key_A]
                        scale: -1.0
                    }
                    ButtonAxisInput {
                        sourceDevice: keyboardSourceDevice
                        buttons: [Qt.Key_D]
                        scale: 1.0
                    }
                },
                Axis {
                    id: keyboardYAxis
                    ButtonAxisInput {
                        sourceDevice: keyboardSourceDevice
                        buttons: [Qt.Key_W]
                        scale: d.shiftPressed ? 0.0 : 1.0
                    }
                    ButtonAxisInput {
                        sourceDevice: keyboardSourceDevice
                        buttons: [Qt.Key_S]
                        scale: d.shiftPressed ? 0.0 : -1.0
                    }
                }
            ] // axes
        },
        FrameAction {
            property real timeSinceLastAction: 0.0
            onTriggered: {
                if(!root.enabled) {
                    return
                }
                if(leftMouseButtonAction.active) {
                    pressed()
                }

                var speed = moveSpeed * (shiftAction.active ? 5.0 : 1.0)
                root.camera.translate(Qt.vector3d(keyboardXAxis.value*speed, 0.0, keyboardYAxis.value*speed))

                if(!leftMouseButtonAction.active && !middleMouseButtonAction.active) {
                    timeSinceLastAction += dt
                    return
                }

                // The time difference since the last frame is passed in as the
                // argument dt. It is a floating point value in units of seconds.
                if (leftMouseButtonAction.active) {
                    if(timeSinceLastAction > 0.1) {
                        timeSinceLastAction = 0
                        return
                    }
                    root.camera.panAboutViewCenter(-mouseXAxis.value * lookSpeed, d.firstPersonUp);
                    root.camera.tiltAboutViewCenter(-mouseYAxis.value * lookSpeed);
                } else if(middleMouseButtonAction.active) {
                    if(timeSinceLastAction > 0.1) {
                        timeSinceLastAction = 0
                        return
                    }
                    var fov = root.camera.fieldOfView
                    fov += mouseYAxis.value * zoomSpeed
                    fov = Math.max(10.0, Math.min(160.0, fov))
                    root.camera.fieldOfView = fov
                }

//                var tanAngle = Math.tan(root.camera.fieldOfView / 2.0)
//                var distance = (root.camera.viewCenter.minus(root.camera.position)).length()
//                console.log("distance", distance, "sinAngle", tanAngle)
//                root.camera.right = distance * tanAngle
//                root.camera.left = -root.camera.right
//                root.camera.top = root.camera.right / root.camera.aspectRatio
//                root.camera.bottom = -root.camera.top
            }
        }
    ] // components
}