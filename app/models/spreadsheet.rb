class Spreadsheet < ApplicationRecord
  ALPHABET = ('A'..'Z').to_a
  REF_REGEX = /^([A-Z]+)([0-9]+)$/
    # VALID_INSTRUCTIONS_REGEX =
  validates :instructions, presence: true,
  format: { with: /\A([0-9]+\s[0-9]+)$(\n^[0-9]+\.[0-9]{5})*\Z/, message: "improper format" }

  def validate_input
    if !check_input_format
      return {Error: "Inproper input format"}
    elsif !check_table_count
      return {Error: "Incorrect table dimensions"}
    end
    return "validated"
  end

  def check_input_format
    !self.instructions.match(/\A([0-9]+\s[0-9]+)$(((\n^(([A-Z]+)([0-9]+)|[0-9]+)((\s(([A-Z]+)([0-9]+)|[0-9]+|[-+*\/]+))*))*))\Z/).to_s.empty?
  end

  def check_table_count
    spreadsheet_array = self.instructions.split("\n")
    spreadsheet_dimensions = spreadsheet_array.first
    spreadsheet_cells = spreadsheet_array[1 .. -1]
    spreadsheet_dims_array = spreadsheet_dimensions.split
    num_cells = spreadsheet_dims_array[0].to_i * spreadsheet_dims_array[1].to_i

    num_cells == spreadsheet_cells.length
  end

  def evaluate_spreadsheet
    @cyclic_error = false
    instructions = self.instructions.split("\n")
    size = instructions.shift
    row_size = size.split.first.to_i
    num_rows = size.split.last.to_i

    @cells = {}

    # @cells is a hash containing all references
    # {
      # A1: 5,
      # B2: 'A1'
    # }

    instructions.each_slice(row_size).with_index do |row, row_number|
      row.each_with_index do |value, col_number|
        location = [ALPHABET[col_number], row_number + 1].join
        @cells[location] = value
      end
    end

    # go through and evaluate each cell
    @cells.each do |loc, value|
      @cells[loc] = evaluate_cell(loc, value).round(5)
      return @cyclic_error if @cyclic_error
    end

    # output final result
    output_string = "#{row_size} #{num_rows}"
    @cells.values.each do |val|
      output_string += "\n"
      output_string += sprintf('%.5f', val)
    end
    @cyclic_error || output_string
  end

  private

  def evaluate_cell(loc, value, cells_traversed = [loc])
    evaluation = []

    value.to_s.split.each do |term|

      if reference_match = term.match(REF_REGEX)
        # It's a location reference
        if cells_traversed.include? term
          cells_traversed << term
          @cyclic_error = "cyclic dep detectected. trace: #{cells_traversed.join(' >> ')}"
          return
          # raise "cyclic dep detectected. trace: #{cells_traversed.join(' >> ')}"
        else
          going_deeper = cells_traversed.clone
          going_deeper << term
          result = evaluate_cell(loc, @cells[term], going_deeper).to_f

          # cache result so we don't need to calculate again
          @cells[term] = result

          evaluation << result
        end

      elsif ["-", "/", "*", "+", "**"].include?(term)
        # It's an operation
        operands = evaluation.pop(2)
        evaluation << operands[0].send(term, operands[1])
      else
        # It's a number
        evaluation << term.to_f
      end
    end

    return evaluation.first
  end
end
