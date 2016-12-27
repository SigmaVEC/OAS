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
        <title>Course</title>
        <link rel="stylesheet" href="css/semantic.min.css"></link>
        <style>

        </style>
    </head>
    <body>
        <div class="ui container">
            <div class="ui stackable grey inverted top fixed huge labeld icon menu">
                <div class="item">Questions</div>
                <div class="right icon menu">
                    <a class="item">
                        <i class="large red inverted sign out icon"></i>SignOut
                    </a>
                </div>
            </div>
            <div class="margin"></div>
            <h3>Set Questions</h3>

            <!-- nav bar ends-->
            <div class="ui form">
                <div class="fields">
                    <div class="field">
                        <button class="ui blue button" id="head" onclick="addNewQues()">Add New Question</button>
                    </div>
                    <div class="field">
                        <input id="subjectCode" placeholder="Enter subject code"></input>
                    </div>
                </div>
            </div>
            <table class="ui collapsing table" id="tableQues">

            </table>
            <button class="ui green button" onclick="submit()">submit</button>
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
            h=`<thead>
            <tr>
                <th>Question No</th>
                <th>Course Outcome No</th>
                <th>Marks</th>

             </tr>
            </thead>`

                $( "#head" ).one( "click", function() {
                    $("#tableQues").append(h);
                });
            qCount = 0;
            cooptionsarr = ['co1','co2']
            function getCoOptions(){
                s = '';
                for ( i in cooptionsarr){
                    s = s + '<option value="'+cooptionsarr[i]+'">'+cooptionsarr[i]+'</option>';
                }
                return s;
            }
            function addNewQues(){
                s = `<tr>
                    <td><div class="ui input"><input placeholder="qNo" id="qno`+qCount+`" value="q`+(qCount+1)+`"></div></td>
                    <td>
                        <select id="qCo`+qCount+`" class="coListing">
                            `+getCoOptions()+`
                        </select>
                    </td>
                    <td><div class="ui input"><input type="text" placeholder="Maximum Marks" id="qMark`+qCount+`"></div></td>
                </tr>`
                qCount++;
                $("#tableQues").append(s);
            }
            function submit(){
                //alert("s");
                arr = [];
                console.log("clicked");
                for (i = 0; i< qCount; i++){
                    obj = {};
                    obj.qno = $("#qno"+i).val();
                    obj.co = $("#qCo"+i).val();//todo:change
                    obj.mark = Number($("#qMark"+i).val());
                    arr.push(obj);
                }
                subjectCode = $("#subjectCode").val();
                /*assesment = "dummyass";
                section = "dummysec";
                department = "dummyDept"
                year = "dummyYr";
                */
                data = {};
                data.subjectCode = subjectCode;
                /*data.assesment = assesment;
                data.section = section;
                data.department = department;
                data.year = year;*/
                data.questions = arr;
                var jsonData = JSON.stringify(data);
                console.log(jsonData);
                $.get("/OAS/setQuestions",{data:jsonData},function(result){
                    console.log("result  error:"+result.error);
                    alert(result.message);
                });
            }
            //TODO: Testing
        </script>
    </body>
</html>