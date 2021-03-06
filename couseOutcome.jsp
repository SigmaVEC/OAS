<!DOCTYPE Html>
<html>
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
        body{
            padding:20px;
        }
        </style>
    </head>
    <body>
            <div>course : <%
            String course = (String)session.getAttribute("course");
            if (course == null ){
                response.setStatus(response.SC_MOVED_TEMPORARILY);
                response.setHeader("Location", "errorSetCourse.jsp?url=courseOutcone.jsp");
            }else{
                out.print("<span id=\"courseCode\">"+course+"</span>");
            }
            %></div>
            <!-- nav bar ends-->
        <div id="new">
            <h3>Click the Button to add New Course OutCome(to be changed)</h3>
            <div class="ui form">
                <div class="fields">
                    <div class="field">
                        <button class="ui blue button" id ="head" onclick="addNewCo();">Add New</button>
                    </div>
                </div>
            </div>
            <table id="tableCo" class="ui collapsing table">

            </table>
                <button class="ui green button" onclick="submit()">submit</button>

        </div>
        <div id="coList">
        </div>
        <script src="js/jquery-3.1.1.min.js"></script>
        <!--jquery should be loaded before sematic and your custom javascript -->
        <script src="js/semantic.min.js"></script>
        <script>

            var height = $("body").innerHeight();
            var hgt = height*0.20;

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

            /*function setCO(){
                $.get("listCoForClass",{},function(result){
                    if(result.message == "done"){
                        data = result.co;
                        s = "";
                        if (data.length > 0){
                            for ( i in data){
                                co1 = data[i].co;
                                scode = data[i].subjectCode;
                                console.log(data[i]);
                                s = `<table class="ui table">
                                        <thead class="full-width">
                                        <tr><th colspan="4">`+scode+`</th></tr>
                                        </thead>`
                                for (i in co1){
                                    des = co1[i].description;
                                    cno = co1[i].co;
                                    thr = co1[i].threshold;
                                    tar = co1[i].target;
                                    s = s +`<tr> <td>`+cno+`</td><td>`+des+`</td><td>`+thr+`</td><td>`+tar+`</td></tr>`;
                                }
                                s = s + "</table>"
                                $("#coList").append(s);
                            }
                        }
                    }else{
                        console.log(result.error);
                    }
                });
            }*/

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
            for( i = 0 ; i < 6 ; i++){
                addNewCo();
            }
            $.get("listCoForCourse",{},function(result){
                if(result.message == "done"){
                    co1 = result.co;
                    s = `<table class="ui table">
                            <thead class="full-width">
                            <tr><th colspan="4">`+$("#courseCode").html()+`</th></tr>
                            </thead>`
                    for (i in co1){
                        des = co1[i].description;
                        cno = co1[i].co;
                        thr = co1[i].threshold;
                        tar = co1[i].target;
                        s = s +`<tr> <td>`+cno+`</td><td>`+des+`</td><td>`+thr+`</td><td>`+tar+`</td></tr>`;
                    }
                    s = s + "</table>";
                    $("#coList").html(s);
                    $("#new").hide();
                }
            });
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
                subjectCode = $("#subjectCode").val(); //TODO:change it
                data = {};
                data.subjectCode = subjectCode;
                data.coDetails = arr;
                var jsonData = JSON.stringify(data);
                console.log(jsonData);
                $.get("/OAS/coDetails",{data:jsonData},function(result){
                    console.log("result :"+result);
                    alert(result.message);
                });
            }
            //TODO: Testing


        </script>
    </body>
</html>
