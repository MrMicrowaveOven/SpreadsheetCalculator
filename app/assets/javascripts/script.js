var ALPHABET = ["A","B", "C", "D", "E", "F", "G", "H",
  "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
  "S", "T", "U", "V", "W", "X", "Y", "Z"];

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
      // console.log(res);
      displayResults(res);
    },
    error: function (xhr, status, error) {
      console.log(xhr.responseText);
      // console.log(xhr);
      // console.log(status);
      // console.log(error);
    }
  });
}

function displayResults(res) {
  var table = $("#spreadsheet_results");
  var tableLayout = res.instructions.split("\n");
  var tableDimensions = tableLayout.shift().split(" ");
  var numColumns = tableDimensions[0];
  var numRows = tableDimensions[1];

  $("#columnHeader").empty();
  $("#rows").empty();

  $("#columnHeader").append("<th>#</th>");

  for (var columnIndex = 0; columnIndex < numColumns; columnIndex++) {
    $("#columnHeader").append("<th>" + ALPHABET[columnIndex] + "</th>");
  }
  var currentRow;
  var cellValue;
  for (var rowIndex = 1; rowIndex <= numRows; rowIndex++) {
    $("#rows").append(
      '<tr id="row' + rowIndex
      + '"><th scope="row">' + rowIndex
      + '</th></tr>'
    );
    currentRow = $("#row" + rowIndex);
    for (var columnIndex = 0; columnIndex < numColumns; columnIndex++) {
      cellValue = tableLayout.shift();
      currentRow.append("<td>" + cellValue + "</td>");
    }
  }
}
