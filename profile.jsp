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
              <span style="font-size:20px;color:#29b6f6;">Profile</span>

          </div>
          <a class="item" style="margin-left:940px;"></a>
          <div class="ui right item">
              <div class="menu">
                  <a class="item">
                    <i class="large red inverted sign out icon"></i><span style="font-size:20px;">SignOut</span>
                  </a>
              </div>
          </div>
      </div>
  </div>

<!-- nav bar-->
<div class="margin"></div>
<div class="ui padded grid">
  <div class="ui container"><h2>Hello&nbsp;<span>
      <%
          String name = (String)session.getAttribute("name");
          String role = (String)session.getAttribute("role");
          if (role == null ){
              response.setStatus(response.SC_MOVED_TEMPORARILY);
              response.setHeader("Location", "index.html");
          }else{
              out.print(name);
          }
      %>
  </span>!</h2></div>
  <div class="centered sixteen wide mobile only eight wide tablet only six wide computer only column">
    <div class="ui container">
      <div class="ui form">
        <!-- -->
        <div class="field">
          <label>Academic Year</label>
          <div class="ui fluid search selection dropdown" id="ayearDropdown">
            <i class="dropdown icon"></i>
            <div class="default text">Select academic year</div>
            <div class="menu">
                <div class="item" data-value="y1">2014-2015</div>
                <div class="item" data-value="y1">2015-2016</div>
                <div class="item" data-value="y3">2016-2017</div>
                <div class="item" data-value="y4">2017-2018</div>
            </div>
          </div>
        </div>
        <!-- -->
        <!-- -->
        <div class="field">
          <label>Year Of Study</label>
          <div class="ui fluid search selection dropdown" id="yearDropdown">
            <i class="dropdown icon"></i>
            <div class="default text">Select the year of study</div>
            <div class="menu">
                <div class="item" data-value="1st">1st Year</div>
                <div class="item" data-value="2nd">2nd Year</div>
                <div class="item" data-value="3rd">3rd Year</div>
                <div class="item" data-value="4th">4th Year</div>
            </div>
          </div>
        </div>
        <!-- -->
        <!-- -->
        <div class="field">
          <label>Department</label>
          <div class="ui fluid search selection dropdown" id="departmentDropdown">
            <i class="dropdown icon"></i>
            <div class="default text">Select department</div>
            <div class="menu">
                <div class="item" data-value="cse">CSE</div>
                <div class="item" data-value="it">IT</div>
                <div class="item" data-value="cvl">CIVIL</div>
                <div class="item" data-value="ece">ECE</div>
                <div class="item" data-value="eee">EEE</div>
            </div>
          </div>
        </div>
        <!-- -->
        <!-- -->
        <div class="field">
          <label>Section</label>
          <div class="ui fluid search selection dropdown" id="sectionDropdown">
            <i class="dropdown icon"></i>
            <div class="default text">Select section</div>
            <div class="menu">
                <div class="item" data-value="a">A</div>
                <div class="item" data-value="b">B</div>
                <div class="item" data-value="c">C</div>

            </div>
          </div>
        </div>
        <!-- -->
      <div class="fluid ui buttons">
        <button class="ui blue button" onclick="submit()">View</button>

      </div>
    </div>
    </div>
  </div>
</div>
</div>
<script src="js/jquery-3.1.1.min.js"></script>
<!--jquery should be loaded before sematic and your custom javascript -->
<script src="js/semantic.min.js"></script>

<script>
    $(document).ready(function() {
        $('.ui.selection.dropdown').dropdown();
    });
    var height = $("body").innerHeight();
    var hgt = height*0.20;
    //document.write(hgt);
    $('.margin').height(hgt);
    function submit(){
        var obj={};
        obj.ayear = $("#ayearDropdown").dropdown('get value');
        obj.year = $("#yearDropdown").dropdown('get value');
        obj.department = $("#departmentDropdown").dropdown('get value');
        obj.section = $("#sectionDropdown").dropdown('get value');
        console.log(obj);
        $.get("setSelections",obj,function(result){
            if(result.message == "done"){
                window.location = "dashboard.html";
            }else{
                alert(result.message);
            }
        });
    }
</script>

</body>
</html>
