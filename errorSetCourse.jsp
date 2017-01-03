<!DOCTYPE Html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>OAS</title>

  <link rel="stylesheet" href="css/semantic.min.css"></link>
  <style media="screen">
  img{
      margin-bottom:-10px;
      margin-top:-10px;
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
    <div class="margin"></div>
    <div class="ui container">
        <div class="ui warning message">
          <!--i class="close icon"></i-->
          <div class="header">
            Error!
          </div>
          please set course and <a href="<%out.print(request.getParameter("url"));%>">try again</a>
        </div>
    </div>



        <script src="js/jquery-3.1.1.min.js"></script>
        <!--jquery should be loaded before sematic and your custom javascript -->
        <script src="js/semantic.min.js"></script>
        <script type="text/javascript">
            var height = $("body").innerHeight();
            var hgt = height*0.26;
            //document.write(hgt);
            $('.margin').height(hgt);
        </script>
</body>


</html>
