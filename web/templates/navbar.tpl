{{define "navbar"}}
    <nav class="navbar navbar-default" role="navigation">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
            &nbsp;
            <a class="navbar-brand" href="/index" data-toggle="tooltip" data-placement="top" title="Home">
                <span class="glyphicon glyphicon-home" ></span> &nbsp; <strong>CASES</strong>
            </a>
            &nbsp;
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">

                <form class="navbar-form navbar-left" role="search" method="post" action="/search">
                    <div class="form-group">
                        <input type="text" name="search-string" class="form-control" placeholder="Search">
                        <input type="hidden" name="search-type" value="{{.}}">
                    </div>
                    <button type="submit" class="btn btn-primary">Submit</button>
                </form>

                <ul class="nav navbar-nav navbar-right">
                    <li><a href="/case">Test Cases</a></li>
                    <li><a href="/requirement">Requirements</a></li>

                    <li>
                        <a href="#" data-toggle="tooltip" data-placement="top" title="About">
                            <span class="glyphicon glyphicon-star"></span>
                        </a>
                    </li>

                    <li>
                        <a href="#" data-toggle="tooltip" data-placement="top" title="Settings">
                            <span class="glyphicon glyphicon-cog" ></span>
                        </a>
                    </li>

                    <li>
                        <a href="/license" data-toggle="tooltip" data-placement="top" title="License">
                            <span class="glyphicon glyphicon-copyright-mark"></span>
                        </a>
                    </li>

<!--
                    <li>
                        <a href="#" data-toggle="tooltip" data-placement="top" title="User profile">
                            <span class="glyphicon glyphicon-user"></span>
                        </a>
                    </li>
                    <li><p class="navbar-text">Signed in as {{.}}</p></li>

                    <li>
                        <a href="#" data-toggle="tooltip" data-placement="top" title="Sign out">
                            <span class="glyphicon glyphicon-log-out"></span>
                        </a>
                    </li>
-->
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
{{end}}
