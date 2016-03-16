{{define "cases"}}
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Cases - Displaying all cases</title>

    <!-- Bootstrap -->
    <link href="static/css/bootstrap.min.css" rel="stylesheet">

  </head>

  <body>
    {{template "navbar" .User}}

    <div class="container-fluid">
        <div class="row col-md-offset-1 col-md-10" id="header">
            <h1 id="main-title">Test Cases</h1>
            <p>All test cases are displayed here.</p>
        </div>

        <div class="row col-md-offset-1 col-md-10" id="new-case-btn">
            <br />
            <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#addCaseModal">
                <span class="glyphicon glyphicon-plus"></span> &nbsp; New Test Case
            </button>
        </div>

        <div class="row col-md-offset-1 col-md-10" id="data">
            <br />
    {{if .Cases}}

            <div id="data-list">
                <table id="cases" class="table table-stripped table-hover small">

                <thead>
                    <tr>
                        <colgroup class="col-sm-2">
                        <th>#</th>
                        <th>Case ID</th>
                        </colgroup>
                        <th class="col-sm-4">Name</th>
                        <th class="col-sm-1">Priority</th>
                        <th class="col-sm-1">Automated</th>
                        <th class="col-sm-3">Requirement ID</th>
                        <th class="col-sm-1 text-right">Actions</th>
                    </tr>
                </thead>

                <tfoot>
                    <tr class="bg-primary">
                        <td colspan="7" class="text-right">
                            <strong> {{.Num}} test {{if eq .Num 1}} case {{else}} cases {{end}} found.</strong>
                        </td>
                    </tr>
                </tfoot>

                <tbody>
                    {{range $index, $elem := .Cases}}
                    {{$id := add $index 1}}

                    <tr id="case-row-{{$elem.ID.Hex}}">
                        <colgroup>
                        <td>{{$id}}</td>
                        <td>{{$elem.CaseID}}</td>
                        </colgroup>
                        <td>{{$elem.Name}}</td>
                        <td>{{$elem.Priority}}</td>
                        {{if $elem.Auto}}<td>Yes</td>{{else}}<td>No</td>{{end}}
                        <td>{{$elem.ReqID}}</td>
                        <td class="text-right">
                            <span data-toggle="tooltip" data-placement="up" title="View Test Case Details">
                            <a href="" data-toggle="modal"  data-target="#viewCaseModal" 
                                data-hexid="{{$elem.ID.Hex}}"
                                data-created="{{$elem.Created}}"
                                data-modified="{{$elem.Modified}}"
                                data-caseid="{{$elem.CaseID}}"
                                data-casename="{{$elem.Name}}"
                                data-prio="{{$elem.Priority}}"
                                data-auto="{{$elem.Auto}}"
                                data-desc="{{$elem.Desc}}"
                                data-expect="{{$elem.Expect}}"
                                data-notes="{{$elem.Notes}}"
                                data-reqid="{{$elem.ReqID}}">
                                <span class="glyphicon glyphicon-eye-open"></span>
                            </a>
                            </span>
                            &nbsp;&nbsp;
                            <span data-toggle="tooltip" data-placement="up" title="Modify Test Case Details">
                            <a href="" data-toggle="modal"  data-target="#modifyCaseModal" 
                                data-hexid="{{$elem.ID.Hex}}"
                                data-created="{{$elem.Created}}"
                                data-modified="{{$elem.Modified}}"
                                data-caseid="{{$elem.CaseID}}"
                                data-casename="{{$elem.Name}}"
                                data-prio="{{$elem.Priority}}"
                                data-auto="{{$elem.Auto}}"
                                data-desc="{{$elem.Desc}}"
                                data-expect="{{$elem.Expect}}"
                                data-notes="{{$elem.Notes}}"
                                data-reqid="{{$elem.ReqID}}">
                                <span class="glyphicon glyphicon-edit"></span>
                            </a>
                            </span>
                            &nbsp;&nbsp;
<!--
                            <a href="" data-toggle="tooltip" data-placement="up" title="Remove Test Case"
                                onclick="deleteCase('{{$elem.Name}}', '{{$elem.ID.Hex}}');">
                               <span class="glyphicon glyphicon-remove"></span>
                            </a>
-->

                            <span data-toggle="tooltip" data-placement="up" title="Remove Test Case">
                            <a href ="" data-toggle="modal" data-target="#removeCaseModal"
                                             data-hexid="{{$elem.ID.Hex}}"
                                             data-caseid="{{$elem.CaseID}}"
                                             data-casename="{{$elem.Name}}">
                               <span class="glyphicon glyphicon-remove"></span>
                            </a>
                            </span>


                        </td>
                    </tr>

                    {{end}}
                </tbody>

                </table>

                <ul class="pagination pagination-sm" id="cases_pagination">
            <!--
                    <li><a href="#">&laquo;</a></li>
                    <li><a href="#">1</a></li>
                    <li><a href="#">2</a></li>
                    <li><a href="#">3</a></li>
                    <li><a href="#">4</a></li>
                    <li><a href="#">&raquo;</a></li>
            -->
                </ul>
    {{else}}
    <p><strong>No test cases found.</strong></p>
    {{end}}
            </div> <!-- data-list -->
        </div> <!-- row -->
    </div> <!-- container fluid -->

<!-- Add modals -->
    {{template "add_case_modal" .Reqs}}
    {{template "view_case_modal" .Reqs}}
    {{template "modify_case_modal" .Reqs}}
    {{template "remove_case_modal" }}
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

    var numOfCases = parseInt({{.Num}}); // Number of cases is given by backend
    //var casesPerPage = 25;          // Number of cases displayed by page
    var casesPerPage = 3;          // Number of cases displayed by page
    // How many page are needed...
    var numOfPages = (numOfCases % casesPerPage === 0) ? (numOfCases/casesPerPage) : (numOfCases/casesPerPage+1);

    if (numOfPages > 1) {

            $('.cases_pagination').bootpag({
                total: numOfPages,
                page: 1,
                maxVisible: 5,
                leaps: true,
                firstLastUse: true,
                first: '←',
                last: '→',
                wrapClass: 'pagination',
            }).on("page", function(event, num){
//                    $(".content4").html("Page " + num); // or some ajax content loading...
            }); 

  /*      
        $('cases_pagination').append( 
                $('<li>').append( $('<a>').attr('href', '#').attr('id', 'first').append('\xab') )
        );


        $('#or (var cnt = 1; cnt <= numOfPages; cnt++) {
            $('#cases_pagination').append( $('<li>')
                                  .append( $('<a>').attr('href', '#').attr('id', 'page'+cnt)
                                  .append(cnt.toString())) );
        }

        $('#cases_pagination').append(
                $('<li>').append( $('<a>').attr('href', '#').attr('id', 'last').append('\xbb') )
        );
*/
    }

    $('#viewCaseModal').on('show.bs.modal', function (event) {

        var button = $(event.relatedTarget);     // Button that triggered the modal
        var name = button.data('casename');

        // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
        var modal = $(this)
        modal.find('.modal-title').text('The "' + name + '" Details');
        modal.find('.modal-body #casename').val(name);
        modal.find('.modal-body #hexid').val(button.data('hexid'));
        modal.find('.modal-body #caseid').val(button.data('caseid'));
        modal.find('.modal-body #priority').val(button.data('prio'));
        modal.find('.modal-body #automated').val(Boolean(button.data('auto')) ? 'Yes' : 'No');
        modal.find('.modal-body #expected').val(button.data('expect'));
        modal.find('.modal-body #notes').val(button.data('notes'));
        modal.find('.modal-body #viewreqid').val(button.data('reqid'));
        modal.find('.modal-body #description').val(button.data('desc'));
        modal.find('.modal-body #created').text(button.data('created'));
        modal.find('.modal-body #modified').text(button.data('modified'));
    })

    $('#modifyCaseModal').on('show.bs.modal', function (event) {

        var button = $(event.relatedTarget);     // Button that triggered the modal
        var name = button.data('casename');
        var created = button.data('created');
        var modified = button.data('modified');

        // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
        var modal = $(this)
        modal.find('.modal-title').text('Modify "' + name + '" Details');
        modal.find('.modal-body #casename').val(name);
        modal.find('.modal-body #hexid').val(button.data('hexid'));
        modal.find('.modal-body #caseid').val(button.data('caseid'));
        modal.find('.modal-body #priority').val(button.data('prio'));
        if (Boolean(button.data('auto'))) {
            modal.find('#automatedYes').prop('checked', true);
        } else {
            modal.find('#automatedNo').prop('checked', true);
        }
        modal.find('.modal-body #expected').val(button.data('expect'));
        modal.find('.modal-body #notes').val(button.data('notes'));
        modal.find('.modal-body #modifyreqid').val(button.data('reqid'));
        modal.find('.modal-body #description').val(button.data('desc'));
        modal.find('.modal-body #created').val(created);
        modal.find('.modal-body #modified').val(modified);
        modal.find('.modal-body #createdm').text(created);
        modal.find('.modal-body #modifiedm').text(modified);
    })

    $('#removeCaseModal').on('show.bs.modal', function (event) {

        var button = $(event.relatedTarget);     // Button that triggered the modal
        var caseid = button.data('caseid');
        var hexid = button.data('hexid');

        // Update the modal's content. We'll use jQuery here, but you could use a data binding 
        // library or other methods instead.
        var modal = $(this)
        modal.find('.modal-body #removename').text(button.data('casename'));
        modal.find('.modal-body #removeshort').text(caseid);
        modal.find('.modal-body #hexid').val(hexid);
        modal.find('.modal-body #caseid').val(caseid);

        var url = '/case/' + hexid + '/delete';
        $('#removebtn').on('click', function(e) {
             postForm('remove_case_form', url);
             $('#removeCaseModal').modal('hide');
        });
    })

    </script>
  </body>
</html>
{{end}}

{{define "add_case_modal"}}
<div class="modal fade" id="addCaseModal" tabindex="-1" role="dialog" aria-labelledby="addCaseModalLabel">
<div class="modal-dialog">
<div class="modal-content">

    <div class="modal-header">
    <div class="container-fluid">
        <div class="row">
            <h4 class="modal-title col-sm-8" id="addCaseModalLabel">Add a New Test Case</h4>
            <button type="button" class="btn btn-primary btn-sm col-sm-2" onclick="return addCase();">Add</button>
            <button type="button" class="btn btn-default btn-sm col-sm-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
      <!--<form id="add_case_form" class="form-horizontal" method="POST" onsubmit="return validateCaseForm();">-->
      <form id="add_case_form" class="form-horizontal" method="POST">
          <div class="form-group form-group-sm">
              <label for="caseid" class="col-sm-3 control-label">Case ID</label>
              <div class="col-sm-9">
                <input type="text" class="form-control" id="caseid" name="caseid" placeholder="Case ID" required>
                                 <!--  onblur="return validateInput($(this).val(), 'Test Case ID');" required> -->
              </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="casename" class="col-sm-3 control-label">Full Name</label>
                <div class="col-sm-9">
                      <input type="text" class="form-control" id="casename" name="casename" 
                                         placeholder="Full Case Name" required>
                                <!--  onblur="return validateInput($(this).val(), 'Test Case Name');" required> -->
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="priority" class="col-sm-3 control-label">Priority</label>
                <div class="col-sm-9">
                <select class="form-control" id="priority" name="priority" required>
                    <option>Low</option>
                    <option selected>Normal</option>
                    <option>High</option>
                </select>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="automated" class="col-sm-3 control-label">Automated</label>
                <div class="col-sm-offset-1 col-sm-1">
                <label class="radio-inline">
                    <input type="radio" name="automated" id="automatedYes" value="yes"> Yes
                </label>
                </div>
                <div class="col-sm-offset-1 col-sm-1">
                <label class="radio-inline">
                    <input type="radio" name="automated" id="automatedNo" value="no" checked> No
                </label>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="reqid" class="col-sm-3 control-label">Requirement ID</label>
                <div class="col-sm-9">
                <select class="form-control" id="reqid" name="reqid">
                    <option selected>Unknown</option>
                    <option>Not Applicable</option>
                {{range .}}
                    <option>{{.}}</option>
                {{end}}
                </select>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="description" class="col-sm-3 control-label">Description</label>
                <div class="col-sm-offset-9">&nbsp;</div>
                <div class="col-sm-12">
                <textarea class="form-control" rows="5" id="description" name="description"></textarea>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="expected" class="col-sm-3 control-label">Expected Result</label>
                <div class="col-sm-offset-9">&nbsp;</div>
                <div class="col-sm-12">
                <textarea class="form-control" rows="3" id="expected" name="expected"></textarea>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="notes" class="col-sm-3 control-label">Additional Notes</label>
                <div class="col-sm-offset-9">&nbsp;</div>
                <div class="col-sm-12">
                <textarea class="form-control" rows="3" id="notes" name="notes"></textarea>
                </div>
            </div>
      </form>
    </div>

<!--
    <div class="modal-footer">   
    <div class="container-fluid">
        <div class="row">
            <div class="modal-title col-sm-offset-8">&nbsp;</div>
            <button type="button" class="btn btn-primary col-sm-2" onclick="return addCase();">Add</button>
            <button type="button" class="btn btn-default col-sm-2" data-dismiss="modal">Cancel</button>
        </div> 
    </div> 
    </div> 
-->
</div>
</div>
</div>
{{end}}

{{define "view_case_modal"}}
<div class="modal fade" id="viewCaseModal" tabindex="-1" role="dialog" aria-labelledby="viewCaseModalLabel">
<div class="modal-dialog">
<div class="modal-content">

    <div class="modal-header">
    <div class="container-fluid">
        <div class="row">
            <h4 class="modal-title col-md-10" id="viewCaseModalLabel">Empty Test Case Title</h4>
            <button type="button" class="btn btn-default btn-sm col-md-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
      <form id="view_case_form" class="form-horizontal" >
          <div class="form-group form-group-sm">
              <label for="caseid" class="col-sm-3 control-label">Case ID</label>
              <div class="col-sm-9">
                <input type="text" class="form-control" id="caseid" name="caseid" readonly>
              </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="casename" class="col-sm-3 control-label">Full Name</label>
                <div class="col-sm-9">
                  <input type="text" class="form-control" id="casename" name="casename" readonly>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="priority" class="col-sm-3 control-label">Priority</label>
                <div class="col-sm-9">
                  <input type="text" class="form-control" id="priority" name="priority" readonly>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="automated" class="col-sm-3 control-label">Automated</label>
                <div class="col-sm-9">
                  <input type="text" class="form-control" id="automated" name="automated" readonly>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="reqid" class="col-sm-3 control-label">Requirement ID</label>
                <div class="col-sm-9">
                  <input type="text" class="form-control" id="viewreqid" name="reqid" readonly>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="description" class="col-sm-3 control-label">Description</label>
                <div class="col-sm-offset-9">&nbsp;</div>
                <div class="col-sm-12">
                  <textarea class="form-control" rows="5" id="description" name="description" readonly></textarea>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="expected" class="col-sm-3 control-label">Expected Result</label>
                <div class="col-sm-offset-9">&nbsp;</div>
                <div class="col-sm-12">
                <textarea class="form-control" rows="3" id="expected" name="expected" readonly></textarea>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="notes" class="col-sm-3 control-label">Additional Notes</label>
                <div class="col-sm-offset-9">&nbsp;</div>
                <div class="col-sm-12">
                <textarea class="form-control" rows="3" id="notes" name="notes" readonly></textarea>
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


{{define "modify_case_modal"}}
<div class="modal fade" id="modifyCaseModal" tabindex="-1" role="dialog" aria-labelledby="modifyCaseModalLabel">
<div class="modal-dialog">
<div class="modal-content">

    <div class="modal-header">
    <div class="container-fluid">
        <div class="row">
            <h4 class="modal-title col-sm-8" id="modifyCaseModalLabel">Empty Test Case Title</h4>
            <button type="button" class="btn btn-primary btn-sm col-sm-2" 
                    onclick="modifyCase('modify_case_form', $('#hexid').val()); $('#modifyCaseModal').modal('hide');">
                    Modify
            </button>
            <button type="button" class="btn btn-default btn-sm col-sm-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
      <form id="modify_case_form" class="form-horizontal" onsubmit="return validateCaseForm();">
            <input type="hidden" id="hexid" name="hexid">
          <div class="form-group form-group-sm">
              <label for="caseid" class="col-sm-3 control-label">Case ID</label>
              <div class="col-sm-9">
                <input type="text" class="form-control" id="caseid" name="caseid"
                                   onblur="return validateCaseID($(this).val());" required>
              </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="casename" class="col-sm-3 control-label">Full Name</label>
                <div class="col-sm-9">
                  <input type="text" class="form-control" id="casename" name="casename"
                                   onblur="return validateCaseName($(this).val());"required>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="priority" class="col-sm-3 control-label">Priority</label>
                <div class="col-sm-9">
                <select class="form-control" id="priority" name="priority">
                    <option>Low</option>
                    <option>Normal</option>
                    <option>High</option>
                </select>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="automated" class="col-sm-3 control-label">Automated</label>
                <div class="col-sm-offset-1 col-sm-1">
                <label class="radio-inline">
                    <input type="radio" name="automated" id="automatedYes" value="yes"> Yes
                </label>
                </div>
                <div class="col-sm-offset-1 col-sm-1">
                <label class="radio-inline">
                    <input type="radio" name="automated" id="automatedNo" value="no"> No
                </label>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="reqid" class="col-sm-3 control-label">Requirement ID</label>
                <div class="col-sm-9">
                <select class="form-control" id="modifyreqid" name="reqid">
                    <option selected>Unknown</option>
                    <option>Not Applicable</option>
                {{range .}}
                    <option>{{.}}</option>
                {{end}}
                </select>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="description" class="col-sm-3 control-label">Description</label>
                <div class="col-sm-offset-9">&nbsp;</div>
                <div class="col-sm-12">
                  <textarea class="form-control" rows="5" id="description" name="description"></textarea>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="expected" class="col-sm-3 control-label">Expected Result</label>
                <div class="col-sm-offset-9">&nbsp;</div>
                <div class="col-sm-12">
                <textarea class="form-control" rows="3" id="expected" name="expected"></textarea>
                </div>
            </div>
            <div class="form-group form-group-sm">
                <label for="notes" class="col-sm-3 control-label">Additional Notes</label>
                <div class="col-sm-offset-9">&nbsp;</div>
                <div class="col-sm-12">
                <textarea class="form-control" rows="3" id="notes" name="notes"></textarea>
                </div>
            </div>
            <div class="form-group form-group-sm small">
                <input type="hidden" name="created" id="created">
                <input type="hidden" name="modified" id="modified">
                <div class="col-sm-2 text-right"><strong>Created:</strong></div>
                <div id="createdm" name="createdm" class="col-sm-3 text-left">Error</div>
                <div class="col-sm-3 text-right"><strong>Modified:</strong></div>
                <div id="modifiedm" name="modifiedm" class="col-sm-3 text-left">Error</div>
            </div>
      </form>
    </div>
</div>
</div>
</div>
{{end}}

{{define "remove_case_modal"}}
<div class="modal fade" id="removeCaseModal" tabindex="-1" role="dialog" aria-labelledby="removeCaseModalLabel">
<div class="modal-dialog">
<div class="modal-content">

    <div class="modal-header">
    <div class="container-fluid">
        <div class="row">
            <h4 class="modal-title col-sm-8" id="removeCaseModalLabel">Remove Test Case</h4>
            <button type="button" class="btn btn-primary btn-sm col-sm-2" id="removebtn">Remove</button>
            <button type="button" class="btn btn-default btn-sm col-sm-2" data-dismiss="modal">Cancel</button>
        </div> <!-- row -->
    </div> <!-- container-fluid -->
    </div> <!-- modal-header -->

    <div class="modal-body">
    <p> Would you really like to remove the test case '<span id="removename"></span>
        [<span id="removeshort"></span>]'?</p>
    <form id="remove_case_form">
        <input type="hidden" name="hexid" id="hexid" />
        <input type="hidden" name="casename" id="casename" />
    </form>
    </div>
</div>
</div>
</div>
{{end}}

