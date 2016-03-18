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
    <link href="static/css/dataTables.bootstrap.min.css" rel="stylesheet">
    <link href="static/css/custom.css" rel="stylesheet">

  </head>

  <body>
    {{template "navbar" .Ptype}}

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
                    {{template "req-table-header"}}
                </thead>

                <tfoot>
                    {{template "req-table-header"}}
                </tfoot>
    
                <tbody>
                    {{range $index, $elem := .Reqs}}
                    {{$id := add $index 1}}

                    <tr class="tbl-single-row" id="req-row-{{$elem.ID.Hex}}">
                        <td>{{$id}}</td>
                        <td>{{$elem.Short}}</td>
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
    <!-- include jQuery 2.x & plugins -->
    <script src="static/js/jquery.min.js"></script>
    <script src="static/js/jquery.dataTables.min.js"></script>
    <script src="static/js/jquery.validate.min.js"></script>
    <!-- <script src="static/js/additional-methods.min.js"></script> additional for validate -->
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/dataTables.bootstrap.min.js"></script>
    <!-- Include custom application JS code -->
    <script src="static/js/cases.js"></script>
    <script>

    // initialize jQuery dataTables plugin
    // and validation plugin also...
    $(document).ready( function () {

        $('#requirements').DataTable();

        $('#add_req_form').validate();
        $('#modify_req_form').validate();
    } ); 

    $('#viewReqModal').on('show.bs.modal', function (event) {

        var button = $(event.relatedTarget);     // Button that triggered the modal
        var name = button.data('reqname');
        // Update the modal's content. We'll use jQuery here, but you could use a data 
        // binding library or other methods instead.
        var modal = $(this)
        modal.find('.modal-title').text('The "' + name + '" Details');
        modal.find('.modal-body #name').text(name);
        modal.find('.modal-body #hexid').val(button.data('hexid'));
        modal.find('.modal-body #short').text(button.data('short'));
        modal.find('.modal-body #priority').text(button.data('prio'));
        modal.find('.modal-body #reqstatus').text(button.data('reqstatus'));
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

    // Add requirement form on-submit validation 
    $('#addbtn').click(function() {
        if ( $('#add_req_form').valid() ) {
            postForm('add_req_form', '/requirement'); 
            $('#addReqModal').modal('hide');
        }
    });

    // Modify requirement form on-submit validation 
    $('#modifybtn').click(function() {
        if ( $('#modify_req_form').valid() ) {
            modifyReq('modify_req_form', $('#hexid').val()); 
            $('#modifyReqModal').modal('hide');
        }
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
            <button type="button" class="btn btn-primary btn-sm col-sm-2" id="addbtn">Add</button>
                    <!--onclick="postForm('add_req_form', '/requirement'); $('#addReqModal').modal('hide');">Add</button>-->
            <button type="button" class="btn btn-default btn-sm col-sm-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
      <form id="add_req_form" class="form-horizontal" method="post">
          <div class="form-group form-group-sm">
              <label for="short" class="col-sm-2 control-label">Short Name</label>
              <div class="col-sm-10">
                    <input type="text" class="form-control" id="short" name="short" placeholder="Short Name" 
                                       minlength="2" required>
              </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="name" class="col-sm-2 control-label">Full Name</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="name" name="name" placeholder="Full Requirement Name" 
                                       minlength="2" required>
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
                    <!-- this is forced; only shown here as label for user to know -->
                    <input type="hidden"  id="reqstatus" name="reqstatus" value="New">
                    <label  class="form-control">New</label>
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
                    <label class="form-control" id="short" name="short">
              </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="name" class="col-sm-2 control-label">Full Name</label>
                <div class="col-sm-10">
                    <label class="form-control" id="name" name="name">
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="priority" class="col-sm-2 control-label">Priority</label>
                <div class="col-sm-10">
                    <label class="form-control" id="priority" name="priority">
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="reqstatus" class="col-sm-2 control-label">Status</label>
                <div class="col-sm-10">
                    <label class="form-control" id="reqstatus" name="reqstatus">
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
            <button type="button" class="btn btn-primary btn-sm col-sm-2" id="modifybtn"> 
                  <!--  onclick="modifyReq('modify_req_form', $('#hexid').val()); $('#modifyReqModal').modal('hide');">-->
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
                <input type="text" class="form-control" id="short" name="short" minlength="2" required>
              </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="name" class="col-sm-2 control-label">Full Name</label>
                <div class="col-sm-10">
                  <input type="text" class="form-control" id="name" name="name" minlength="2" required>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="priority" class="col-sm-2 control-label">Priority</label>
                <div class="col-sm-10">
                <select class="form-control" id="priority" name="priority" required>
                    <option>Low</option>
                    <option>Normal</option>
                    <option>High</option>
                </select>
                </div>
            </div>
             <div class="form-group form-group-sm">
                <label for="reqstatus" class="col-sm-2 control-label">Status</label>
                <div class="col-sm-10">
                <select class="form-control" id="reqstatus" name="reqstatus" required>
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

{{define "req-table-header"}}
                    <tr>
                        <th class="col-sm-1">#</th>
                        <th class="col-sm-1">Short</th>
                        <th class="col-sm-6">Name</th>
                        <th class="col-sm-1">Priority</th>
                        <th class="col-sm-1">Status</th>
                        <th class="col-sm-2 text-right">Actions</th>
                    </tr>
{{end}}
