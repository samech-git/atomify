import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import Atomify 1.0
import Qt.labs.settings 1.0

Item {
    id: lammpsEditorRoot
    property AtomifySimulator simulator
    property alias codeEditorWindow: codeEditorWindow

    onSimulatorChanged: {
        simulator.willResetChanged.connect(function() {
            codeEditorWindow.clear()
        })
    }

    function runScript() {
        if(!simulator.scriptHandler) {
            return
        }
        simulator.willReset = true
        simulator.scriptHandler.reset()
        simulator.scriptHandler.setWorkingDirectory(codeEditorWindow.currentEditor.fileUrl)
        simulator.scriptHandler.runScript(codeEditorWindow.currentEditor.text)
    }

    ColumnLayout {
        spacing: 2
        anchors.fill: parent

        CodeEditorWindow {
            id: codeEditorWindow
            currentLine: simulator.scriptHandler.currentLine
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
        }

        RowLayout {
            spacing: 2
            Layout.alignment: Qt.AlignBottom

            Button {
                id: runButton
                Layout.alignment: Qt.AlignCenter
                text: "Run"
                onClicked: {
                    runScript()
                }
            }

            Label {
                text: "(Press escape to escape editor focus)"
            }
        }
    }
}
