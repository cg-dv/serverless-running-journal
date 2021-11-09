function deleteAPI(runid) {
    //e.preventDefault();
    var URL = "https://pjj72ktn29.execute-api.us-east-1.amazonaws.com/prod/CRUDList";
   
    var request = {
      "operation": "delete",
      "tableName": "Runs",
      "payload": {
        "Key": {
            "RunId": runid 
        }
      }
    };
    
    $.ajax({
      type: "POST",
      url: "https://pjj72ktn29.execute-api.us-east-1.amazonaws.com/prod/CRUDList",
      dataType: "json",
      crossDomain: "true",
      contentType: "application/json; charset=utf-8",
      data: JSON.stringify(request),


      success: function (data) {
        //clear form and show a success message
        alert("Successful Form Submission");
        document.getElementById("run-log").reset();
    location.reload();
      },
      error: function (data) {
        //show an error message
        alert("Form Submission Error");
      }});
  }
