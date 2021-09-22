function submitToAPI(e) {
    e.preventDefault();
    var URL = "https://2cgj2wj6na.execute-api.us-east-1.amazonaws.com/prod/CRUDList";

    var distancere = /[0-9]{1}/;
    if (!distancere.test($("#distance-input").val())) {
        alert("Please enter distance");
    return;
    }

    var runId = "runid-" + Math.random().toString(16).slice(2)
    var date = $("#date-input").val();
    var distance = $("#distance-input").val();
    var runLocation = $("#location-input").val();
    var notes = $("#notes-input").val();
    var request = {
      "operation": "create",
      "tableName": "Runs",
      "payload": {
        "Item": {
          "RunId": runId,
          "Date": date,
          "Distance": distance,
          "Location": runLocation,
          "Notes": notes 
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


      success: function () {
        //clear form and show a success message
        alert("Successful Form Submission");
        document.getElementById("input-form").reset();
    location.reload();
      },
      error: function () {
        //show an error message
        alert("Form Submission Error");
      }});
  }
