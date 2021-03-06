<!DOCTYPE Html>
<html>
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
        <div id="new">
            <div>
                <div id="excel"></div>
            </div>
            <div><br>
                <center>
                    <button class="ui blue button" onclick="addStudents()">Upload</button>
                </center>
            </div>
        </div>
        <div id="current">
            <table class="ui green table">
                <thead>
                    <tr>
                        <th>Registration number</th>
                        <th>Name</th>
                    </tr>
                </thead>
                <tbody id="currentTableBody">
                </tbody>
            </table>
            <%
                String role = (String)session.getAttribute("role");
                if (role.equalsIgnoreCase("admin")){
                    out.print("<center><button class=\"ui blue button\" onclick=\"hideNew(false)\">Add New</button></center>");
                }
            %>

        </div>
        <script src="js/jquery-3.1.1.min.js"></script>
        <!--jquery should be loaded before sematic and your custom javascript -->
        <script src="js/semantic.min.js"></script>
        <script src="dist/handsontable.full.js"></script>
        <script>
            var height = $("body").innerHeight();
            var hgt = height*0.25;

            $('.margin').height(hgt);
        </script>
        <script>
            $(".form").submit(function(e){
                e.preventDefault();
            });
            var columnHeaders = ["student id", "name"]
            var data = [{
                sid:"",
                name:""
            }];
            function hideNew(a){
                if(a == true){
                    $("#new").hide();
                    $("#current").show();
                }else{
                    $("#new").show();
                    $("#current").hide();
                }
            }
            $.get("getStudentExcel",{},function(result){
                console.log(result);
                if(result.message == "done"){
                    console.log(result.students.length )
                    if (result.students.length > 0){
                        data1 = result.students;
                        s = "";
                        for (i in data1){
                            s = s + `
                                <tr>
                                    <td>`+ data1[i].sid +`</td>
                                    <td>`+ data1[i].name +`</td>
                                </tr>
                            `;
                        }
                        $("#currentTableBody").html(s);
                        hideNew(true);
                    }else{
                        hideNew(false);
                        //disp new
                    }
                }
                excelDisp();
            });
            var container = document.getElementById('excel');
            var hot ;
            function excelDisp(){
                hot = new Handsontable(container, {
                  data: data,
                  minSpareRows: 1,
                  rowHeaders: true,
        		  autoWrapRow: true,
        		  stretchH: "all",
                  colHeaders: columnHeaders,

                });
            }
            function addStudents(){
                obj = {};

                //obj.section = "dummyS";
                //obj.department = "demmyD";
                //obj.year = "dummyY"; //TODO:Change this
                obj.data = hot.getSourceData();
                if (obj.data.slice(-1)[0].sid == null)
                    obj.data.pop();
                jsonData = JSON.stringify(obj);
                //console.log(jsonData);

                $.get("addStudents",{"data":jsonData},function(result){
                    console.log(result);
                    alert(result.message);
                });
            }
        </script>
    </body>
</html>
