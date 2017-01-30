<!DOCTYPE Html><%@ page import="org.json.simple.*, org.json.simple.parser.*, org.json.simple.parser.*,java.util.Iterator"%>
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
#sideMenu{
    margin-left: 14px;
}
#sidePlane{
    background-color: #E0E0E0  ;
    height: 100%;
}
#test{
    position: absolute;
    width: 100%;
    height: 100%;
}
#frameBody{
    width: 100%;
    height: 100%;
    border: #E0E0E0 3px solid;
}
</style>
</head>
<body>
<div class="ui container">
  <div class="ui stackable olive top fixed massive labeld icon menu"  id="nav">
      <div class="ui text menu">
          <div class="item">
              <img class="ui small bordered spaced image" src="images/vec.jpg">
          </div>
          <div class="item" style="font-size:30px;color:#29b6f6;margin-left:300px;">Outcome Analysis Software</div>
          <a class="item"></a>
          <a class="item" style="margin-left:350px;"></a>
          <div class="ui right item">
              <div class="menu">
                  <a class="item">
                    <span style="font-size:20px;">Faculty</span><i class="large blue  user icon"></i>
                  </a>
              </div>
          </div>
      </div>

  </div>
</div>

<!-- nav bar-->

<div id="test"></div>

<div class="margin"></div>


    <div class="ui grid">
      <div class="three wide column" id="sidePlane">

        <div class="ui vertical menu" id="sideMenu">
          <a class=" item" onclick="itemClick(this)" link="couseOutcome.jsp">Course Outcome</a>
          <a class=" item" onclick="itemClick(this)" link="setQuestions.jsp">Set Questions</a>
          <a class=" item" onclick="itemClick(this)" link="enterMarks.jsp">Enter Marks</a>
          <a class=" item" onclick="itemClick(this)" link="view.jsp">Results</a>

        </div>
      </div>
      <div class="thirteen wide stretched column">
          <div class="ui breadcrumb">
              <a class="section">
                  <%
                      String year = (String)session.getAttribute("year");
                      if (year != null){
                          out.print("year : "+year);
                      }
                  %>
              </a>
              <i class="divider"> > </i>
              <a class="section">
                  <%
                      String department = (String)session.getAttribute("department");
                      if (department != null){
                          out.print("department : "+department);
                      }
                  %>
              </a>
              <i class="divider"> > </i>
              <a class="section">
                  <%
                      String section = (String)session.getAttribute("section");
                      if (section != null){
                          out.print("section : "+section);
                      }
                  %>
              </a>
              <i class="divider"> > </i>
              <div class="section">
                  <div class="ui dropdown">
                      <%
                        String courseCode = (String)session.getAttribute("course");
                        if(courseCode == null)
                            courseCode = "course";
                        out.print("<div class=\"text\">"+courseCode+"</div>");
                      %>

                       <i class="dropdown icon"></i>
                      <div class="menu">
                          <%
                              String course = (String)session.getAttribute("subjects");
                              JSONParser parser = new JSONParser();
                              Object obj = parser.parse(course);

                              JSONArray list = (JSONArray) obj;
                              boolean flag = true;
                              try{
                                  if ( list != null ) {
                                      Iterator<String> iterator = list.iterator();

                                      while (iterator.hasNext()) {
                                          flag = false;
                                          String s = iterator.next();
                                          out.print("<div class=\"item course\"  data-value=\""+s+"\">"+s+"</div>");
                                      }
                                  }
                              }catch(Exception e){
                                  out.print(e.toString());
                              }
                              if (flag){
                                  out.print("<div class=\"item\">please login again</div>");
                              }
                          %>
                      </div>
                  </div>
              </div>
              <i class="divider"> > </i>
              <div class="section">
                  <div class="ui dropdown">
                      <%
                        String assesment = (String)session.getAttribute("assesment");
                        if(assesment == null)
                            assesment = "assesment";
                        out.print("<div class=\"text\">"+assesment+"</div>");
                      %>
                   <i class="dropdown icon"></i>
                  <div class="menu">
                      <div class="item assesment" data-value="CT1">CT1</div>
                      <div class="item assesment" data-value="CT2">CT2</div>
                      <div class="item assesment" data-value="other">Other assesment</div>
                  </div>
                </div>
            </div>

        </div><!-- bread crumbs end -->

           <div style="height:5px"></div>
          <iframe id="frameBody" src=""></iframe>
      </div>
    </div>


<script src="js/jquery-3.1.1.min.js"></script>
<!--jquery should be loaded before sematic and your custom javascript -->
<script src="js/semantic.min.js"></script>

<script>
$('.tabular.menu.item').tab();
$(document).ready(function() {
    //$('.ui.dropdown').dropdown();

});
var height = $("body").innerHeight();
var hgt = height*0.16;
//document.write(hgt);
$('.margin').height(hgt);
var h = $("#test").height();
$("#test").hide();
var offset = $("#sidePlane").offset().top;
var navh = $("#nav").height();
console.log(navh);
$("#sidePlane").height(h - navh -20);

$(document).ready(function() {
    $('.ui.dropdown').dropdown({
        onChange: function(value, text, $selectedItem) {
          //console.log(value,text);
          if ($selectedItem.hasClass("course")){
              $.get("setSelections",{course:text},function(result){
                  if(result.message == "done"){
                      console.log("done")
                  }else{
                      alert(result.message);
                  }
              });
          }

          if ($selectedItem.hasClass("assesment")){
              $.get("setSelections",{assesment:value},function(result){
                  if(result.message == "done"){
                      console.log("done")
                  }else{
                      alert(result.message);
                  }
              });
          }

        }
    });
});
</script>

<script>

    function itemClick(a){
        $(".item").removeClass("active");
        $(a).addClass("active");
        link = a.getAttribute("link");
        $("#frameBody").attr('src',link )
    }
</script>

</body>
</html>
