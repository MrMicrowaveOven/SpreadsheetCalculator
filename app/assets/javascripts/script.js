function evaluateSpreadsheet() {
  var spreadsheetInstructions = getInput();
  makeRequest(spreadsheetInstructions);
}

function getInput() {
  return $("#inputText")[0].value;
}

function makeRequest(spreadsheetInstructions) {
  $.ajax({
    type: "POST",
    url: "/spreadsheets",
    data: {spreadsheet: {instructions: spreadsheetInstructions}},
    dataType: "json",
    success: function (res) {
        console.log(res);
    },
    error: function (xhr, status, error) {
      console.log(xhr.responseText);
      // console.log(xhr);
      // console.log(status);
      // console.log(error);
    }
  });
}
