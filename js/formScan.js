function scanFromAPI(e) {
    e.preventDefault();
    var URL = "https://aqlh969bj8.execute-api.us-east-1.amazonaws.com/prod/CRUDList";

    var request = {
      "operation": "list",
      "tableName": "Runs",
      "payload": {
      }
    };
   
    $.ajax({
      type: "POST",
      url: "https://aqlh969bj8.execute-api.us-east-1.amazonaws.com/prod/CRUDList",
      dataType: "json",
      crossDomain: "true",
      contentType: "application/json; charset=utf-8",
      data: JSON.stringify(request),


      success: function (data) {
        //clear form and show a success message
        alert("Successful Form Submission");
        
        if (data.Items.length < 1) {
            alert("No data in run log.  Submit new entries and refresh page to view entries here.");
        }
        
        for (let i = 0; i < data.Items.length; i++) {
            const title = document.createElement('h2');
            const p1 = document.createElement('p');
            const p2 = document.createElement('p');
            const p3 = document.createElement('p'); 
            const p4 = document.createElement('p');
            const b1 = document.createElement('button');
            const b2 = document.createElement('button');
            const br = document.createElement('br');
            
            title.textContent = "Run ID: " + data.Items[i].RunId;
            p1.textContent = "Date: " + data.Items[i].Date;
            p2.textContent = "Distance: " + data.Items[i].Distance;
            p3.textContent = "Location: " + data.Items[i].Location;
            p4.textContent = "Notes: " + data.Items[i].Notes;
            b1.innerHTML = "Update";
            //b1.setAttribute('onClick', formUpdate(event, data.Items[i].RunId));
            b2.type = "button";
            b2.innerHTML = "Delete";
            b2.setAttribute("id", "delete" + i);
            b2.addEventListener('click', function(){
                deleteAPI(data.Items[i].RunId);
            });
            
            const form = document.getElementById("run-log");
            form.appendChild(title);
            form.appendChild(p1);
            form.appendChild(p2);
            form.appendChild(p3);
            form.appendChild(p4);
            form.appendChild(b1);
            form.appendChild(b2);
            form.appendChild(br);
            } 
        alert("data loaded");
        //document.getElementById("run-log").reset();
    //location.reload();
      },
      error: function () {
        //show an error message
        alert("Form Submission Error");
      }});
  }
