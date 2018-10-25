<%--
  Created by IntelliJ IDEA.
  User: yyf
  Date: 2018/10/25
  Time: 下午2:57
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8" />
    <title>websocket chat</title>
</head>

<body>

<div>
    <label>输入信息：</label><input id="id" width="100px" /><br />
    <button id="btn">发送消息</button>    
    <button id="connection">websocket连接</button>     
    <button id="disconnection">断开websocket连接</button>
    <br /><br />
    <form enctype="multipart/form-data" id="uploadForm">
        <input type="file" name="uploadFile" id="upload_file" style="margin-bottom:10px;">
        <input type="button" id="uploadPicButton" value="上传" onclick="uploadImage()">
    </form>
    <!--<input type="file" onchange="uploadImgTest();" id="uploadImg" name="uploadImg" />
    <button id="uploadImage" onclick="uploadImage();">上传</button>-->
</div>


<div id="test">

</div>

<hr color="blanchedalmond"/>
<div id="voiceDiv">

</div>

<hr color="chartreuse" />
<div id="imgDiv" style="width: 30%;height: 30%;">
    <img src="http://192.168.9.123:8860/v1/uploadDownload/downloadImage?imageName=123.JPG" style="width: 160px;height: 160px;"/>
</div>

</body>

<script src="js/jquery-3.2.1.min.js"></script>
<!--<script th:src="@{stomp.min.js}"></script>-->
<script src="js/sockjs.min.js"></script>

<script>
    var websocketUrl = "ws://192.168.9.123:8860/webSocketServer";
    var websocket;
    if('WebSocket' in window) {
        //websocket = new WebSocket("ws://" + document.location.host + "/webSocketServer");
        //websocket = new WebSocket("ws://192.168.9.123:9092/webSocketServer");
        //websocket = new WebSocket("ws://localhost:8860/webSocketServer");
        websocket = new WebSocket(websocketUrl);
    } else if('MozWebSocket' in window) {
        websocket = new MozWebSocket("ws://" + document.location.host + "/webSocketServer");
    } else {
        websocket = new SockJS("http://" + document.location.host + "/sockjs/webSocketServer");
    }
    websocket.onopen = function(evnt) {
        console.log("onopen----", evnt.data);
    };
    websocket.onmessage = function(evnt) {
        //$("#test").html("(<font color='red'>" + evnt.data + "</font>)");
        console.log("onmessage----", evnt.data);
        //$("#test").html(evnt.data);
        $("#test").append('<div>' + event.data + '</div>');
    };
    websocket.onerror = function(evnt) {
        console.log("onerror----", evnt.data);
    }
    websocket.onclose = function(evnt) {
        console.log("onclose----", evnt.data);
    }
    $('#btn').on('click', function() {
        if(websocket.readyState == websocket.OPEN) {
            var msg = $('#id').val();
            //调用后台handleTextMessage方法
            websocket.send(msg);
        } else {
            alert("连接失败!");
        }
    });
    $('#disconnection').on('click', function() {
        if(websocket.readyState == websocket.OPEN) {
            websocket.close();
            //websocket.onclose();
            console.log("关闭websocket连接成功");
        }
    });
    $('#connection').on('click', function() {
        if(websocket.readyState == websocket.CLOSED) {
            websocket.open();
            //websocket.onclose();
            console.log("打开websocket连接成功");
        }
    });
    //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
    window.onbeforeunload = function() {
        websocket.close();
    }

    function uploadImgTest() {


    }

    function uploadImage(){
        //var uploadUrl = "http://localhost:8860/v1/uploadDownload/uploadImage";
        var uploadUrl = "http://192.168.9.123:8860/v1/uploadDownload/uploadImage";
        var downUrl = "http://192.168.9.123:8860/v1/uploadDownload/downloadImage"
        var pic = $('#upload_file')[0].files[0];
        var fd = new FormData();
        //fd.append('uploadFile', pic);
        fd.append('file', pic);
        $.ajax({
            url:uploadUrl,
            type:"post",
            // Form数据
            data: fd,
            cache: false,
            contentType: false,
            processData: false,
            success:function(data){
                console.log("the data is : {}",data);
                if(data.code == 0){
                    console.log("上传成功后的文件路径为："+data.data);
                    var img = $("<img />")
                    img.attr("src",downUrl+"?imageName="+data.data);
                    img.width("160px");
                    img.height("160px");
                    $("#imgDiv").append(img);
                }

            }
        });

    }

</script>

</html>

