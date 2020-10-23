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
        @names
    end
end

class Var < Exp
    attr_reader :names

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
    def initialize(ref, exp)
        @ref = ref
        @exp = exp
    end
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
        @left.evaluate(state) < @right.evaluate(state)
    end
end

class CompGT < OpBin
    def evaluate(state)
        @left.evaluate(state) > @right.evaluate(state)
    end
end

class CompLTE < OpBin
    def evaluate(state) 
        @left.evaluate(state) <= @right.evaluate(state)
    end
end

class CompGTE < OpBin
    def evaluate(state)
        @left.evaluate(state) >= @right.evaluate(state)
    end
end

class Eq < OpBin
    def evaluate(state) 
        @left.evaluate(state) == @right.evaluate(state)
    end
end

class Dif < OpBin
    def evaluate(state) 
        @left.evaluate(state) != @right.evaluate(state)
    end
end

class OurRandom < Num
    #sounds like communism propaganda but ok
    def initialize()
        @names = rand()
    end
end

class IfThen < OpBin
    def evaluate(state)
        if @left.evaluate(state)
            @right.evaluate(state)
        end
    end
end


class IfThenElse < Exp
    def initialize(cond, ifTrue, ifFalse)
        @cond = cond
        @ifTrue = ifTrue
        @ifFalse = ifFalse
    end
    def evaluate(state)
        if @cond.evaluate(state)
            @ifTrue.evaluate(state)
        else
            @ifFalse.evaluate(state)
        end
    end
end

class OurTrue < Exp
    def initialize()
        @n = true
    end
    def evaluate(state)
        @n
    end
end

class OurFalse < Exp
    def initialize()
        @n = false
    end
    def evaluate(state)
        @n
    end
end

class OurAnd < OpBin
    def evaluate(state) 
        @left.evaluate(state) && @right.evaluate(state)
    end
end

class OurOr < OpBin
    def evaluate(state) 
        @left.evaluate(state) || @right.evaluate(state)
    end
end

class Neg < OpUni
    def evaluate(state)
        !@elem.evaluate(state)
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
        iteration(@cond, @body, state)
    end
end

class Print < Stmt
    def initialize(elem)
        @elem = elem
    end 
    def evaluate(state)
        puts "Print : #{@elem.evaluate(state)}"
    end
end

if __FILE__ == $0
    puts "Hi"
    state = Hash.new
    number_3 = Num.new(3)
    number_2 = Num.new(2)
    var_3 = Var.new("one",state)
    var_2 = Var.new("two",state)
    Assign.new(var_3, number_3).evaluate(state)
    Assign.new(var_2, number_2).evaluate(state)
    puts state
    var_mult = Var.new("mult",state)
    Assign.new(var_mult, Mult.new(var_2,var_3)).evaluate(state)
    puts state
    var_sub = Var.new("sub",state)
    Assign.new(var_sub, Sub.new(var_3,var_2)).evaluate(state)
    puts state
    var_nsub = Var.new("-sub",state)
    Assign.new(var_nsub, Sub.new(var_2,var_3)).evaluate(state)
    puts state
    var_zero = Var.new("zero",state)
    Assign.new(var_zero, Add.new(var_nsub,var_sub)).evaluate(state)
    puts state
    var_div = Var.new("div",state)
    Assign.new(var_div, Div.new(var_mult,var_2)).evaluate(state)
    puts state
    var_oposdiv = Var.new("oposdiv",state)
    Assign.new(var_oposdiv, Opos.new(var_div)).evaluate(state)
    puts state
    Print.new(CompLT.new(var_oposdiv,var_div)).evaluate(state)
    Print.new(CompGT.new(var_oposdiv,var_div)).evaluate(state)
    Print.new(CompLTE.new(var_oposdiv,var_div)).evaluate(state)
    Print.new(CompGTE.new(var_oposdiv,var_div)).evaluate(state)
    Print.new(Eq.new(var_oposdiv,var_div)).evaluate(state)
    Print.new(Dif.new(var_oposdiv,var_div)).evaluate(state)

    Print.new(OurRandom.new()).evaluate(state)
    Print.new(OurTrue.new()).evaluate(state)
    Print.new(OurFalse.new()).evaluate(state)
    Print.new(Neg.new(OurFalse.new())).evaluate(state)
    puts state
    OurWhile.new(CompLTE.new(var_oposdiv,var_div),Assign.new(var_oposdiv, Add.new(var_oposdiv,Num.new(1)))).evaluate(state)
    puts state

    IfThen.new(OurAnd.new(CompGT.new(var_oposdiv,var_div),OurTrue.new()),Assign.new(var_oposdiv, Add.new(var_oposdiv,Num.new(1)))).evaluate(state)
    puts state
    IfThen.new(OurOr.new(CompLTE.new(var_oposdiv,var_div),OurTrue.new()),Assign.new(var_oposdiv, Add.new(var_oposdiv,Num.new(1)))).evaluate(state)
    puts state

    puts IfThenElse.new(OurTrue.new(),Num.new(1),Num.new(2)).evaluate(state)
    puts IfThenElse.new(OurFalse.new(),Num.new(1),Num.new(2)).evaluate(state)

    #var_x = Var.new("x",state)
    #puts Assign.new(var_x, Num.new(77)).evaluate(state)
    # puts state
    # ass_x = Assign.new(var_x, Opos.new(var_x))
    # puts ass_x
    # ass_ex_state = ass_x.evaluate(state)
    # puts ass_ex_state
    # IfThen.new(CompLT.new(var_x,Num.new(0)),ass_x).evaluate(state)
    # puts state 
end
