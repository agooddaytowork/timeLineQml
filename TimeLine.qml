import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4
import QtCharts 2.2


Item {

    id: timeLineItem
    property int timeLineWidth: 800
    property int timeLineHeight: 100
    property int duration: 4 * 60000
    property int currentDuration: 4 * 60000
    property int leftHandSideTimeStamp: 0

    property bool timeSLotSeclected: false
    property int currentSelectedTimeSlotIndex : 0
    signal timeLinePressed()
    signal timeLineReleased()



    function addTimeSlot(x1, x2)
    {
        // collision checking

        // than add shit

        //present Model is on pixel domain
        // timeline Model is on time domain (ms)

        presentModel.append({"position": x1, "theWidth": x2 - x1})
        timeLineModel.append({"timeStamp": leftHandSideTimeStamp + (x1 * currentDuration)/timeLineWidth, "duration": (x2 - x1) * currentDuration/timeLineWidth})
        console.log("time STamp position in Addtime Slot: "+ (leftHandSideTimeStamp + (x1 * currentDuration)/timeLineWidth))
        console.log("position in ADdtime Slot: " + x1)
    }



    function removeTimeSlot(index)
    {

        console.log("timeLineModel count before remove: " + timeLineModel.count)
        // remove from presentModel
        presentModel.remove(index)

        // remove from Timeline Model

        var timeLineIndex = 0;
        for ( var i = 0; i < timeLineModel.count; i++)
        {
            if(timeLineModel.get(i).timeStamp === (presentModel.get(index).position * currentDuration / timeLineWidth) )
            {
                timeLineIndex = i
            }
        }

        timeLineModel.remove(timeLineIndex)
        console.log("timeLineModel count after remove: " + timeLineModel.count)
    }

    function getTimelineModelLog()
    {
        // return a string ?, sounds nice!
    }

    function zoom( angleData)
    {
        console.log("Zoom()")
        var timeStampAtMouseX;
        if (angleData < 0)
        {
            console.log("angleData < 0 ")
            //                leftHandSideTimeStamp = leftHandSideTimeStamp + 200

            // get Timestamp at mouse X


            timeStampAtMouseX = leftHandSideTimeStamp + timeLineMouseArea.mouseX*currentDuration/timeLineWidth
            timeLineItem.currentDuration = timeLineItem.currentDuration - 2000
            leftHandSideTimeStamp = timeStampAtMouseX - (timeLineMouseArea.mouseX* currentDuration/timeLineWidth)
            console.log("timeStamp at Mouse X: " + timeStampAtMouseX)

        }
        else
        {
            console.log("angleData > 0 ")
            if(currentDuration < duration)
            {
                //                leftHandSideTimeStamp = leftHandSideTimeStamp - 200
                timeStampAtMouseX = leftHandSideTimeStamp + timeLineMouseArea.mouseX*currentDuration/timeLineWidth
                timeLineItem.currentDuration = timeLineItem.currentDuration + 2000

                leftHandSideTimeStamp = timeStampAtMouseX - (timeLineMouseArea.mouseX* currentDuration/timeLineWidth)
            }
            else
            {

                timeLineItem.currentDuration = timeLineItem.duration
                leftHandSideTimeStamp = 0
            }
        }
    }

    function isTimeSlotExistInPresentModel(timeStamp)
    {
        var timeStampPosition = (timeStamp)*timeLineWidth / currentDuration

        console.log("timeStamp Position: " + timeStampPosition)

        for (var i = 0; i < presentModel.count; i++)
        {
            if(presentModel.get(i).position === timeStampPosition)
            {
                console.log("true")
                return true
            }
        }
        console.log("false")
        return false
    }


    function slideTimeline(x1)
    {


        var newLeftHandSideTimeStamp = x1/timeLineWidth * duration



        presentModel.clear()


        for (var i = 0;i < timeLineModel.count; i++)
        {
            if(timeLineModel.get(i).timeStamp >= newLeftHandSideTimeStamp && timeLineModel.get(i).timeStamp <= newLeftHandSideTimeStamp + currentDuration)
            {
                // checkClipping on the right Side
                var position = ((timeLineModel.get(i).timeStamp - newLeftHandSideTimeStamp)*timeLineWidth/currentDuration)
                if(timeLineModel.get(i).timeStamp - newLeftHandSideTimeStamp + timeLineModel.get(i).duration > currentDuration)
                {
                    var theWidth = timeLineWidth - position

                }
                else
                {
                    theWidth = timeLineModel.get(i).duration * timeLineWidth/currentDuration
                }


                presentModel.append({"position": position , "theWidth": theWidth })
            }



        }






    }

    onLeftHandSideTimeStampChanged:
    {
        console.log("onCurrentDurationChanged")
        presentModel.clear()

        for (  var i = 0; i < timeLineModel.count; i++)
        {
            //            if(timeLineModel.get(i).timeStamp >= leftHandSideTimeStamp && (timeLineModel.get(i).timeStamp + timeLineModel.get(i).duration) <= leftHandSideTimeStamp + currentDuration )

            if(timeLineModel.get(i).timeStamp >= leftHandSideTimeStamp && timeLineModel.get(i).timeStamp  <= leftHandSideTimeStamp + currentDuration )

            {
                console.log("Dzo day di")

                 var position = ((timeLineModel.get(i).timeStamp - leftHandSideTimeStamp)*timeLineWidth/currentDuration)
                if(timeLineModel.get(i).timeStamp - leftHandSideTimeStamp + timeLineModel.get(i).duration > currentDuration)
                {
                    var theWidth = timeLineWidth - position

                }
                else
                {
                    theWidth = timeLineModel.get(i).duration * timeLineWidth/currentDuration
                }


                presentModel.append({"position": position , "theWidth": theWidth })
            }
        }



    }



    onDurationChanged:
    {
        //reset everything

        for (var i = 0; i < presentModel.count ; i++)
        {
            presentModel.remove(i)
        }
        for(i = 0; i < timeLineModel.count; i++)
        {
            timeLineModel.remove(i)
        }
    }



    ListModel {
        id: timeLineModel
    }

    ListModel
    {
        id: presentModel
    }





    Column{
        Rectangle
        {
            id: timeLineRec
            width: timeLineWidth
            height: timeLineHeight

            z:1
            color: "grey"

            ChartView
            {
                anchors.top: timeLineRec.top
                anchors.left: timeLineRec.left
                z:1
                width: timeLineWidth
                height: timeLineHeight * 0.5

            }

            Rectangle
            {
                id: markerRec
                width: 1
                height: timeLineRec.height
                color: "black"
                visible: false
                z:4

            }

            Rectangle{
                id: selectRect
                anchors.top: timeLineRec.top
                x:0
                width: 0
                height: timeLineRec.height
                color: "black"
                z:3
                opacity: 0.5
                property int initX
                property int initY

            }



            MouseArea
            {
                id: timeLineMouseArea
                anchors.fill: parent
                z:4
                hoverEnabled: false
                onPressed: {
                    timeLineItem.timeLinePressed()
                    timeLineRec.focus = false
                    console.log("onPressed")

                    timeSLotSeclected = false

                    // check if any item selected then select it!

                    for( var ii = 0; ii < presentModel.count; ii++)
                    {

                        if(mouseX >= presentModel.get(ii).position && mouseX <= (presentModel.get(ii).position + presentModel.get(ii).theWidth))
                        {
                            // selectTed
                            selectRect.x = 0
                            selectRect.width =0
                            selectRect.x = presentModel.get(ii).position
                            selectRect.width = presentModel.get(ii).theWidth

                            timeSLotSeclected = true
                            currentSelectedTimeSlotIndex = ii
                            return
                        }
                    }

                    if(!timeSLotSeclected)
                    {
                        selectRect.x = timeLineMouseArea.mouseX
                        selectRect.y = timeLineRec.y

                        selectRect.initX = timeLineMouseArea.mouseX
                        // selectRect.initY = timeLineMouseArea.mouseY

                        markerRec.visible = true
                        markerRec.x = timeLineMouseArea.mouseX
                    }


                }


                onPositionChanged:
                {


                    //                    console.log( "Position: x" + mouseX + "-y" + mouseY)
                    if(!timeSLotSeclected && timeLineMouseArea.pressed)
                    {
                        //-x,+y
                        if(mouseX - selectRect.initX < 0 && mouseY - selectRect.initY > 0)
                        {
                            selectRect.x = mouseX
                            //  selectRect.y = selectRect.initY

                        }
                        //-x,-y
                        else if(mouseX - selectRect.initX < 0 && mouseY - selectRect.initY < 0)
                        {
                            selectRect.x = mouseX
                            //selectRect.y = mouseY
                        }
                        //+x,-y
                        else if(mouseX - selectRect.initX > 0 && mouseY - selectRect.initY < 0)
                        {
                            selectRect.x = selectRect.initX
                            //  selectRect.y = mouseY
                        }
                        //+x,+y
                        else
                        {
                            //do nothing
                        }
                        selectRect.width = Math.abs(mouseX - selectRect.initX)
                        //                    selectRect.height = Math.abs(mouseY - selectRect.initY)

                    }


                }

                onReleased:
                {

                    timeLineItem.timeLineReleased()
                    timeLineRec.focus = true
                    if(!timeSLotSeclected)
                    {

                        markerRec.visible = false

                        var myX;
                        //-x,+y
                        if(mouseX - selectRect.initX < 0 )
                        {
                            myX = selectRect.x
                            //  selectRect.y = selectRect.initY

                        }
                        else
                        {
                            myX = selectRect.initX
                        }

                        selectRect.width = Math.abs(mouseX - selectRect.initX)
                        //                    selectRect.height = Math.abs(mouseY - selectRect.initY)
                        selectRect.height = timeLineRec.height

                        //                onKeyList.append({myWidth: selectRect.width, myHeight: selectRect.height, myX: myX - timeLineRec.x, myColor: "red"})
                    }


                }

                onWheel:
                {

                    zoom(wheel.angleDelta.y)

                }
            }

            Repeater
            {
                anchors.fill: parent
                model: presentModel

                Rectangle
                {
                    z:2
                    anchors.top: parent.top
                    color: "green"
                    x: position
                    width: theWidth
                    height: parent.height

                    Text {
                        id: onText
                        text: qsTr("ON")
                    }
                }
            }


            Keys.onReleased:
            {
                if(event.key == Qt.Key_Space)
                {
                    if(!timeSLotSeclected)
                    {
                        addTimeSlot(selectRect.x, selectRect.width + selectRect.x)
                    }


                }
                else if (event.key == Qt.Key_Delete)
                {
                    removeTimeSlot(currentSelectedTimeSlotIndex)
                    selectRect.width = 0
                    selectRect.x = 0
                }

            }

            MouseArea
            {
                anchors.fill: parent

            }
        }


        Slider
        {
            id: timeLineSlider
            width: timeLineWidth
            from : 0
            to: timeLineWidth
            background: Rectangle {
                x: timeLineSlider.leftPadding
                y: timeLineSlider.topPadding + timeLineSlider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: timeLineSlider.availableWidth
                height: implicitHeight
                radius: 2
                color: "#bdbebf"

                Rectangle {
                    width: timeLineSlider.visualPosition * parent.width
                    height: parent.height
                    color: "#21be2b"
                    radius: 2
                }
            }

            handle: Rectangle {
                id: handleRec
                x: timeLineSlider.leftPadding + timeLineSlider.visualPosition * (timeLineSlider.availableWidth - width)
                y: timeLineSlider.topPadding + timeLineSlider.availableHeight / 2 - height / 2
                width: currentDuration/duration * timeLineWidth
                implicitHeight: 26
                radius: 13
                color: timeLineSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                border.color: "#bdbebf"
            }

            Connections
            {
                target: timeLineItem
                onCurrentDurationChanged:
                {
                    timeLineSlider.value = (timeLineMouseArea.mouseX*currentDuration/timeLineWidth)/duration * timeLineWidth
                }
            }


            onValueChanged:
            {
                slideTimeline((handleRec.x) )


            }

        }
    }





}
