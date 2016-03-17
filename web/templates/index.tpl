{{define "index"}}
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Cases - Index</title>

    <!-- Bootstrap -->
    <link href="static/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/custom.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]static/>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    {{template "navbar" ""}}

    <div class="container-fluid">
        <div class="row col-md-offset-1 col-md-10" id="header">
            <h1 id="main-title">Welcome to Cases</h1>
            <h3>Your source for everything regarding test cases.</h3>
        </div> <!-- row -->

        <div class="row col-md-offset-1 col-md-10" id="data">
            <div class="col-md-4" id="data-list">
            </div>

            <div class="col-md-6" id="data-details">
            </div>
        </div> <!-- row -->
    </div> <!-- container fluid -->

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="static/js/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="static/js/bootstrap.min.js"></script>
  </body>
</html>
{{end}}
