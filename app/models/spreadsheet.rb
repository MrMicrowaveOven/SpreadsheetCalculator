class Spreadsheet < ApplicationRecord
  ALPHABET = ('A'..'Z').to_a
  REF_REGEX = /^([A-Z]+)([0-9]+)$/
    # VALID_INSTRUCTIONS_REGEX =
  validates :instructions, presence: true,
  format: { with: /\A([0-9]+\s[0-9]+)$(((\n^(([A-Z]+)([0-9]+)|[0-9]+)((\s(([A-Z]+)([0-9]+)|[0-9]+|[-+*\/]+))*))*))\Z/, message: "improper format" }

  def check_table_count
    # return false if !self.valid?
    spreadsheet_layout = self.instructions.split("\n").first
    spreadsheet_mults = spreadsheet_layout.split
    spreadsheet_size = spreadsheet_mults[0].to_i * spreadsheet_mults[1].to_i
    if self.instructions.split("\n").length - 1 != spreadsheet_size
      return false
    end
    true
  end

  def evaluate_spreadsheet
    instructions = self.instructions.split("\n")
    size = instructions.shift
    row_size = size.split.first.to_i

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
    end

    # output final result
    # @cells.values.each do |val|
    #   puts sprintf('%.5f', val)
    # end
    @cells
  end

  private

  def evaluate_cell(loc, value, cells_traversed = [loc])
    evaluation = []

    value.to_s.split.each do |term|

      if reference_match = term.match(REF_REGEX)
        # It's a location reference
        if cells_traversed.include? term
          cells_traversed << term
          raise "cyclic dep detectected. trace: #{cells_traversed.join(' >> ')}"
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
