class Spreadsheet < ApplicationRecord
    validates :instructions, presence: true,
    format: { with: /\A([0-9]+\s[0-9]+)$(((\n^(([A-Z]+)([0-9]+)|[0-9]+)((\s(([A-Z]+)([0-9]+)|[0-9]+|[-+*\/]+))*))*))\Z/, message: "improper format" }
end
