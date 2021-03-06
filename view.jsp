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
        body{
            padding:20px;
        }
        </style>
    </head>
    <body>

            <div>
                <table class="ui celled blue table" id="dispResult"></table>
            </div>
            <br>
            <hr>
            <br>
            <div>
                <table class="ui celled blue table" id="dispResultTarget"></table>
            </div>
            <br>
            <!--div>
                <br>
                <input placeholder="Subject Code" id="subjectCode"></input>
                <button class="ui green button" onclick="getData()">submit</button>

            </div-->

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

            var questions;
            var students;
            var dataExcel = [];
            var numberOfStudents;
            var dataCO;
            questions = [{"qno":"1","co":"co2","mark":16},{"qno":"2","co":"co1","mark":16},{"qno":"3","co":"co2","mark":16},{"qno":"4","co":"co2","mark":10},{"qno":"5","co":"co2","mark":12}]
            columnHeaders = [];
            students = [];
            var CO = {};
            var max = {};
            getData();
            function getData(){
                $.get("getQuesAndStud", {subjectCode:"<% out.print((String)session.getAttribute("course")); %>"}, function(result){
                    if (result.message == "done"){
                        questions = result.questions.questions;
                        students = result.students;
                        numberOfStudents = students.length;
                        console.log(result);
                        //console.log(questions);
                        columnHeaders = [];
                        for (i in questions){
                            columnHeaders.push(questions[i].qno+" ("+questions[i].mark+")");
                        }
                        //console.log(columnHeaders);
                        $.get("getMarks",{subjectCode:"<% out.print((String)session.getAttribute("course")); %>"}, function(result){
                            if (result.message == "done"){
                                dataExcel = result.excel.data;
                                dataCO = result.co;
                                max = result.co.maxMarks;
                                //loadExcel();

                                $.get("getCoDetails", {subjectCode:"<% out.print((String)session.getAttribute("course")); %>"} , function(result){
                                    console.log(result);
                                    if (result.co.length > 0 ){
                                        for (i in result.co){
                                            CO[result.co[i].co] = result.co[i];
                                            console.log(result.co[i].co);
                                        }
                                        calculate();
                                    } else {
                                        alert("CO not received");
                                    }
                                });
                            }else{
                                console.log(result.error);
                                alert("cannot retrive marks")
                            }
                        });
                    }else{
                        console.log(result.error);
                        alert("cannot students and marks details")
                    }
                });
            }


            function calculate(){
                data = dataExcel;
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
                coTarget = {};
                for ( i in data){
                    s = s + '<tr><th>'+data[i].sid+'</th>';
                    //console.log(data[i].co);
                    cos = data[i].co;
                    for (j in cos){
                        //console.log(j);
                        if (f){
                            h = h + "<td>"+ j + "</td>";
                            coTarget[j] = 0; //init to 0
                        }
                        c = "";
                        e = "";
                        p =  (cos[j]/max[j]) * 100;

                        if ( CO[j].threshold > p){
                            c = "error";
                        } else if (p > 100){
                            c = "warning";
                            e = '<i class="attention icon"></i>';
                        }else {
                            coTarget[j]++;
                        }
                        s = s + '<td class="'+c+'">'+ e + p.toFixed(2) +'</td>'
                    }
                    f = false;
                    s = s + "</tr>"
                }
                console.log(coTarget);
                l = "<tr> <td>Students</td> <td>"+ numberOfStudents +"</td> </tr>";
                for ( i in CO){
                    p = coTarget[CO[i].co]/numberOfStudents *100;
                    c = "";
                    if (p <CO[i].target){
                        console.log(p);
                        c = "error";
                    }
                    l = l + '<tr> <td>'+CO[i].co+'</td> <td class="'+c+'">' + p.toFixed(2) +'</td></tr>'
                    $("#dispResultTarget").html(l);
                }

                h = h + "</tr></thead>";
                $("#dispResult").html(h+s);
            }
        </script>
    </body>
</html>
