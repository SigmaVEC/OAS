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
                    <span style="font-size:20px;">Admin</span><i class="large blue  user icon"></i>
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
          <a class="active item" onclick="itemClick(this)" link="staffAssignment.html">Courses List</a>
          <a class=" item" onclick="itemClick(this)" link="addStudents.jsp">Students List</a>
          <a class=" item" onclick="itemClick(this)" link="management.html">Manage Users</a>

        </div>
      </div>
      <div class="thirteen wide stretched column">

              <div class="ui breadcrumb">
                  <a class="section" href="profile.jsp">
                      <%
                          String year = (String)session.getAttribute("year");
                          if (year != null){
                              out.print("year : "+year);
                          }
                      %>
                  </a>
                  <i class="divider"> > </i>
                  <a class="section" href="profile.jsp">
                      <%
                          String department = (String)session.getAttribute("department");
                          if (department != null){
                              out.print("department : "+department);
                          }
                      %>
                  </a>
                  <i class="divider"> > </i>
                  <a class="section" href="profile.jsp">
                      <%
                          String section = (String)session.getAttribute("section");
                          if (section != null){
                              out.print("section : "+section);
                          }
                      %>
                  </a>
                  <!--i class="divider"> > </i>
                  <a class="section">
                      <%
                          String course = (String)session.getAttribute("course");
                          out.print("course : ");
                          if (course != null){
                              out.print(course);
                          }else{
                              out.print("<b>select</b>");
                          }
                      %>
                  </a-->
                  <!--i class="divider"> > </i>
                  <a class="section">
                      <%
                          String assesment = (String)session.getAttribute("assesment");
                          out.print("assesment : ");
                          if (assesment != null){
                              out.print(assesment);
                          }else{
                              out.print("<b>select</b>");
                          }
                      %>
                  </a-->
              </div>

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
