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


    Flickable{

        id: giveItanId
        anchors.fill: parent
        contentWidth: 800
        contentHeight: 2000
        pressDelay: 0
        interactive: true

        TimeLine
        {
            z:2
            y: 0
            id: test1

            onTimeLinePressed:
            {
                console.log("onTimelinePress")
                giveItanId.interactive = false
            }

            onTimeLineReleased:
            {
                giveItanId.interactive = true
            }

        }

        TimeLine
        {
            z:2
            y: 300
            id: test2
            onTimeLinePressed:
            {
                console.log("onTimelinePress")
                giveItanId.interactive = false
            }

            onTimeLineReleased:
            {
                giveItanId.interactive = true
            }
        }

    }






}
