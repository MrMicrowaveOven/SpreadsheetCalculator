class Spreadsheet < ApplicationRecord
    # VALID_INSTRUCTIONS_REGEX =
    validates :instructions, presence: true,
    format: { with: /\A([0-9]+\s[0-9]+)$(((\n^(([A-Z]+)([0-9]+)|[0-9]+)((\s(([A-Z]+)([0-9]+)|[0-9]+|[-+*\/]+))*))*))\Z/, message: "improper format" }
    # validate do
    #   check_table_count
    # end

    def check_table_count
      # return false if !self.valid?
      spreadsheet_layout = self.instructions.split("\n").first
      spreadsheet_mults = spreadsheet_layout.split
      spreadsheet_size = spreadsheet_mults[0].to_i * spreadsheet_mults[1].to_i
      raise "incorrect spreadsheet size" if self.instructions.split("\n").length - 1 != spreadsheet_size
      true
    end
end
