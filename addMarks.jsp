<!DOCTYPE Html>
<html>
<%
    String assesment = (String)session.getAttribute("assesment");
    String role = (String)session.getAttribute("role");
    if (role == null ){
        response.setStatus(response.SC_MOVED_TEMPORARILY);
        response.setHeader("Location", "index.html");
    }else if (assesment == null){
        response.setStatus(response.SC_MOVED_TEMPORARILY);
        response.setHeader("Location", "selectSubjectCode.html");
    }
%>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>OAS</title>
        <link rel="stylesheet" href="css/semantic.min.css"></link>
        <style>
        img{
            margin-bottom:-10px;
            margin-top:-10px;
        }
        </style>
    </head>
    <body>
        <div class="ui container">
            <div class="ui stackable olive top fixed huge labeld icon menu">
                <div class="ui text menu">
                    <div class="item">
                        <img class="ui small bordered spaced image" src="images/vec.jpg">
                    </div>
                    <a class="item"></a>
                    <div class="item">
                        <span style="font-size:20px;color:#29b6f6;">Marks</span>

                    </div>
                    <a class="item" style="margin-left:850px;"></a>
                    <div class="ui right item">
                        <div class="menu">
                            <a class="item">
                              <i class="large red inverted sign out icon"></i><span style="font-size:20px;">SignOut</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <!-- nav bar ends-->
            <div class="margin"></div>
            <h3>Click the Button to add Marks</h3>
                <button class="ui blue button" id="head" onclick="addNewCo()">Add Marks</button>


            <table id="tableCo" class="ui collapsing table">

            </table>
            <button class="ui green button" onclick="submit()">Submit</button>

        </div>
        <script src="js/jquery-3.1.1.min.js"></script>
        <!--jquery should be loaded before sematic and your custom javascript -->
        <script src="js/semantic.min.js"></script>
        <script>
            var height = $("body").innerHeight();
            var hgt = height*0.15;

            $('.margin').height(hgt);
        </script>

        <script>
            $(".form").submit(function(e){
                e.preventDefault();
            });
            coCount = 0;
                h=`<thead>
                <tr>
                    <th>Course Outcome</th>
                    <th>Description</th>
                    <th>Threshold</th>
                    <th>Target</th>
                 </tr>
                </thead>`

            $( "#head" ).one( "click", function() {
                $("#tableCo").append(h);
            });
            function addNewCo(){
                s = `<tr>
                    <td><div class="ui input"><input placeholder="coNo" id="cono`+coCount+`" value="co`+(coCount+1)+`"></div></td>
                    <td><div class="ui input"><input placeholder="description" id="coDesc`+coCount+`"></div></td>
                    <td><div class="ui input"><input type="text" placeholder="threshold" id="coThreshold`+coCount+`"></div></td>
                    <td><div class="ui input"><input type="text" placeholder="target" id="coTarget`+coCount+`"></div></td>
                </tr>`
                coCount++;
                $("#tableCo").append(s);
            }
            function submit(){
                //alert("s");
                arr = [];
                console.log("clicked");
                for (i = 0; i< coCount; i++){
                    obj = {};
                    obj.cono = $("#cono"+i).val();
                    obj.description = $("#coDesc"+i).val();
                    obj.threshold = Number($("#coThreshold"+i).val());
                    obj.target = Number($("#coTarget"+i).val());
                    arr.push(obj);
                }
                subjectCode = "dummy" //TODO:change it
                data = {};
                data.subjectCode = subjectCode;
                data.coDetails = arr;
                var jsonData = JSON.stringify(data);
                console.log(jsonData);
                $.get("/OAS/coDetails",{data:jsonData},function(result){
                    console.log("result :"+result);
                });
            }
            //TODO: Testing
        </script>
    </body>
</html>
