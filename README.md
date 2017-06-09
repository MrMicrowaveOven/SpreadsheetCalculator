# Spreadsheet Calculator

## The Challenge

Make a Spreadsheet Evaluator that will allow mathematical calculations (Reverse Polish notation) and references to other cells.  More details below my completion notes.

# Benjamin's Progress Notes

## Initial Questions

1. Do I make a full Rails application with .erb front-end?  Or just make a Rails API, which is accessed via JavaScript on HTML pages?  The two words that stood out to me in the instructions were `Bootstrap` and `AJAX`.  While Bootstrap is generally a front-end library (meaning JS), there is a Bootstrap Gem for Rails.  Mind you, the front-end library is what was linked in the instructions, so I'm guessing that's what they want.  Finally, AJAX literally has JavaScript in the acronym, so I'm guessing that's what they want.  Rails API it is!

2. What kind of automated testing do I want to use?  I'm familiar with RSpec, and I love it.  Easy to use, easy to read.  However, Rails has that built-in testing library TestUnit that I've always wanted to try.  I figured I'd start with TestUnit since there's no installation or anything involved, and make the switch if it really sucks.

3. How do I want things stored in the database?  Instructions are given in string format, then evaluated as a JSON.  Since the objects are given as a string, then

## Rails Setup

Super simple, always is.  It was only going to involve one page, so I set the New Spreadsheet view to the root.  I implemented Create (the only one the client will access), along with Index and Destroy.  This is so I can check the database via Postman, and purge it easily if need be.  By the way the Destroy is more like a Destroy-All, since I figured I wouldn't need to destroy individual Spreadsheets.

One bit that made the Rails implementation a bit awkward was the amount of work being done to the input.  The API receives a set of instructions via a string, validates it in several ways (table size, no odd symbols, etc.), evaluates it, and if all goes well FINALLY stores it in the database.  This is a lot of logic, so I decided the Model was the best place to put it.  We'll pass the `instructions` into the instantiation, then call the validations on the spreadsheet.  If everything passes, we'll call evaluation on it.  If that succeeds, we'll attempt to save it.  If that succeeds, we return the result and let the front-end worry about the rest.  While I generally try to keep object logic outside of the controller (and inside the model, where it belongs), I figured having the controller walk through validation, evaluation, then creation wasn't pushing the boundary too much.

### Error Handling

Validations and evaluations eventually let to 4 different errors.
1. Random symbols that the system doesn't know what to do with.
2. Incorrect table size.
3. Cyclic error: References creating a cycle.
4. Reference error: Referring to a cell that isn't in the table.

I made these each to respond with unique JSONS so the front-end could display the errors appropriately.  There is one more error I can think of that I'll handle later down the line.
1. Incorrct Reverse Polish Notation: Placing symbols before numbers and so on.  This can probably be handled in `evaluate_cell` once I have the chance.

### Test Unit

Testing made all of this very straight-forward.  Having said that, I don't think I'm likely to choose TestUnit again.  While it came ready-to-go with Rails, and references were easy, there were some things they didn't really think of.  Grouping tests together, while possible, is not part of the design (not in the docs).  I had to make separate classes (thanks StackOverflow!).  It has an automatic stubbed database with sample data, so you don't need to set it up yourself.  However, this makes it awkward to test things like `index`, since it's randomly generated.  Even if it involves more work, I'd rather stub the database myself and have more control over its testing.

## Front-end

Bootstrap is always a lot of fun.  There's a great deal of "Okay, now I need a button.  Ooooh, I'll use that one!", which was quick and easy.  I stuck with the simple two-column format since I figured that would make it easy to show input on one side, and the graph on the other.  Added a simple button which took the text input and stuck it in a POST request, and threw the response into a table.  BOOM, done.  I even found some quick error message displays to show the user what went wrong.

## Where the Project is Now

The project is now live, and can be found [here](https://spreadsheet-calculator.herokuapp.com/).  While the minimum requirements are done, I still want to handle that last validation and maybe throw in some bonus points.  Making a spreadsheet-like interface would probably make client-side validation much easier (working with cells, not the whole spreadsheet as a string).

If you would like to view the database, it can be found [here](https://spreadsheet-calculator.herokuapp.com/spreadsheets).  To purge, just send a DELETE request to https://spreadsheet-calculator.herokuapp.com/spreadsheets.

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
