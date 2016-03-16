/*
 * cases.js - custom JS code dealing with the Cases application
 *
 */

// send a HTTP request (GET, POST, DELETE, PUT...)
function sendRequest(method, url, data) {

    var req = new XMLHttpRequest();
    req.open(method, url, true);
    req.send(data);
}

// View an item with given DB ID: send a HTTP GET request to appropriate URL. 
function viewItem(item, id) {
    var url = "/" + item + "/" + id;
    sendRequest('GET', url, "");
    window.location.href = url;
}

// Delete an item with given DB ID: send a HTTP DELETE request to appropriate URL.
function deleteReq(name, id) {

    //if (!(confirm('Do you really want to delete requirement "' + name + '"?'))) { return; }
    var url = '/requirement/' + id + '/delete';
    sendRequest('POST', url, null);
    $("#removeReqModal").modal("hide");
}


// Delete an item with given DB ID: send a HTTP DELETE request to appropriate URL.
function deleteCase(name, id) {

    if (!(confirm('Do you really want to delete test case "' + name + '"?'))) { return; }
    var url = '/case/' + id + '/delete';
    sendRequest('POST', url, null);
}

//
function addCase() {

    //if ( $('#add_case_form')[0].checkValidity() && $('#add_case_form')[1].checkValidity() ) {
    if(validateCaseForm()) {
        postForm("add_case_form", "/case");
        $("#addCaseModal").modal("hide");
        return true;
    }
    return false;
}

//
function modifyReq(form_id, id) {

    var url = "/requirement/" + id + '/put';
    postForm(form_id, url);
}

// Modify an item with given DB ID: send a HTTP PUT request to appropriate URL. 
function modifyCase(form_id, id) {

    // create an URL with _method attached
    var url = "/case/" + id + '/put';

    postForm(form_id, url);
}

// submit form as POST to a given URL
function postForm(form_id, url) {

    var form = document.getElementById(form_id);
    form.setAttribute("action", url)
    form.setAttribute("method", "post")
    form.submit();
}

// helper function
var isEmptyText = function(txt) {
    if (!txt) {
        return true;
    }
    return false;
}

//
function validateInput(txt, name) {
    if (!txt) { 
        alert("The '" + name + "' is mandatory field. Must not be left empty."); 
        return false;
    }
    return true;
}

//
function validateCaseForm() {
    if (!validateInput($("#caseid").val(), "Test Case ID"))  {
        return false
    }
    if  (!validateInput($("#casename").val(), "Test Case Name")) {
        return false
    }
    return true
}

function validateReqForm(frm) {
    if (validateInput($("#reqid").val(), "Requirement Short Name"))  {
        return false
    }
    if  (!validateInput($("#reqname").val(), "Requirement Name")) {
        return false
    }
    return true
}

/*
function validatePasswordChange() {

    var old = document.getElementById("oldpassword").value;
    var pwd = document.getElementById("newpassword").value;
    var pwd2 = document.getElementById("newpassword2").value;

    if (!checkPasswords(pwd, pwd)) { return false; }

    return true;
}
*/

// check
/*
function checkPasswords(pwd1, pwd2) {
    var status = false;

    if (pwd1 === pwd2) { return true; }

    return status;
}
*/
