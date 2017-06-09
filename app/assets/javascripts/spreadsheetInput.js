document.addEventListener("turbolinks:load", function() {
  $(".size-selector").on("change", function() {
    var numColumns = $("#numColumns")[0].value;
    var numRows = $("#numRows")[0].value;
    $("#inputColumnHeader").empty();
    $("#inputColumnHeader").html("<th class='rowLabel' scope='row'>#</th>");
    $("#inputRows").empty();
    for (var columnIndex = 0; columnIndex < numColumns; columnIndex++) {
      $("#inputColumnHeader").append("<th class='columnLabel'>" + ALPHABET[columnIndex] + "</th>");
    }
    var currentRow;
    for (var rowIndex = 1; rowIndex <= numRows; rowIndex++) {
      $("#inputRows").append(
        '<tr id="inputRow' + rowIndex
        + '"><th class="rowLabel" scope="row">' + rowIndex
        + '</th></tr>'
      );
      currentRow = $("#inputRow" + rowIndex);
      for (var columnIndex = 0; columnIndex < numColumns; columnIndex++) {
        currentRow.append(
          '<td><input type="text" class="cellInput" size="5px"></td>"'
        );
      }
    }
  });
});
