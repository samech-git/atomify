import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import Atomify 1.0

ColumnLayout {
    id: consoleRoot
    property AtomifySimulator simulator
    property TextArea output: consoleOutput
    property alias textField: singleCommand

    Layout.fillHeight: true
    Layout.fillWidth: true
    TextArea {
        id: consoleOutput
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.minimumHeight: 100
        textFormat: TextEdit.RichText
        readOnly: true
    }

    RowLayout {
        Layout.fillWidth: true

        TextField {
            property int previousCommandCounter: 0
            id: singleCommand
            // width: parent.width - runSingleCommand.width
            Layout.fillWidth: true

            Keys.onPressed: {
                if(singleCommand.text == "") {
                    simulator.scriptHandler.lastSingleCommandString();
                }
            }

            Shortcut {
                sequence: "Return"
                onActivated: {
                    if(singleCommand.text != "") {
                        simulator.scriptHandler.runCommand(singleCommand.text, true)
                        consoleOutput.append(singleCommand.text)
                        singleCommand.text = ""
                    }
                }
            }
            Shortcut {
                sequence: "Up"
                enabled: singleCommand.activeFocus
                onActivated: {
                    if(singleCommand.text == "") {
                        singleCommand.text = simulator.scriptHandler.lastSingleCommandString();
                    } else {
                        singleCommand.text = simulator.scriptHandler.previousSingleCommandString();
                    }
                }
            }
            Shortcut {
                sequence: "Down"
                enabled: singleCommand.activeFocus
                onActivated: {
                    singleCommand.text = simulator.scriptHandler.nextSingleCommandString();
                }
            }
        }

        Button {
            id: runSingleCommand
            text: "Run"
            onClicked: {
                simulator.scriptHandler.runCommand(singleCommand.text, true)
                consoleOutput.append(singleCommand.text)
                singleCommand.text = ""
            }
        }
        Button {
            id: clear
            text: "Clear"
            onClicked: {
                consoleOutput.text = ""
            }
        }
    }
}
