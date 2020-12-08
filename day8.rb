require 'set'
require './utils'


class BitcodeMachine
  def initialize(instructions)
    @instructions = instructions.each_with_index.map do |l, idx|
      command = l.split(' ')[0]
      argument = l.split(' ')[1].to_i
      { command: command, argument: argument, index: idx }
    end
    @current_index = 0
    @accum = 0
    @visited_indexes = Set.new()
  end

  def step
    instruction = @instructions[@current_index]
    if instruction[:command] == "nop"
      @current_index += 1
    elsif instruction[:command] == "jmp"
      @current_index += instruction[:argument]
    elsif instruction[:command] == "acc"
      @accum += instruction[:argument]
      @current_index += 1
    end

    if @visited_indexes.include? @current_index
      @accum
    else
      @visited_indexes.add(@current_index)
      step
    end
  end
end

class RepairingBitcodeMachine
  def initialize(instructions)
    @instructions = instructions.each_with_index.map do |l, idx|
      command = l.split(' ')[0]
      argument = l.split(' ')[1].to_i
      { command: command, argument: argument, index: idx }
    end
    @original_instructions = @instructions
    @attempted_repair = -1
    reset
  end

  def reset
    @current_index = 0
    @accum = 0
    @visited_indexes = Set.new()    
  end

  def solve
    solved = false
    while solved == false
      solved = step
      reset
      patch unless solved
    end
    @accum
  end

  def patch
    @instructions = @original_instructions.map(&:dup)
    offset = @attempted_repair + 1
    next_patch_local = @instructions[offset..-1].find_index do |ins|
      %w[jmp nop].include? ins[:command]
    end
    next_patch = next_patch_local + offset
    current_command = @instructions[next_patch][:command]
    @instructions[next_patch][:command] = current_command == 'jmp' ? 'nop' : 'jmp'
    @attempted_repair = next_patch
  end

  def step
    instruction = @instructions[@current_index]
    if instruction[:command] == "nop"
      @current_index += 1
    elsif instruction[:command] == "jmp"
      @current_index += instruction[:argument]
    elsif instruction[:command] == "acc"
      @accum += instruction[:argument]
      @current_index += 1
    end

    pp [@current_index, @instructions.length, instruction[:command]]

    if @visited_indexes.include? @current_index
      false
    elsif @current_index == @instructions.length
      true
    else
      @visited_indexes.add(@current_index)
      step
    end
  end
end

def solve1
  lines = Utils.input_read(8)
  machine = BitcodeMachine.new(lines)
  puts machine.step
end

solve1

def solve2
  lines = Utils.input_read(8)
  machine = RepairingBitcodeMachine.new(lines)
  puts machine.solve
end


solve2