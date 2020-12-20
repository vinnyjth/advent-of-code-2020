require './utils'

def resolve_rule(rules, current_rule)
  current_rule_str = rules[current_rule]
  if current_rule_str.include? "|"
    rule_parts = current_rule_str.split(" | ").map { |r| r.split(" ") }
    group = rule_parts.map do |part|
      part.map {|r| resolve_rule(rules, r) }.join('')
    end.join('|')
    "(#{group})"
  elsif current_rule_str.match? /"[ab]"/
    current_rule_str.gsub('"', '')
  else
    rule_parts = current_rule_str.split(" ")
    rule_parts.map {|r| resolve_rule(rules, r) }.join('')
  end
end

def part1
  lines = Utils.input_read(19).join('').split("\n\n")
  rules = lines[0].split("\n").inject({}) { |accum, r| accum[r.split(":")[0]] = r.split(": ")[1]; accum }
  rule_final = resolve_rule(rules, "0")
  regex = Regexp.new "^#{rule_final}$"
  matches = lines[1].split("\n").count { |l| l.match? regex }
  puts matches
end

part1


MAP = { "8" => "eight", "11" => "eleven"}
def resolve_rule_with_inf(rules, current_rule)
  current_rule_str = rules[current_rule]
  if ["8", "11"].include? current_rule
    rule_parts = current_rule_str.split(" | ").map { |r| r.split(" ") }
    group = rule_parts.map do |part|
      part.map { |r| r == current_rule ? "\\g'#{MAP[current_rule]}'" : resolve_rule_with_inf(rules, r) }.join('')
    end.join('|')
    "(?<#{MAP[current_rule]}>#{group})"
  elsif current_rule_str.include? "|"
    rule_parts = current_rule_str.split(" | ").map { |r| r.split(" ") }
    group = rule_parts.map do |part|
      part.map {|r| resolve_rule_with_inf(rules, r) }.join('')
    end.join('|')
    "(#{group})"
  elsif current_rule_str.match? /"[ab]"/
    current_rule_str.gsub('"', '')
  else
    rule_parts = current_rule_str.split(" ")
    rule_parts.map {|r| resolve_rule_with_inf(rules, r) }.join('')
  end
end

def part2
  lines = Utils.input_read(19).join('').split("\n\n")
  rules = lines[0].split("\n").inject({}) { |accum, r| accum[r.split(":")[0]] = r.split(": ")[1]; accum }
  rules["8"] = "42 | 42 8"
  rules["11"] = "42 31 | 42 11 31"
  puts resolve_rule_with_inf(rules, "8")
  puts resolve_rule_with_inf(rules, "11")
  rule_final = resolve_rule_with_inf(rules, "0")
  regex = Regexp.new "^#{rule_final}$"
  matches = lines[1].split("\n").count { |l| l.match? regex }
  puts matches
end

part2