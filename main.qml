import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    visible: true
    width: 1250
    height: 700
    title: qsTr("Hello World")

    MouseArea
    {
        anchors.fill: parent

        onPressed:
        {
            console.log("Test")
        }
    }


        TimeLine
        {
            anchors.left: parent.left
            y:0
            id: test1
        }

        TimeLine
        {
            anchors.left: parent.left
            y:200
            id: test2
        }






}
