{{define "requirements"}}
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Cases - Manage Requirements</title>

    <!-- Bootstrap -->
    <link href="static/css/bootstrap.min.css" rel="stylesheet">

  </head>

  <body>
    {{template "navbar" .User}}

    <div class="container-fluid">
        <div class="row col-md-offset-1 col-md-10" id="header">
            <h1 id="main-title">Requirements</h1>
            <p>All requirements are displayed here.</p>
        </div>

        <div class="row col-md-offset-1 col-md-10" id="new-req-btn">
            <br />
            <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#addReqModal">
                <span class="glyphicon glyphicon-plus"></span> &nbsp; New Requirement
            </button>
        </div>

        <div class="row col-md-offset-1 col-md-10" id="data">
            <br />
    {{if .Reqs}}

            <div id="data-list">
                <table id="requirements" class="table table-stripped table-hover small">

                <thead>
                    <tr>
                        <colgroup class="col-sm-2">
                        <th>#</th>
                        <th>Short</th>
                        </colgroup>
                        <th class="col-sm-6">Name</th>
                        <th class="col-sm-1">Priority</th>
                        <th class="col-sm-1">Status</th>
                        <th class="col-sm-2 text-right">Actions</th>
                    </tr>
                </thead>

                <tfoot>
                    <tr class="bg-primary">
                        <td colspan="6" class="text-right">
                            <strong>{{.Num}} {{if eq .Num 1}} requirement {{else}} requirements {{end}} found.</strong>
                        </td>
                    </tr>
                </tfoot>
    
                <tbody>
                    {{range $index, $elem := .Reqs}}
                    {{$id := add $index 1}}

                    <tr id="req-row-{{$elem.ID.Hex}}">
                        <colgroup>
                        <td>{{$id}}</td>
                        <td>{{$elem.Short}}</td>
                        </colgroup>
                        <td>{{$elem.Name}}</td>
                        <td>{{$elem.Priority}}</td>
                        <td>{{$elem.Status}}</td>
                        <td class="text-right">
                            <span data-toggle="tooltip" data-placement="up" title="View Requirement Details">
                            <a href="" data-toggle="modal"  data-target="#viewReqModal" 
                                data-hexid="{{$elem.ID.Hex}}"
                                data-created="{{$elem.Created}}"
                                data-modified="{{$elem.Modified}}"
                                data-short="{{$elem.Short}}"
                                data-reqname="{{$elem.Name}}"
                                data-prio="{{$elem.Priority}}"
                                data-reqstatus="{{$elem.Status}}"
                                data-desc="{{$elem.Description}}">
                                <span class="glyphicon glyphicon-eye-open"></span>
                            </a>
                            </span>
                            &nbsp;&nbsp;
                            <span data-toggle="tooltip" data-placement="up" title="Modify Requirement Details">
                            <a href="" data-toggle="modal"  data-target="#modifyReqModal" 
                                data-hexid="{{$elem.ID.Hex}}"
                                data-created="{{$elem.Created}}"
                                data-modified="{{$elem.Modified}}"
                                data-short="{{$elem.Short}}"
                                data-reqname="{{$elem.Name}}"
                                data-prio="{{$elem.Priority}}"
                                data-desc="{{$elem.Description}}"
                                data-reqstatus="{{$elem.Status}}">
                                <span class="glyphicon glyphicon-edit"></span>
                            </a>
                            </span>
                            &nbsp;&nbsp;
                            <!--
                                 onclick="deleteReq('{{$elem.Name}}', '{{$elem.ID.Hex}}');">
                            -->
                            <span data-toggle="tooltip" data-placement="up" title="Remove Requirement">
                            <a href ="" data-toggle="modal" data-target="#removeReqModal" 
                                             data-hexid="{{$elem.ID.Hex}}"
                                             data-reqname="{{$elem.Name}}">
                               <span class="glyphicon glyphicon-remove"></span>
                            </a>
                            </span>
                        </td>
                    </tr>

                    {{end}}
                </tbody>
                </table>

                <ul class="pagination pagination-sm" id="reqs_pagination"><!-- dynamic! --></ul> 
    {{end}}
            </div> <!-- data-list -->
        </div> <!-- row -->
    </div> <!-- container fluid -->

<!-- Add modals -->
{{template "add_req_modal"}}
{{template "view_req_modal"}}
{{template "modify_req_modal"}}
{{template "remove_req_modal"}}
<!-- End of Add modals -->

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="static/js/jquery.min.js"></script>
    <script src="static/js/jquery.validate.min.js"></script>
    <script src="static/js/additional-methods.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/jquery.bootpag.min.js"></script>
    <!-- Include custom application JS code -->
    <script src="static/js/cases.js"></script>
    <script>

    var numOfReqs = parseInt({{.Num}}); // Number of requirements is given by backend
    //var reqsPerPage = 20;             // Number of requirements displayed by page is currently static
    var reqsPerPage = 5;                // Number of requirements displayed by page is currently static
    // How many page are needed...
    var numOfPages = (numOfReqs % reqsPerPage === 0) ? (numOfReqs/reqsPerPage) : (numOfReqs/reqsPerPage+1);

    // Function that displays the page (the range of requirements) in the main table. 
    // Page number is given...
    var showReqsRange = function (table_id, pagenum) {

        var start = ((pagenum - 1) * reqsPerPage) + 1;
        var end = start + reqsPerPage;

        var rows = $('#' +table_id + ' > tbody > tr');
        var len = rows.length;

        if (len > 0) {
            for (var tr = 0; tr < len; tr++) {
                if ((tr >= start) && (tr <= end)) {
                    rows[tr].show();
                } else {
                    rows[tr].hide();
                }
            }
        }
    };

    if (numOfPages > 1) {

        $('#reqs_pagination').append( 
                $('<li>').append( $('<a>').attr('href', '#').attr('id', 'first').append('\xab') )
        );
        $('#reqs_pagination #first').on('click', function(e) {
            showReqsRange('requirements', 1);
        });

        for (var cnt = 1; cnt <= numOfPages; cnt++) {
            var pageid = 'page' + cnt;
            $('#reqs_pagination').append( 
                                 $('<li>').append( $('<a>').attr('href', '#').attr('id', pageid) 
                                 .append(cnt.toString())) 
                                 );
            $('#reqs_pagination #pageid').on('click', function(e) {
                showReqsRange('requirements', cnt);
            });
        }

        $('#reqs_pagination').append( 
                $('<li>').append( $('<a>').attr('href', '#').attr('id', 'last').append('\xbb') )
        );
        $('#reqs_pagination #last').on('click', function(e) {
            showReqsRange('requirements', numOfPages);
        });

    } else {

        $('#reqs_pagination').append(
            $('<li>').append( $('<a>').attr('href', '#').append('\xab') ),
            $('<li>').append( $('<a>').attr('href', '#').append('1')),
            $('<li>').append( $('<a>').attr('href', '#').append('\xbb') )
        );

    }

    $('#viewReqModal').on('show.bs.modal', function (event) {

        var button = $(event.relatedTarget);     // Button that triggered the modal
        var name = button.data('reqname');
        // Update the modal's content. We'll use jQuery here, but you could use a data 
        // binding library or other methods instead.
        var modal = $(this)
        modal.find('.modal-title').text('The "' + name + '" Details');
        modal.find('.modal-body #name').val(name);
        modal.find('.modal-body #hexid').val(button.data('hexid'));
        modal.find('.modal-body #short').val(button.data('short'));
        modal.find('.modal-body #priority').val(button.data('prio'));
        modal.find('.modal-body #reqstatus').val(button.data('reqstatus'));
        modal.find('.modal-body #description').val(button.data('desc'));
        modal.find('.modal-body #created').text(button.data('created'));
        modal.find('.modal-body #modified').text(button.data('modified'));
    })

    $('#modifyReqModal').on('show.bs.modal', function (event) {

        var button = $(event.relatedTarget); // Button that triggered the modal
        var name = button.data('reqname');
        var created = button.data('created');
        var modified = button.data('modified');
        // Update the modal's content. We'll use jQuery here, but you could use a data binding library 
        // or other methods instead.
        var modal = $(this)
        modal.find('.modal-title').text('Modify "' + name + '" Details');
        modal.find('.modal-body #name').val(name);
        modal.find('.modal-body #hexid').val(button.data('hexid'));
        modal.find('.modal-body #short').val(button.data('short'));
        modal.find('.modal-body #priority').val(button.data('prio'));
        modal.find('.modal-body #reqstatus').val(button.data('reqstatus'));
        modal.find('.modal-body #description').val(button.data('desc'));
        modal.find('.modal-body #created').val(created);
        modal.find('.modal-body #modified').val(modified);
        modal.find('.modal-body #createdm').text(created);
        modal.find('.modal-body #modifiedm').text(modified);
    })

    $('#removeReqModal').on('show.bs.modal', function(event) {
    
        var button = $(event.relatedTarget);
        var hexid = button.data('hexid');
        var name = button.data('reqname');
        // Update the modal's content. We'll use jQuery here, but you could use a data binding library 
        // or other methods instead.
        var modal = $(this);
        modal.find('.modal-body #removename').text(name);
        modal.find('.modal-body #hexid').val(hexid);
        modal.find('.modal-body #reqname').val(name);

        // Let's define the 'remove' button onclick() callback... 
        var url = '/requirement/' + hexid + '/delete';
        $('#removebtn').on('click', function(e) { 
            postForm('remove_req_form', url); 
            $('#removeReqModal').modal('hide');
        });
    });

    </script>
  </body>
</html>
{{end}}

{{define "add_req_modal"}}
<div class="modal fade" id="addReqModal" tabindex="-1" role="dialog" aria-labelledby="addReqModalLabel">
<div class="modal-dialog">
<div class="modal-content">

    <div class="modal-header">
    <div class="container-fluid">
        <div class="row">
            <h4 class="modal-title col-sm-8" id="addReqModalLabel">Add a New Requirement</h4>
            <button type="button" class="btn btn-primary btn-sm col-sm-2" 
                    onclick="postForm('add_req_form', '/requirement'); $('#addReqModal').modal('hide');">Add</button>
            <button type="button" class="btn btn-default btn-sm col-sm-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
      <form id="add_req_form" class="form-horizontal" method="POST" action="">
          <div class="form-group form-group-sm">
              <label for="short" class="col-sm-2 control-label">Short Name</label>
              <div class="col-sm-10">
                <input type="text" class="form-control" id="short" name="short" placeholder="Short Name" 
                                   onblur="return validateInput($(this).val(), 'Requirement Short Name');" required>
              </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="name" class="col-sm-2 control-label">Full Name</label>
                <div class="col-sm-10">
                  <input type="text" class="form-control" id="name" name="name" placeholder="Full Requirement Name" 
                                   onblur="return validateInput($(this).val(), 'Requirement Name');" required>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="priority" class="col-sm-2 control-label">Priority</label>
                <div class="col-sm-10">
                <select class="form-control" id="priority" name="priority" required>
                    <option>Low</option>
                    <option selected>Normal</option>
                    <option>High</option>
                </select>
                </div>
            </div>
             <div class="form-group form-group-sm">
                <label for="reqstatus" class="col-sm-2 control-label">Status</label>
                <div class="col-sm-10">
                <select class="form-control" id="reqstatus" name="reqstatus" required>
                    <option selected>New</option>
                    <option>Acknowledged</option>
                    <option>Pending</option>
                    <option>Approved</option>
                    <option>Rejected</option>
                    <option>Obsolete</option>
                </select>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="description" class="col-sm-2 control-label">Description</label>
                <div class="col-sm-offset-10">&nbsp;</div>
                <div class="col-sm-12">
                <textarea class="form-control" rows="5" id="description" name="description"></textarea>
                </div>
            </div>
      </form>
    </div>
<!--
    <div class="modal-footer">   
    <div class="container-fluid">
        <div class="row">
            <button type="button" class="btn btn-primary col-md-offset-8 col-md-2" 
                    onclick="postForm('add_req_form', '/requirement'); $('#addReqModal').modal('hide');">Add</button>
            <button type="button" class="btn btn-default col-md-2" data-dismiss="modal">Cancel</button>
        </div> 
    </div> 
    </div> 
-->
</div>
</div>
</div>
{{end}}

{{define "view_req_modal"}}
<div class="modal fade" id="viewReqModal" tabindex="-1" role="dialog" aria-labelledby="viewReqModalLabel">
<div class="modal-dialog">
<div class="modal-content">

    <div class="modal-header">
    <div class="container-fluid">
        <div class="row">
            <h4 class="modal-title col-sm-10" id="viewReqModalLabel">Error Requirement Title</h4>
            <button type="button" class="btn btn-default btn-sm col-sm-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
      <form id="view_req_form" class="form-horizontal">
          <div class="form-group form-group-sm">
              <label for="short" class="col-sm-2 control-label">Short Name</label>
              <div class="col-sm-10">
                <input type="text" class="form-control" id="short" name="short" readonly>
              </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="name" class="col-sm-2 control-label">Full Name</label>
                <div class="col-sm-10">
                  <input type="text" class="form-control" id="name" name="name" readonly>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="priority" class="col-sm-2 control-label">Priority</label>
                <div class="col-sm-10">
                  <input type="text" class="form-control" id="priority" name="priority" readonly>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="reqstatus" class="col-sm-2 control-label">Status</label>
                <div class="col-sm-10">
                  <input type="text" class="form-control" id="reqstatus" name="reqstatus" readonly>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="description" class="col-sm-2 control-label">Description</label>
                <div class="col-sm-offset-10">&nbsp;</div>
                <div class="col-sm-12">
                  <textarea class="form-control" rows="5" id="description" name="description" readonly></textarea>
                </div>
            </div>
            <div class="form-group form-group-sm small">
                <div class="col-sm-2 text-right"><strong>Created:</strong></div>
                <div id="created" name="created" class="col-sm-3 text-left">Error</div>
                <div class="col-sm-3 text-right"><strong>Modified:</strong></div>
                <div id="modified" name="modified" class="col-sm-3 text-left">Error</div>
            </div>
      </form>
    </div>
  <!--  
    <div class="modal-footer">   
    <div class="container-fluid">
        <div class="row">
            <button type="button" class="btn btn-default col-md-offset-10 col-md-2" data-dismiss="modal">Cancel</button>
        </div> 
    </div> 
    </div> 
  --> 
</div>
</div>
</div>
{{end}}


{{define "modify_req_modal"}}
<div class="modal fade" id="modifyReqModal" tabindex="-1" role="dialog" aria-labelledby="modifyReqModalLabel">
<div class="modal-dialog">
<div class="modal-content">

    <div class="modal-header">
    <div class="container-fluid">
        <div class="row">
            <h4 class="modal-title col-sm-8" id="modifyReqModalLabel">Error Requirement Title</h4>
            <button type="button" class="btn btn-primary btn-sm col-sm-2" 
                    onclick="modifyReq('modify_req_form', $('#hexid').val()); $('#modifyReqModal').modal('hide');">
                    Modify
            </button>
            <button type="button" class="btn btn-default btn-sm col-sm-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
      <form id="modify_req_form" class="form-horizontal">
            <input type="hidden" id="hexid" name="hexid">
          <div class="form-group form-group-sm">
              <label for="short" class="col-sm-2 control-label">Short Name</label>
              <div class="col-sm-10">
                <input type="text" class="form-control" id="short" name="short" 
                                   onblur="return validateInput($(this).val(), 'Requirement Short Name');" required>
              </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="name" class="col-sm-2 control-label">Full Name</label>
                <div class="col-sm-10">
                  <input type="text" class="form-control" id="name" name="name" 
                                   onblur="return validateInput($(this).val(), 'Requirement Name');" required>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="priority" class="col-sm-2 control-label">Priority</label>
                <div class="col-sm-10">
                <select class="form-control" id="priority" name="priority">
                    <option>Low</option>
                    <option>Normal</option>
                    <option>High</option>
                </select>
                </div>
            </div>
             <div class="form-group form-group-sm">
                <label for="reqstatus" class="col-sm-2 control-label">Status</label>
                <div class="col-sm-10">
                <select class="form-control" id="reqstatus" name="reqstatus">
                    <option>New</option>
                    <option>Acknowledged</option>
                    <option>Pending</option>
                    <option>Approved</option>
                    <option>Rejected</option>
                    <option>Obsolete</option>
                </select>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="description" class="col-sm-2 control-label">Description</label>
                <div class="col-sm-offset-10">&nbsp;</div>
                <div class="col-sm-12">
                  <textarea class="form-control" rows="5" id="description" name="description"></textarea>
                </div>
            </div>
<!--            <div class="form-group form-group-sm small">
                <div class="form-inline">
                <label for="created" class="control-label col-sm-2" >Created:</label>
                <input type="text" id="created" name="created" class="form-control col-sm-3" readonly />
                <label for="modified" class="control-label col-sm-2">Modified:</label>
                <input type="text" id="modified" name="modified" class="form-control col-sm-3" readonly />
                </div>
            </div> -->
            <div class="form-group form-group-sm small">
                <input type="hidden" name="created" id="created">
                <input type="hidden" name="modified" id="modified">
                <div class="col-sm-2 text-right"><strong>Created:</strong></div>
                <div id="createdm" name="created" class="col-sm-3 text-left">Error</div>
                <div class="col-sm-3 text-right"><strong>Modified:</strong></div>
                <div id="modifiedm" name="modified" class="col-sm-3 text-left">Error</div>
            </div>

      </form>
    </div>

</div>
</div>
</div>
{{end}}

{{define "remove_req_modal"}}
<div class="modal fade" id="removeReqModal" tabindex="-1" role="dialog" aria-labelledby="removeReqModalLabel">
<div class="modal-dialog">
<div class="modal-content">

    <div class="modal-header">
    <div class="container-fluid">
        <div class="row">
            <h4 class="modal-title col-sm-8" id="removeReqModalLabel">Remove Requirement</h4>
            <button type="button" class="btn btn-primary btn-sm col-sm-2" id="removebtn">
            Remove </button>
            <button type="button" class="btn btn-default btn-sm col-sm-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
    <p> Would you really like to remove the requirement '<span id="removename"></span>'?</p>
    <form method="post" id="remove_req_form">
        <input type="hidden" name="hexid" id="hexid" />
        <input type="hidden" name="reqname" id="reqname" />
    </form>
    </div>
</div>
</div>
</div>
{{end}}

