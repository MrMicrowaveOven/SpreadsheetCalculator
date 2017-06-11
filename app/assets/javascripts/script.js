var ALPHABET = buildColumns();

function evaluateSpreadsheet() {
  var spreadsheetInstructions = getInput();
  if (spreadsheetInstructions === "emptyCells") {
    showAlert("empty_cell_alert");
  } else {
    makeRequest(spreadsheetInstructions);
  }
}

function getInput() {
  if ($("#spreadsheet-tab").attr("class") === "active") {
    var values = [];
    var numColumns = $("#numColumns")[0].value;
    var numRows = $("#numRows")[0].value;
    var size = numColumns + " " + numRows;
    var emptyCells;
    $(".cellInput").toArray().forEach(function(cell) {
      if (cell.value === "") {
        $(cell).addClass("invalid");
        emptyCells = true;
      }
      values.push(cell.value);
    });
    var instructions = size + "\n" + values.join("\n");
    if (emptyCells) {
      return "emptyCells";
    } else {
      return instructions;
    }
  } else if ($("#textbox-tab").attr("class") === "active") {
    return $("#inputText")[0].value;
  }
}

function makeRequest(spreadsheetInstructions) {
  $.ajax({
    type: "POST",
    url: "/spreadsheets",
    data: {spreadsheet: {instructions: spreadsheetInstructions}},
    dataType: "json",
    success: function (res) {
      if (res.error) {
        showAlert(res.error);
      } else {
        $('.alert').fadeOut();
        displayResults(res);
      }
    },
    error: function (xhr, status, error) {
      console.log(xhr);
      console.log(status);
      console.log(error);
    }
  });
}
function showAlert(errorText) {
  $("#columnHeader").empty();
  $("#rows").empty();
  $(".alert").fadeOut();
  if (errorText.match(/Improper input format/)) {
    $("#improper_input_alert").slideDown();
  } else if (errorText.match(/Incorrect table dimensions/)) {
    $("#incorrect_dims_alert").slideDown();
  } else if (errorText.match(/Cyclic/)) {
    $("#cell_cycle").html(
      errorText.match(/([A-Z]+[0-9]+)(\s>>\s[A-Z]+[0-9])*/)[0]
    );
    $("#cyclic_alert").slideDown();
  } else if (errorText.match(/Reference/)) {
    $("#reference_error_cell").html(
      errorText.match(/[A-Z]+[0-9]+/)[0]
    );
    $("#reference_error_alert").slideDown();
  } else if (errorText.match(/Notation/)) {
    $("#polish_notation_error_alert").slideDown();
  } else if (errorText === "empty_cell_alert") {
    $("#empty_cell_alert").slideDown();
  }
  setTimeout(function() {
    $(".alert").fadeOut();
  }, 5000);
}

function displayResults(res) {
  var table = $("#spreadsheet_results");
  var tableLayout = res.instructions.split("\n");
  var tableDimensions = tableLayout.shift().split(" ");
  var numColumns = tableDimensions[0];
  var numRows = tableDimensions[1];

  $("#columnHeader").empty();
  $("#rows").empty();

  $("#columnHeader").append("<th class='rowLabel' scope='row'>#</th>");

  for (var columnIndex = 0; columnIndex < numColumns; columnIndex++) {
    $("#columnHeader").append(
      "<th class='columnLabel'>" + ALPHABET[columnIndex] + "</th>"
    );
  }
  var currentRow;
  var cellValue;
  for (var rowIndex = 1; rowIndex <= numRows; rowIndex++) {
    $("#rows").append(
      '<tr id="row' + rowIndex
      + '"><th class="rowLabel" scope="row">' + rowIndex
      + '</th></tr>'
    );
    currentRow = $("#row" + rowIndex);
    for (var columnIndex = 0; columnIndex < numColumns; columnIndex++) {
      cellValue = tableLayout.shift();
      currentRow.append("<td class=cellContents>" + cellValue + "</td>");
    }
  }
}

function buildColumns() {
  var alphabet = ["A","B", "C", "D", "E", "F", "G", "H",
    "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
    "S", "T", "U", "V", "W", "X", "Y", "Z"];

  var alphabetPlex = ["A","B", "C", "D", "E", "F", "G", "H",
    "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
    "S", "T", "U", "V", "W", "X", "Y", "Z"];
  alphabet.forEach(function(firstLetter) {
    alphabet.forEach(function(secondLetter) {
      alphabetPlex.push(firstLetter + secondLetter);
    });
  });
  return alphabetPlex;
}
