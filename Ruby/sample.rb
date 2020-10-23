require 'test/unit'

def print(exp)
    puts "Resultado de la expresión: " + exp.inspect
end

class Expression
    def initialize(exp)
        @exp = exp
    end
end

class Variable < Expression
    attr_reader :name
    def initialize(name,state)
        @name = name
        state.store(name,nil)
    end
    def evaluate(state)
        return state[@name]
    end
end

class Numeral < Expression
    attr_reader :num
    def initialize(num)
        @num = num
    end
    def evaluate(state)
        return num
    end
end

class Myrandom < Numeral
    def initialize()
        @num = rand(0)
    end
end

class Statement
    def initialize()
    end
end    

class Assign < Statement
    attr_reader :var, :expression
    def initialize(var, expression, state)
        @var = var
        @expression = expression
        state[var] = expression.evaluate(state)
    end
    def evaluate(state)
        state[@var] = expression
    end    
end

class OpBin < Expression
    def initialize(expressionLeft, expressionRight)
        @expressionLeft = expressionLeft
        @expressionRight = expressionRight
    end
end

class OpUni < Expression
    def initialize(expression)
        @expression = expression
    end
end

class Neg < OpUni
    def evaluate(state)
       return  -@expression.evaluate 
    end
end

class Add < OpBin
    def evaluate(state)
        return (@expressionLeft.evaluate(state) + @expressionRight.evaluate(state))
    end
end

class Sub < OpBin
    def evaluate(state)
        return (@expressionLeft.evaluate(state) - @expressionRight.evaluate(state))
    end
end

class Mult < OpBin
    def evaluate(state)
        return (@expressionLeft.evaluate(state) * @expressionRight.evaluate(state))
    end
end

class Div < OpBin
    def evaluate(state)
        return (@expressionLeft.evaluate / @expressionRight.evaluate(state))
    end
end

class Myboolean < Expression
    def initialize()
    end
end

class Mytrue < Myboolean
    def evaluate(state)
        return true
    end
end

class Myfalse < Myboolean
    def evaluate(state)
        return false
    end
end

class And < OpBin
    def evaluate(state)
        return (@expressionLeft.evaluate(state) && @expressionRight.evaluate(state))
    end
end

class Or < OpBin
    def evaluate(state)
        return (@expressionLeft.evaluate(state) || @expressionRight.evaluate(state))
    end
end

class Nega < OpUni
    def evaluate(state)
        return (!@expressionLeft.evaluate(state))
    end
end

class Eq < OpBin
    def evaluate(state)
        return (@expressionLeft.evaluate(state) == @expressionRight.evaluate(state))
    end
end

class NotEq < OpBin
    def evaluate(state)
        return (@expressionLeft.evaluate(state) != @expressionRight.evaluate(state))
    end
end

class GT < OpBin
    def evaluate(state)
        return (@expressionLeft.evaluate(state) > @expressionRight.evaluate(state))
    end
end

class GET < OpBin
    def evaluate(state)
        return (@expressionLeft.evaluate(state) >= @expressionRight.evaluate(state))
    end
end

class LT < OpBin
    def evaluate(state)
        return (@expressionLeft.evaluate(state) < @expressionRight.evaluate(state))
    end
end

class LET < OpBin
    def evaluate(state)
        return (@expressionLeft.evaluate(state) <= @expressionRight.evaluate(state))
    end
end


class Sequence < Statement
    def initialize(stmts)
        @stmts = stmts
    end
    def evaluate(state)   
        @stmts.each do |stmt|
        stmt.evaluate(state)
        end
    end
end

class While < Statement
    def initialize(exp, stmts)
        @stmts = stmts
        @exp = exp
    end
    def evaluate(state)
        while @exp do
            @stmts.evaluate(state)
        end
        return nil
    end
end

class IfElse 
    def initialize(cond, bodyIf, bodyElse = nil)
        @cond = cond
        @bodyIf = bodyIf
        @bodyElse = bodyElse
    end
    def evaluate(state) 
        if (@cond.evaluate(state)) 
            @bodyIf.evaluate(state)
        elsif (@bodyElse != nil)
            @bodyElse.evaluate(state)
        end
    end
end



class TestNumeral < Test::Unit::TestCase
    def test_zero
        value = Numeral.new(0).evaluate(state)
        assert_equal(0, value)
    end

    def test_positive_numbers
        value = Numeral.new(1111112).evaluate(state)
        assert_equal(1111112, value)
    end

    def test_negative_numbers
        value = Numeral.new(-1111112.2).evaluate(state)
        assert_equal(-1111112.2, value)
    end
end

class TestVariable < Test::Unit::TestCase
    def test_nil
        value = Variable.new("x").evaluate
        puts(value)
        assert_equal("x", value)
    end

    def test_positive_numbers
        value = Numeral.new(1111112).evaluate(state)
        assert_equal(1111112, value)
    end
end


state = Hash.new
# number = Numeral.new(2.0)
# variable = Variable.new("x",state)
# assign = Assign.new(variable,number)
# assign.evaluate(state)
# suma = Add.new(number,number)
# suma2 = Add.new(suma,number)
# nega = Neg.new(number)
# random = Myrandom.new()
# mytrue = Mytrue.new()
# myfalse = Myfalse.new()
# assign = Assign.new(variable,mytrue)
# assign.evaluate(state)
# myand = And.new(mytrue,myfalse)

# num = Numeral.new(1.0)
# num2 = Numeral.new(100.0)
# var = Variable.new("i",state)
# sm = Add.new(num,1)
# st = Assign.new(var,sm)

# lt = LT.new(var,num2)
# w = While.new(lt,st)

# ifelse = IfElse.new(lt, num2, num)
# puts(ifelse.evaluate(state))
# w.evaluate(state)