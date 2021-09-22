function deleteAPI(e) {
    e.preventDefault();
    var URL = "https://2cgj2wj6na.execute-api.us-east-1.amazonaws.com/prod/CRUDList";
    
    var request = {
      "operation": "delete",
      "tableName": "Runs",
      "payload": {
        "Key": {
            "RunId": "runid-7aa28c9604b088",
            "Date": "2021-09-03"
        }
      }
    };
        
    $.ajax({
      type: "POST",
      url: "https://2cgj2wj6na.execute-api.us-east-1.amazonaws.com/prod/CRUDList",
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
