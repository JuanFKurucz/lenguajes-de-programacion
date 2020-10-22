#!/usr/bin/env ruby

class Exp
    def evaluate(state)
        puts "Default Evaluate in Exp"
        nil
    end
end

class Stmt
    def evaluate(state)
        puts "Default Evaluate in Stmt"
        nil
    end
end

class Num < Exp
    def initialize(n)
        @names = Float(n)
    end
    def evaluate(state)
        state[@names]       
    end
end

class Var < Exp
    def initialize(names,state)
        @names = names
        state[@names] = nil
    end
    def evaluate(state)
        state[@names]
    end
end

class OpBin < Exp
    def initialize(left, right)
        @left = left
        @right = right
    end
end

class OpUni < Exp
    def initialize(elem)
        @elem = elem
    end
end

class Assign < Stmt
    def evaluate(state)
        state[@ref.names] = @exp.evaluate(state)
        state
    end
end


class Mult < OpBin
    def evaluate(state)
        @left.evaluate(state) * @right.evaluate(state)
    end
end

class Sub < OpBin
    def evaluate(state)
        @left.evaluate(state) - @right.evaluate(state)
    end
end

class Add < OpBin
    def evaluate(state)
        @left.evaluate(state) + @right.evaluate(state)
    end
end

class Div < OpBin
    def evaluate(state)
        @left.evaluate(state) / @right.evaluate(state)
    end
end

class Opos < OpUni
    def evaluate(state)
        @elem.evaluate(state) * -1
    end
end


class CompLT < OpBin
    def evaluate(state) 
        @left.evaluate(state) < @right.valuate(state)
    end
end

class CompGt < OpBin
    def evaluate(state)
        @left.evaluate(state) > @right.valuate(state)
    end
end

class CompLTE < OpBin
    def evaluate(state) 
        @left.evaluate(state) <= @right.valuate(state)
    end
end

class CompGtE < OpBin
    def evaluate(state)
        @left.evaluate(state) >= @right.valuate(state)
    end
end

class Eq < OpBin
    def evaluate(state) 
        @left.evaluate(state) == @right.valuate(state)
    end
end

class Dif < OpBin
    def evaluate(state) 
        @left.evaluate(state) != @right.valuate(state)
    end
end

class OurRandom < Num
    #sounds like communism propaganda but ok
    def initialize()
        @names = rand()
    end
end

class IfThen < Stmt
    def evaluate(state)
        if @left.evaluate(state)
            @right.evaluate(state)
        end
    end
end

class OurTrue < Exp
    def initialize(n)
        @n = true
    end
    def evaluate(state)
        @n
    end
end

class OurFalse < Exp
    def initialize(n)
        @n = false
    end
    def evaluate(state)
        @n
    end
end

class OurAnd < OpBin
    def evaluate(state) 
        @left.evaluate(state) && @right.valuate(state)
    end
end

class OurOr < OpBin
    def evaluate(state) 
        @left.evaluate(state) || @right.valuate(state)
    end
end

class Neg < OpUni
    def evaluate()
        !@elem.evaluate
    end
end

class OurWhile < Stmt
    def initialize(cond, body)
        @cond = cond
        @body = body
    end 
    def iteration(cond, body, state)
        if cond.evaluate(state)
            body.evaluate(state)
            iteration(cond, body, state)
        end
    end        
    def evaluate(state)
        iteration(state, @cond, @body)
    end
end

class Print < Stmt
    puts "Print : #{@elem}"
end

if __FILE__ == $0
    puts "Hi"
    # state = Hash.new
    # var_x = Var.new("x",state)
    # Assign.new(var_x, Num.new(77)).evaluate(state)
    # puts state
    # ass_x = Assign.new(var_x, UMinus.new(var_x))
    # puts ass_x
    # ass_ex_state = ass_x.evaluate(state)
    # puts ass_ex_state
    # IfThen.new(CompLT.new(var_x,Num.new(0)).ass_x).evaluate(state)
    # puts state 
end
