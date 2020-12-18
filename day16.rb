require './utils'

def string_to_range(str)
  parts = str.split("-")
  (parts[0].to_i..parts[1].to_i)
end

def matches_rules?(field, rule_ranges)
  matching = rule_ranges.find { |rule| rule[0].include?(field) || rule[1].include?(field) }
  rule_ranges.any? { |rule| (rule[0].include?(field) || rule[1].include?(field)) }
end

def day1
  lines = Utils.input_read(16)
  parts = lines.join('').split("\n\n")

  rules = parts[0]
  nearby_tickets = parts[2].gsub("nearby tickets:\n", "").split("\n").map { |t| t.split(",").map(&:to_i) }

  rule_ranges = rules.split("\n").map { |r| r.split(":").last.split(" or ").map { |sr| string_to_range(sr) } }

  invalid_values = nearby_tickets.flatten.reject { |field| matches_rules?(field, rule_ranges) }
  puts invalid_values.inject(0, :+)
end

day1

def matching_rules(field, rule_ranges)
  rule_ranges.select { |rule| (rule[0].include?(field) || rule[1].include?(field)) }
end

def one_per_column?
end

def day2
  lines = Utils.input_read(16)
  parts = lines.join('').split("\n\n")

  rules = parts[0]
  nearby_tickets = parts[2].gsub("nearby tickets:\n", "").split("\n").map { |t| t.split(",").map(&:to_i) }

  rule_ranges = rules.split("\n").map { |r| r.split(":").last.split(" or ").map { |sr| string_to_range(sr) }.push(r.split(":").first) }

  valid_tickets = nearby_tickets.map { |fields| fields.map { |field| matching_rules(field, rule_ranges) } }.reject { |fields| fields.any?(&:empty?)}

  rows = Array.new(valid_tickets[0].length) { Array.new }

  valid_tickets.each do |fields|
    fields.each_with_index do |field, idx|
      rows[idx].concat field.map { |rule| rule[2]}
    end
  end

  count_of_values = rows.map { |r| r.inject({}) { |accum, v| accum[v] ? accum[v] += 1 : accum[v] = 1; accum } }
  distinct_rules = rule_ranges.map { |r| r[2] }

  identified_columns = {}

  while identified_columns.keys.length != distinct_rules.length
    count_of_values.each_with_index do |column, index|
      valid_keys = (column.keys - identified_columns.values).filter do |key|
        column[key] == valid_tickets.length
      end
      if valid_keys.length == 1
        identified_columns[index] = valid_keys[0]
      end
    end
  end

  my_ticket_parsed = parts[1].gsub("your ticket:\n", "").split(",")

  my_ticket_with_rules = my_ticket_parsed.each_with_index.map { |part, idx| { rule: identified_columns[idx], value: part.to_i} }

  pp my_ticket_with_rules.filter { |p| p[:rule].include? "departure" }.inject(1) { |accum, p| accum * p[:value] }
  # pp rules
end

day2