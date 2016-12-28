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
         <link rel="stylesheet" media="screen" href="dist/handsontable.full.css">
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
            <div class="ui form">
                <div class="fields">
                    <div class="field">
                        <input placeholder="Subject Code" id="subjectCode"></input>
                    </div>
                    <div class="field">
                        <button class="ui blue button" onclick="getData()">Set</button>
                    </div>
                </div>
            </div>
            <div>
                <div id="excel"></div>
            </div>
            <div>
                <br>
                <table class="ui celled table" id="dispResult"></table>
            </div>
            <div>
                <br>
                <button class="ui green button" onclick="save()">Save</button>

            </div>
        </div>
        <script src="js/jquery-3.1.1.min.js"></script>
        <!--jquery should be loaded before sematic and your custom javascript -->
        <script src="js/semantic.min.js"></script>
        <script src="dist/handsontable.full.js"></script>
        <script>
            var height = $("body").innerHeight();
            var hgt = height*0.15;

            $('.margin').height(hgt);
        </script>

        <script>
            $(".form").submit(function(e){
                e.preventDefault();
            });
            var columnHeaders = []


            var container = document.getElementById('excel');
            var hot;

            var questions;
            var students;
            var dataExcel = [];
            var dataCO;
            questions = [{"qno":"1","co":"co2","mark":16},{"qno":"2","co":"co1","mark":16},{"qno":"3","co":"co2","mark":16},{"qno":"4","co":"co2","mark":10},{"qno":"5","co":"co2","mark":12}]
            columnHeaders = [];
            students = [];
            function getData(){
                $.get("getQuesAndStud", {subjectCode:$("#subjectCode").val()}, function(result){
                    if (result.message == "done"){
                        questions = result.questions.questions;
                        students = result.students;
                        console.log(result);
                        //console.log(questions);
                        columnHeaders = [];
                        for (i in questions){
                            columnHeaders.push(questions[i].qno+" ("+questions[i].mark+")");
                        }
                        //console.log(columnHeaders);
                        $.get("getMarks",{subjectCode:$("#subjectCode").val()}, function(result){
                            if (result.message == "done"){
                                dataExcel = result.excel.data;
                                dataCO = result.co;
                            }
                            loadExcel();
                        });
                    }else{
                        alert("unable to retrive data");
                        console.log(result.message);
                    }

                });
            }

            function loadExcel(){
                var cols = [];
                for (i in columnHeaders){
                    obj = {};
                    obj.type = "numeric";
                    cols.push(obj);
                }

                hot = new Handsontable(container, {
                  data: dataExcel,
                  minSpareRows:students.length ,
                  maxRows:students.length,
                  rowHeaders: true,
        		  autoWrapRow: true,
        		  stretchH: "all",
                  columns:cols,
                  colHeaders: columnHeaders,
                  rowHeaders: students
                });
            }
            var test;
            max = {};
            function save(){
                data = hot.getData();
                obj = {};
                obj.data = data;
                jsonData = JSON.stringify(obj);
                console.log(jsonData);
                var objCo = {};

                max = {};
                for (j in questions ){
                    if( typeof max[questions[j].co] == "undefined"){
                        max[questions[j].co] = 0;
                    }
                    max[questions[j].co] = max[questions[j].co] + questions[j].mark;
                }
                objCo.maxMarks = max;
                objCo.co = calculate();
                jsonData1 = JSON.stringify(objCo);

                $.get("saveMarks",{excelData:jsonData,coData:jsonData1, subjectCode:$("#subjectCode").val()}, function(result){
                    alert(result.message);
                    console.log(result.error);
                });
            }
            function calculate(){
                data = hot.getData();
                arr = [];

                for ( i in data ){ //each row
                    obj = {};
                    if (typeof students[i] == "undefined")
                        continue;
                    obj.sid = students[i];
                    co = {};
                    for (j in data[i]){ //each cell
                        if( typeof co[questions[j].co] == "undefined"){
                            co[questions[j].co] = 0;
                        }
                        co[questions[j].co] = co[questions[j].co] + Number(data[i][j]);
                    }
                    obj.co = co;
                    arr.push(obj);
                }
                test = arr;
                //console.log(arr);
                //alert(arr); //TODO: display arr
                displayTable(arr);
                return arr;
            }
            function displayTable(data){
                s = "";
                f = true;
                h = "<thead><tr><td></td>";
                for ( i in data){
                    s = s + '<tr><th>'+data[i].sid+'</th>';
                    //console.log(data[i].co);
                    cos = data[i].co;
                    for (j in cos){
                        //console.log(j);
                        if (f)
                            h = h + "<td>"+ j + "</td>";
                        p = +( ( (cos[j]/max[j]) * 100).toFixed(2));
                        c = "";
                        if (p > 100)
                            c = "error";
                        s = s + '<td class="'+c+'">'+ p +'</td>'
                    }
                    f = false;
                    s = s + "</tr>"
                }
                h = h + "</tr></thead>";
                $("#dispResult").html(h+s);
            }
        </script>
    </body>
</html>
