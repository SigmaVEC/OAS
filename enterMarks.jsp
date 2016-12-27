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

        </style>
    </head>
    <body>
        <div class="ui container">
            <div class="ui stackable grey inverted top fixed huge labeld icon menu">
                <div class="item">Marks</div>
                <div class="right icon menu">
                    <a class="item">
                        <i class="large red inverted sign out icon"></i>SignOut
                    </a>
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
                        dataExcel = result.excel.data;
                        dataCO = result.co;
                        loadExcel();
                    });

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
            function save(){
                data = hot.getData();
                obj = {};
                obj.data = data;
                jsonData = JSON.stringify(obj);
                console.log(jsonData);
                var objCo = {};
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
                console.log(arr);
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
                        console.log(j);
                        if (f)
                            h = h + "<td>"+ j + "</td>";
                        s = s + '<td>'+ cos[j] +'</td>'
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