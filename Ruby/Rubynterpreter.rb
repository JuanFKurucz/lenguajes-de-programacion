#!/usr/bin/env ruby

class Exp
    # Attriibutes
    attr_accessor :names

    # Create the object 
    def initialize(names = "World")
        @names = names
    end
end

class Stmt
    attr_accessor :names

    # Create the object 
    def initialize(names = "World")
        @names = names
    end
end

class Num < Exp
    # Attriibutes
    
    # Create the object 
    def initialize(n)
        @n = Float(n)
    end
    def evaluate(state)
        @n       
    end
end

if Assign < Stmt
    def initialize(ref, exp)
        @ref=ref
        @exp=exp

    end
    def evaluate(state)
        state[@ref.id] = @exp.evaluate(state)
        state
    end
end


if __FILE__ == $0
    algo
end


