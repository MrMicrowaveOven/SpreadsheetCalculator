# UpCounsel Coding Challenge

Provided a basic Ruby "spreadsheet calculator" script, refactor and convert into a basic Rails application. More information about the spreadsheet calculator is included toward the bottom of these instructions.

### Overview

1. Build a page that will accept input for the spreadsheet calculator in a single `textarea` tag. With the first line as the table size, and then one cell value per line.
2. On form submission, the page will display the output similar to the results of running the script in the console. This includes the alerting of cyclic dependencies and any other input errors
3. Upon successful submission, store in a database

### Minimum requirements

* Server-side input validation
* Properly handle cyclic dependency exceptions
* Use [Bootstrap](http://getbootstrap.com/) to make the UI/UX responsive
* Use AJAX to handle form submission and result
* Store submissions in a database
* Write unit tests (RSpec, MiniTest, TestUnit, etc.)

### Bonus achievements

* Implement client-side input validation
* Build a "spreadsheet-like" interface
* Use your favorite JavaScript MV\* framework on the front-end.

### To deliver your results

1. Commit your web application code to a repository we create for you on GitHub
2. If necessary, include instructions in a readme for how to use

## Spreadsheet Calculator Explained

The script for the spreadsheet calculator (`spreadsheet_calculator.rb`) accepts input in the form of a table "definition" from stdin, recursively evaluates all of the cells, and writes to stdout.

The table "definition" is defined as follows:

* First line: two integers defining the width and height of the table (n, m)
* n*m lines each containing an expression which is the value of the corresponding cell
* The cell values are in Reverse Polish notation

<table>
  <tr>
    <td>Example Input</td>
    <td>Expected Output</td>
  </tr>
  <tr>
    <td>
      3 2<br>
      B2<br>
      4 3 &ast;<br>
      C2<br>
      A1 B1 / 2 +<br>
      13<br>
      B1 A2 / 2 &ast;
    </td>
    <td>
      3 2<br>
      13.00000<br>
      12.00000<br>
      7.78378<br>
      3.08333<br>
      13.00000<br>
      7.78378
    </td>
  </tr>
</table>


A visual representation of the input above might look like this:

<table>
  <tr>
    <td></td>
    <td>A</td>
    <td>B</td>
    <td>C</td>
  </tr>
  <tr>
    <td>1</td>
    <td>B2</td>
    <td>4 3 &ast;</td>
    <td>C2</td>
  </tr>
  <tr>
    <td>2</td>
    <td>A1 B1 / 2 +</td>
    <td>13</td>
    <td>B1 A2 / 2 &ast;</td>
  </tr>
</table>
