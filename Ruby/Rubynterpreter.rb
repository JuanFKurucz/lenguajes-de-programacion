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
        @value = Float(n)
    end
    def evaluate(state)
        @value
    end
end

class Var < Exp
    attr_reader :value

    def initialize(value)
        @value = value
    end
    def evaluate(state)
        state[@value]
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
        state[@ref.value] = @exp.evaluate(state)
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
    # Stalin Approves
    def initialize()
        @value = rand()
    end
end

class IfThenElse < Stmt
    def initialize(cond, ifTrue, ifFalse)
        @cond = cond
        @ifTrue = ifTrue
        @ifFalse = ifFalse
    end
    def evaluate(state)
        if @cond.evaluate(state)
            @ifTrue.evaluate(state)
        else
            if !@ifFalse.nil?
                @ifFalse.evaluate(state)
            end
        end
    end
end

class IfThen < IfThenElse
    def initialize(cond, ifTrue)
        @cond = cond
        @ifTrue = ifTrue
        @ifFalse = nil
    end
end


class OurTrue < Exp
    # Sounds like communism propaganda but ok
    def evaluate(state)
        true
    end
end

class OurFalse < Exp
    def evaluate(state)
        false
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
    def evaluate(state)
        if @cond.evaluate(state)
            @body.evaluate(state)
            evaluate(state)
        end
    end
end

class Sequence < Stmt
    def initialize(statements)
        @statements = statements
    end 
    def evaluate(state)
        @statements.each do |statement| 
            statement.evaluate(state)
        end
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
    state = Hash.new
    number_3 = Num.new(3)
    number_2 = Num.new(2)
    var_3 = Var.new("one")
    var_2 = Var.new("two")
    Assign.new(var_3, number_3).evaluate(state)
    Assign.new(var_2, number_2).evaluate(state)
    puts "1 - {\"one\"=>3.0, \"two\"=>2.0}:\n #{state}"
    
    var_mult = Var.new("mult")
    Assign.new(var_mult, Mult.new(var_2,var_3)).evaluate(state)
    puts "2 - {\"one\"=>3.0, \"two\"=>2.0, \"mult\"=>6.0}:\n #{state}"
    
    var_sub = Var.new("sub")
    Assign.new(var_sub, Sub.new(var_3,var_2)).evaluate(state)
    puts "3 - {\"one\"=>3.0, \"two\"=>2.0, \"mult\"=>6.0, \"sub\"=>1.0}:\n #{state}"
    
    var_nsub = Var.new("-sub")
    Assign.new(var_nsub, Sub.new(var_2,var_3)).evaluate(state)
    puts "4 - {\"one\"=>3.0, \"two\"=>2.0, \"mult\"=>6.0, \"sub\"=>1.0, \"-sub\"=>-1.0}:\n #{state}"
    
    var_zero = Var.new("zero")
    Assign.new(var_zero, Add.new(var_nsub,var_sub)).evaluate(state)
    puts "5 - {\"one\"=>3.0, \"two\"=>2.0, \"mult\"=>6.0, \"sub\"=>1.0, \"-sub\"=>-1.0, \"zero\"=>0.0}:\n #{state}"
    
    var_div = Var.new("div")
    Assign.new(var_div, Div.new(var_mult,var_2)).evaluate(state)
    puts "6 - {\"one\"=>3.0, \"two\"=>2.0, \"mult\"=>6.0, \"sub\"=>1.0, \"-sub\"=>-1.0, \"zero\"=>0.0, \"div\"=>3.0}:\n #{state}"

    var_oposdiv = Var.new("oposdiv")
    Assign.new(var_oposdiv, Opos.new(var_div)).evaluate(state)
    puts "7 - {\"one\"=>3.0, \"two\"=>2.0, \"mult\"=>6.0, \"sub\"=>1.0, \"-sub\"=>-1.0, \"zero\"=>0.0, \"div\"=>3.0, \"oposdiv\"=>-3.0}:\n #{state}"

    puts "8.1 - (-3 < 3)? - Print : true"
    Print.new(CompLT.new(var_oposdiv,var_div)).evaluate(state)
    
    puts "8.2 - (3 < 3)? - Print : false"
    Print.new(CompLT.new(var_div,var_div)).evaluate(state)
    
    puts "9.1 - (3 > -3)? - Print : true"
    Print.new(CompGT.new(var_div,var_oposdiv)).evaluate(state)
    
    puts "9.2 - (-3 > 3)? - Print : false"
    Print.new(CompGT.new(var_oposdiv,var_div)).evaluate(state)
    
    puts "10.1 - (-3 <= 3)? - Print : true"
    Print.new(CompLTE.new(var_oposdiv,var_div)).evaluate(state)
    
    puts "10.2 - (3 <= -3)? - Print : false"
    Print.new(CompLTE.new(var_div,var_oposdiv)).evaluate(state)
    
    puts "11.1 - (3 >= 3)? - Print : true"
    Print.new(CompGTE.new(var_div,var_div)).evaluate(state)
    
    puts "11.2 - (-3 >= 3)? - Print : false"
    Print.new(CompGTE.new(var_oposdiv,var_div)).evaluate(state)
    
    puts "12.1 - (3 = 3)? - Print : true"
    Print.new(Eq.new(var_div,var_div)).evaluate(state)
    
    puts "12.2 - (-3 = 3)? - Print : false"
    Print.new(Eq.new(var_oposdiv,var_div)).evaluate(state)
    
    puts "13.1 - (-3 != 3)? - Print : true"
    Print.new(Dif.new(var_oposdiv,var_div)).evaluate(state)
    
    puts "13.2 - (3 != 3)? - Print : false"
    Print.new(Dif.new(var_div,var_div)).evaluate(state)
    
    puts "14 - RANDOM 0 < x < 1 - Print : algorandom..."
    Print.new(OurRandom.new()).evaluate(state)
    
    puts "15.1 - BOOLEANO - Print : true"
    Print.new(OurTrue.new()).evaluate(state)
    
    puts "15.2 - BOOLEANO - Print : false"
    Print.new(OurFalse.new()).evaluate(state)
    
    puts "16.1 - NEG BOOLEANO FALSE - Print : true"
    Print.new(Neg.new(OurFalse.new())).evaluate(state)
    
    puts "16.2 - NEG BOOLEANO TRUE- Print : false"
    Print.new(Neg.new(OurTrue.new())).evaluate(state)
    
    puts "18.1 - WHILE (-3 <= 3) oposdiv + 1 - before state : #{state}"
    OurWhile.new(CompLTE.new(var_oposdiv,var_div),Assign.new(var_oposdiv, Add.new(var_oposdiv,Num.new(1)))).evaluate(state)
    puts "18.2 - WHILE after state oposdiv = 4 : #{state}"
    
    puts "19.1 - IFTHEN (AND): "
    IfThen.new(OurAnd.new(CompGT.new(var_oposdiv,var_div),OurTrue.new()),Assign.new(var_oposdiv, Add.new(var_oposdiv,Num.new(1)))).evaluate(state)
    puts "19.2 state : #{state}"
    
    puts "20.1 - IFTHEN (OR): "
    IfThen.new(OurOr.new(CompLTE.new(var_oposdiv,var_div),OurTrue.new()),Assign.new(var_oposdiv, Add.new(var_oposdiv,Num.new(1)))).evaluate(state)
    puts "20.2 state : #{state}"
    
    puts "21 - IF THEN ELSE: Print: 1.0"
    Print.new(IfThenElse.new(OurTrue.new(),Num.new(1),Num.new(2))).evaluate(state)
    
    puts "22 - IF THEN ELSE: Print: 2.0 "
    Print.new(IfThenElse.new(OurFalse.new(),Num.new(1),Num.new(2))).evaluate(state)
    
    puts "23.1 - SEQUENCE: Print: 3.0 "
    var_seq = Var.new("seq")
    Print.new(Sequence.new([Assign.new(var_seq, Num.new(2)),Assign.new(var_seq,Add.new(var_seq,Num.new(1)))])).evaluate(state)
    puts "23.2 END STATE: #{state}"
end
