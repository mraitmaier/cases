{{define "projects"}}
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Cases - Manage Projects</title>

    <!-- Bootstrap -->
    <link href="static/css/bootstrap.min.css" rel="stylesheet">
    <link href="static/css/dataTables.bootstrap.min.css" rel="stylesheet">
    <link href="static/css/custom.css" rel="stylesheet">

  </head>

  <body>
    {{template "navbar" .Ptype}}

    <div class="container-fluid">
        <div class="row col-md-offset-1 col-md-10" id="header">
            <h1 id="main-title">Projects</h1>
            <p>All projects are displayed here.</p>
        </div>

        <div class="row col-md-offset-1 col-md-10" id="new-proj-btn">
            <br />
            <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#addProjModal">
                <span class="glyphicon glyphicon-plus"></span> &nbsp; New Project
            </button>
        </div>

        <div class="row col-md-offset-1 col-md-10" id="data">
            <br />
    {{if .Projects}}

            <div id="data-list">
                <table id="projects" class="table table-stripped table-hover small">

                <thead>
                    {{template "proj-table-header"}}
                </thead>

                <tfoot>
                    {{template "proj-table-header"}}
                </tfoot>
    
                <tbody>
                    {{range $index, $elem := .Projects}}
                    {{$id := add $index 1}}

                    <tr class="tbl-single-row" id="proj-row-{{$elem.ID.Hex}}">
                        <td>{{$id}}</td>
                        <td>{{$elem.GlobalID}}</td>
                        <td>{{$elem.Name}}</td>
                        <td>{{$elem.Description}}</td>
                        <td class="text-right">
                            <span data-toggle="tooltip" data-placement="up" title="View Project Details">
                            <a href="" data-toggle="modal"  data-target="#viewProjModal" 
                                data-hexid="{{$elem.ID.Hex}}"
                                data-created="{{$elem.Created}}"
                                data-modified="{{$elem.Modified}}"
                                data-global-id="{{$elem.GlobalID}}"
                                data-pname="{{$elem.Name}}"
                                data-desc="{{$elem.Description}}">
                                <span class="glyphicon glyphicon-eye-open"></span>
                            </a>
                            </span>
                            &nbsp;&nbsp;
                            <span data-toggle="tooltip" data-placement="up" title="Modify Project Details">
                            <a href="" data-toggle="modal"  data-target="#modifyProjModal" 
                                data-hexid="{{$elem.ID.Hex}}"
                                data-created="{{$elem.Created}}"
                                data-modified="{{$elem.Modified}}"
                                data-global-id="{{$elem.GlobalID}}"
                                data-pname="{{$elem.Name}}"
                                data-desc="{{$elem.Description}}">
                                <span class="glyphicon glyphicon-edit"></span>
                            </a>
                            </span>
                            &nbsp;&nbsp;
                            <span data-toggle="tooltip" data-placement="up" title="Remove Project">
                            <a href ="" data-toggle="modal" data-target="#removeProjModal" 
                                data-hexid="{{$elem.ID.Hex}}"
                                data-pname="{{$elem.Name}}">
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
{{template "add_proj_modal"}}
{{template "view_proj_modal"}}
{{template "modify_proj_modal"}}
{{template "remove_proj_modal"}}
<!-- End of Add modals -->
    <!-- include jQuery 2.x & plugins -->
    <script src="static/js/jquery.min.js"></script>
    <script src="static/js/jquery.dataTables.min.js"></script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/dataTables.bootstrap.min.js"></script>
    <!-- Include custom application JS code -->
    <script src="static/js/cases.js"></script>
    <script>

    // initialize jQuery dataTables
    $(document).ready( function () {
        $('#projects').DataTable();
    } ); 

    $('#viewProjModal').on('show.bs.modal', function (event) {

        var button = $(event.relatedTarget);     // Button that triggered the modal
        var name = button.data('pname');
        // Update the modal's content. We'll use jQuery here, but you could use a data 
        // binding library or other methods instead.
        var modal = $(this)
        modal.find('.modal-title').text('Project Details');
        modal.find('.modal-body #pname').val(name);
        modal.find('.modal-body #hexid').val(button.data('hexid'));
        modal.find('.modal-body #global-id').val(button.data('global-id'));
        modal.find('.modal-body #description').val(button.data('desc'));
        modal.find('.modal-body #created').text(button.data('created'));
        modal.find('.modal-body #modified').text(button.data('modified'));
    })

    $('#modifyProjModal').on('show.bs.modal', function (event) {

        var button = $(event.relatedTarget); // Button that triggered the modal
        var name = button.data('pname');
        var hexid = button.data('hexid');
        var created = button.data('created');
        var modified = button.data('modified');
        // Update the modal's content. We'll use jQuery here, but you could use a data binding library 
        // or other methods instead.
        var modal = $(this)
        modal.find('.modal-title').text('Modify "' + name + '" Details');
        modal.find('.modal-body #pname').val(name);
        modal.find('.modal-body #hexid').val(hexid);
        modal.find('.modal-body #global-id').val(button.data('global-id'));
        modal.find('.modal-body #description').val(button.data('desc'));
        modal.find('.modal-body #created').val(created);
        modal.find('.modal-body #modified').val(modified);
        modal.find('.modal-body #createdm').text(created);
        modal.find('.modal-body #modifiedm').text(modified);

        var url = "/project/" + hexid + '/put';
        $('#modifybtn').on('click', function(e) {
            postForm('modify_proj_form', url);
            $('#modifyProjModal').modal('hide');
        });
    })

    $('#removeProjModal').on('show.bs.modal', function(event) {
    
        var button = $(event.relatedTarget);
        var hexid = button.data('hexid');
        var name = button.data('pname');
        // Update the modal's content. We'll use jQuery here, but you could use a data binding library 
        // or other methods instead.
        var modal = $(this);
        modal.find('.modal-body #removename').text(name);
        modal.find('.modal-body #hexid').val(hexid);
        modal.find('.modal-body #pname').val(name);

        // Let's define the 'remove' button onclick() callback... 
        var url = '/project/' + hexid + '/delete';
        $('#removebtn').on('click', function(e) { 
            postForm('remove_proj_form', url); 
            $('#removeProjModal').modal('hide');
        });
    });

    </script>
  </body>
</html>
{{end}}

{{define "add_proj_modal"}}
<div class="modal fade" id="addProjModal" tabindex="-1" role="dialog" aria-labelledby="addProjModalLabel">
<div class="modal-dialog">
<div class="modal-content">

    <div class="modal-header">
    <div class="container-fluid">
        <div class="row">
            <h4 class="modal-title col-sm-8" id="addProjModalLabel">Add a New Project</h4>
            <button type="button" class="btn btn-primary btn-sm col-sm-2" 
                    onclick="postForm('add_proj_form', '/project'); $('#addProjModal').modal('hide');">Add</button>
            <button type="button" class="btn btn-default btn-sm col-sm-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
      <form id="add_proj_form" class="form-horizontal" method="POST" action="">
          <div class="form-group form-group-sm">
              <label for="global-id" class="col-sm-2 control-label">Global ID</label>
              <div class="col-sm-10">
                <input type="text" class="form-control" id="global-id" name="global-id" placeholder="Global ID" 
                                   onblur="return validateInput($(this).val(), 'Project Global ID');" required>
              </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="name" class="col-sm-2 control-label">Full Name</label>
                <div class="col-sm-10">
                  <input type="text" class="form-control" id="pname" name="pname" placeholder="Full Project Name" 
                                   onblur="return validateInput($(this).val(), 'Project Name');" required>
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

{{define "view_proj_modal"}}
<div class="modal fade" id="viewProjModal" tabindex="-1" role="dialog" aria-labelledby="viewProjModalLabel">
<div class="modal-dialog">
<div class="modal-content">

    <div class="modal-header">
    <div class="container-fluid">
        <div class="row">
            <h4 class="modal-title col-sm-10" id="viewProjModalLabel">Error Project Title</h4>
            <button type="button" class="btn btn-default btn-sm col-sm-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
      <form id="view_proj_form" class="form-horizontal">
          <div class="form-group form-group-sm">
              <label for="global-id" class="col-sm-2 control-label">Global ID</label>
              <div class="col-sm-10">
                <input type="text" class="form-control" id="global-id" name="global-id" readonly>
              </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="pname" class="col-sm-2 control-label">Full Name</label>
                <div class="col-sm-10">
                  <input type="text" class="form-control" id="pname" name="pname" readonly>
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


{{define "modify_proj_modal"}}
<div class="modal fade" id="modifyProjModal" tabindex="-1" role="dialog" aria-labelledby="modifyProjModalLabel">
<div class="modal-dialog">
<div class="modal-content">

    <div class="modal-header">
    <div class="container-fluid">
        <div class="row">
            <h4 class="modal-title col-sm-8" id="modifyProjModalLabel">Error Project Title</h4>
            <button type="button" id="modifybtn" class="btn btn-primary btn-sm col-sm-2"> 
                 <!--   onclick="modifyProj('modify_proj_form', $('#hexid').val()); $('#modifyProjModal').modal('hide');"> -->
                    Modify
            </button>
            <button type="button" class="btn btn-default btn-sm col-sm-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
      <form id="modify_proj_form" class="form-horizontal">
            <input type="hidden" id="hexid" name="hexid">
          <div class="form-group form-group-sm">
              <label for="global-id" class="col-sm-2 control-label">Global ID</label>
              <div class="col-sm-10">
                <input type="text" class="form-control" id="global-id" name="global-id" 
                                   onblur="return validateInput($(this).val(), 'Project Global ID');" required>
              </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="pname" class="col-sm-2 control-label">Full Name</label>
                <div class="col-sm-10">
                  <input type="text" class="form-control" id="pname" name="pname" 
                                   onblur="return validateInput($(this).val(), 'Project Name');" required>
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

{{define "remove_proj_modal"}}
<div class="modal fade" id="removeProjModal" tabindex="-1" role="dialog" aria-labelledby="removeProjModalLabel">
<div class="modal-dialog">
<div class="modal-content">

    <div class="modal-header">
    <div class="container-fluid">
        <div class="row">
            <h4 class="modal-title col-sm-8" id="removeProjModalLabel">Remove Project</h4>
            <button type="button" class="btn btn-primary btn-sm col-sm-2" id="removebtn">
            Remove </button>
            <button type="button" class="btn btn-default btn-sm col-sm-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
    <p> Would you really like to remove the project '<span id="removename"></span>'?</p>
    <form method="post" id="remove_proj_form">
        <input type="hidden" name="hexid" id="hexid" />
        <input type="hidden" name="pname" id="pname" />
    </form>
    </div>
</div>
</div>
</div>
{{end}}

{{define "proj-table-header"}}
                    <tr>
                        <th class="col-sm-1">#</th>
                        <th class="col-sm-1">Global ID</th>
                        <th class="col-sm-3">Name</th>
                        <th class="col-sm-6">Description</th>
                        <th class="col-sm-1 text-right">Actions</th>
                    </tr>
{{end}}
