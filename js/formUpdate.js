function formUpdate() {
    //e.preventDefault();
    var URL = "https://69mu9xokbh.execute-api.us-east-1.amazonaws.com/prod/CRUDList";

    var distancere = /[0-9]{1}/;
    if (!distancere.test($("#distance-input").val())) {
        alert("Please enter distance");
    return;
    }

    var runId = $("#runid-input").val();
    var date = $("#date-input").val();
    var distance = $("#distance-input").val();
    var runLocation = $("#location-input").val();
    var notes = $("#notes-input").val();
    var request = {
      "operation": "update",
      "tableName": "Runs",
      "payload": {
        "Key": {
          "RunId": runId
         },
        "UpdateExpression": "set #Date = :date, Distance = :distance, #Location = :runLocation, Notes = :notes",
        "ExpressionAttributeNames": {
            "#Date": "Date",
            "#Location": "Location"
        },
        "ExpressionAttributeValues": {
            ":date": date,
            ":distance": distance,
            ":runLocation": runLocation,
            ":notes": notes
        }
      }
    };
   
    $.ajax({
      type: "POST",
      url: "https://69mu9xokbh.execute-api.us-east-1.amazonaws.com/prod/CRUDList",
      dataType: "json",
      crossDomain: "true",
      contentType: "application/json; charset=utf-8",
      data: JSON.stringify(request),


      success: function () {
        //clear form and show a success message
        alert("Successful Form Submission");
        document.getElementById("update-form").reset();
    location.reload();
      },
      error: function () {
        //show an error message
        alert("Form Submission Error");
      }});
  }
