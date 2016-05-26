import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import Atomify 1.0
import SimVis 1.0
import Qt.labs.settings 1.0

import "../visualization"

Item {
    id: desktopRoot

    property alias simulator: visualizer.simulator
    property alias visualizer: visualizer
    property var lastEditorWidth: 500
    property bool focusMode: false

    Component.onCompleted: {
        simulator.errorInLammpsScript.connect(editorTab.reportError)
    }

    Row {
        anchors.fill: parent

        SplitView {
            height: parent.height
            width: parent.width-simulationSummary.width
            Layout.alignment: Qt.AlignTop
            orientation: Qt.Horizontal

            AtomifyTabView {
                id: tabView
                Layout.fillHeight: true
                simulator: simulator
                width: 500
                onWidthChanged: {
                    if(width != 0) {
                        lastEditorWidth = width
                    }
                }
            }

            AtomifyVisualizer {
                id: visualizer
                focus: true
                Layout.alignment: Qt.AlignLeft
                Layout.fillHeight: true
                Layout.minimumWidth: 1
            }
        }

        SimulationSummary {
            id: simulationSummary
            width: 300
            height: parent.height
            system: simulator.system ? simulator.system : null
        }
    }

    function toggleFocusMode() {
        if(focusMode) {
            simulationSummary.width = 300
            tabView.visible = true
            focusMode = false
        } else {
            simulationSummary.width = 0
            tabView.visible = false
            focusMode = true
        }
    }

    Item {
        id: shortcutes
        Shortcut {
            // Random placement here because it could not find the editor otherwise (Qt bug?)
            sequence: "Ctrl+R"
            onActivated: editorTab.runScript()
        }
        Shortcut {
            sequence: "Ctrl+1"
            onActivated: tabView.currentIndex = 0
        }
        Shortcut {
            sequence: "Ctrl+2"
            onActivated: tabView.currentIndex = 1
        }
        Shortcut {
            sequence: "x"
            onActivated: toggleFocusMode()
        }
        Shortcut {
            sequence: "1"
            onActivated: {
                var isVisible = simulator.atomStyle.isVisible(0)
                simulator.atomStyle.setModelData(0, "visible", !isVisible)
            }
        }
        Shortcut {
            sequence: "2"
            onActivated: {
                var isVisible = simulator.atomStyle.isVisible(1)
                simulator.atomStyle.setModelData(1, "visible", !isVisible)
            }
        }
        Shortcut {
            sequence: "3"
            onActivated: {
                var isVisible = simulator.atomStyle.isVisible(2)
                simulator.atomStyle.setModelData(2, "visible", !isVisible)
            }
        }
    }
}
