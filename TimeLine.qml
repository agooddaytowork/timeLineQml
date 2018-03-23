import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2


Item {

    property int timeLineWidth: 800
    property int timeLineHeight: 100
    property int duration: 10000
    property int currentDuration: 10000
    property int leftHandSideTimeStamp: 0

    property bool timeSLotSeclected: false
    property int currentSelectedTimeSlotIndex : 0



    function addTimeSlot(x1, x2)
    {
        // collision checking

        // than add shit

        //present Model is on pixel domain
        // timeline Model is on time domain (ms)

        presentModel.append({"position": x1, "theWidth": x2 - x1})
        timeLineModel.append({"timeStamp": leftHandSideTimeStamp + (x1 * currentDuration)/timeLineWidth, "duration": (x2 - x1) * duration/timeLineWidth})

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

    function zoom(angleData)
    {
        if (angleData < 0)
        {

        }
        else
        {

        }
    }

    onLeftHandSideTimeStampChanged:
    {
        for (i = 0; i < presentModel.count; i++ )
        {
            presentModel.remove(i)
        }

        for (i = 0; i < timeLineModel.count; i++)
        {
            if(timeLineModel.get(i).timeStamp >= leftHandSideTimeStamp && timeLineModel.get(i).timeStamp <= leftHandSideTimeStamp + currentDuration)

            {
                presentModel.append({"position": timeLineModel.get(i).timeStamp - leftHandSideTimeStamp, "theWidth": timeLineWidth*timeLineModel.get(i).duration / currentDuration} )
            }
        }

    }

    onDurationChanged:
    {
        //reset everything

        for (i = 0; i < presentModel.count ; i++)
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





        Rectangle
        {
            id: timeLineRec
             width: timeLineWidth
            height: timeLineHeight

            z:1
            color: "grey"

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
                onPressed: {
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

                    if(!timeSLotSeclected)
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

                    if( wheel.modifiers & Qt.ControlModifier)
                    {
                        console.log(wheel.angleDelta)
                        console.log(wheel.pixelDelta)
                        console.log(wheel.x)
                        console.log(wheel.y)
                    }
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





}
