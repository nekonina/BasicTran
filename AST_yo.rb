#	Irina Marcano 13-10805

$simbolos = {
	'Punto' => ".",				
	'Coma' => ",",				
	'DosPuntos' => ":" ,
	'ParAbre' => "(" ,			
	'ParCierra' => ")" ,
	'CorcheteAbre' => "[" ,		
	'CorcheteCierre' => "]" ,		
	'Resta' =>"-" ,	
	'Suma' => "+" ,
	'Desigualdad' => "/=" ,		
	'PuntoYComa' => ";" ,
	'Multiplicacion' => "*" ,				
	'Division' => "/" ,
	'Modulo' => "%" ,			
	'Conjuncion' => "/\\" ,
	'Disyuncion' => "\\/" ,		
	'Not' => "not" ,
	'Menor' =>"<" ,				
	'MenorIgual' => "<=" ,
	'Mayor' => ">" ,				
	'MayorIgual' => ">=" ,
	'Igual' => "=" , 				
	'SiguienteCar' => "++" ,
	'AnteriorCar' => "--" ,		
	'ValorAscii' => "#",
	'Concatenacion' => "::" ,		
	'Shift' => "$" ,
}
def conversorImprimir (simbolo)
end

# == Clase Asignacion
#
class Asignacion

	# == Atributos
	#
	# id: identificador del parametro
	# expresion: expresion que se le asigna al id
	attr_accessor  :id, :expresion, :valor, :tipo

	def initialize(id, expresion)
		@id = id
		@expresion = expresion
		@tipo = @expresion.tipo
		@valor = expresion
		if @id.tipo != "variable"
			puts "\n Para realizar un asignacion el identificador debe ser una variable definida"
			exit
		end

	end

	def to_s(tab)
		s =  (" "*tab)+ "Asignacion: \n"
		s << (" "*(tab+2)) + "identificador: " + @id.to_s(tab+4) + "\n"
		s << (" "*(tab+2)) + "expresion: " + @expresion.to_s(tab+4)
		
		return s
	end
end

# == Clase Asignacion
#
class Read

	# == Atributos
	#
	# id: identificador del parametro
	attr_accessor  :id, :tipo

	def initialize(id)
		@id = id
		@tipo = id.tipo
		if @tipo != "variable"
			puts "\n Debes colocar un identificador valido para leer archivos"
			exit
		end
	end

	def to_s(tab)
		s = (" "*tab) + "Lectura:\n"
		s << (" "*(tab+2)) + "archivo: " + @id.to_s(tab+4) + "\n"
		return s
	end
end

class Print

	# == Atributos
	#
	# id: identificador del parametro
	attr_accessor  :salida

	def initialize(salida)
		@salida = salida
		if @salida.tipo != "entero" && @salida.tipo != "caracter" && @salida.tipo != "booleano" &&  @salida.tipo != "variable"
			puts "El argumento que desea imprimir no es valido"
			exit	
		end

	end

	def to_s(tab)
		s = (" "*tab) + "Impresion:\n"
		s << (" "*(tab+2)) + "salida: " + @salida.to_s(tab)
		return s
	end
end

class IfOtherEnd

	# == Atributos
	#
	# guardia: guardia relacionada con el if
	# intr: instruccion a realizar si se cumple la comdicion
	# intr2: instruccion q se realiza si no se cumple la condicion del if 
	attr_accessor  :guardia, :intr, :intr2

	def initialize(guardia, intr, intr2)
		@guardia = guardia
		@intr = intr
		@intr2 = intr2
		#puts @guardia.tipo
		if @guardia.tipo != "booleano" && @guardia.tipo != "variable"
			puts "entre"
			puts "\n en la guardia del if solo deben ir expresiones booleanas"
			exit
		end

	end

	def to_s(tab)
		s = (" "*tab) + "Condicional If/Otherwise/End:\n"
		s << (" "*(tab+2)) + "guardia: \n" + @guardia.to_s(tab+4)
		s << (" "*(tab+2)) + "Instrucciones If: \n" + @intr.to_s(tab+4)
		s << (" "*(tab+2)) + "Instrucciones Otherwise: \n" + @intr2.to_s(tab+4)
		return s
	end
end

class IfEnd

	# == Atributos
	#
	# guardia: guardia relacionada con el if
	# intr: instruccion a realizar si se cumple la comdicion
	attr_accessor  :guardia, :intr

	def initialize(guardia, intr)
		@guardia = guardia
		@intr = intr
		if @guardia.tipo != "booleano" && @guardia.tipo != "variable"
			puts "entre"
			puts "\n en la guardia del if solo deben ir expresiones booleanas"
			exit
		end

	end

	def to_s(tab)
		s = (" "*tab) + "Condicional If/End:\n"
		s << (" "*(tab+2)) + "guardia: \n" + @guardia.to_s(tab+4)
		s << (" "*(tab+2)) + "Instrucciones If: \n" + @intr.to_s(tab+4)
		return s
	end
end

class Bloque

	# == Atributos
	#
	# guardia: guardia relacionada con el if
	# intr: instruccion a realizar si se cumple la comdicion
	attr_accessor  :instrucciones

	def initialize(instrucciones)
		@instrucciones = instrucciones

	end

	def to_s(tab)
		s = (" "*tab) + "Nuevo Bloque:\n"
		s << (" "*(tab+2)) + "Instrucciones: \n" + @instrucciones.to_s(tab+4)
		s << (" "*(tab)) + "Fin del bloque \n"

		return s
	end
end
class WBloque

	# == Atributos
	#
	# guardia: guardia relacionada con el if
	# intr: instruccion a realizar si se cumple la comdicion
	attr_accessor  :declaraciones,:instrucciones

	def initialize(declaraciones,instrucciones)
		@declaraciones = declaraciones
		@instrucciones = instrucciones

	end

	def to_s(tab)
		s = (" "*tab) + "Nuevo Bloque:\n"
		s << (" "*(tab+2)) + "Declaraciones: \n" + @declaraciones.to_s(tab+4)
		s << (" "*(tab+2)) + "Instrucciones: \n" + @instrucciones.to_s(tab+4)
		s << (" "*(tab)) + "Fin del bloque \n"
		return s
	end
end

class Instrucciones

	# == Atributos
	#
	# guardia: guardia relacionada con el if
	# intr: instruccion a realizar si se cumple la comdicion
	attr_accessor  :instrucciones, :accion

	def initialize(instrucciones, accion)
		@accion = accion
		@instrucciones = instrucciones

	end

	def to_s(tab)
		s = ""
		s << @instrucciones.to_s(tab)
		s << @accion.to_s(tab)
		return s
	end
end


class Iteracion_DetStep

	# == Atributos
	#
	# id: parametro sobre el cual se itera
	# start : punto de inicio para el ciclo
	# final: punto para finalizar el ciclo
	# step: paso paso
	# intr: instruccion a realizar si se cumple la comdicion
	attr_accessor  :id,:start, :final, :step, :inst

	def initialize(id,start, final, step, inst)
		@id = id
		@start = start
		@final = final
		@step = step
		@inst = inst

		if @id.tipo != "variable"
			puts "\n El identificador debe ser una variable"
			exit
		end

		if @step == "0"
			puts "El valor del step debe ser distinto de cero"
			exit
		end

		if @start.tipo != "entero" && @start.tipo != "variable" 
			puts "\n El comienzo del ciclo debe ser una expresion numerica"
			exit
		elsif @final.tipo != "entero" &&  @final.tipo != "variable"
			puts "\n El final del ciclo debe ser una expresion numerica"
			exit
		elsif @step.tipo != "entero" && @step.tipo != "variable"
			puts "\n El paso del ciclo debe ser una expresion numerica"
			exit
		end
		$y = @start.valorR.to_i
		#puts @step.valorR
		while $y< @final.valorR.to_i do
			$y = $y + @step.valorR.to_i
		end
		#puts "soy y: #{$y}"
		if $y.to_i != @final.valorR.to_i
			puts "su valor de step: #{@step.valor} llega mas alla de #{@final.valor}"
			exit
		end

	end

	def to_s(tab)
		s = (" "*tab) + "Ciclo For:\n"
		s << (" "*(tab+2)) + "Iterador: " + @id.to_s(tab+4) + "\n"
		s << (" "*(tab+2)) + "Inicio del ciclo: " + @start.to_s(tab+4)+ "\n"
		s << (" "*(tab+2)) + "El ciclo termina en: " + @final.to_s(tab+4)+ "\n"
		s << (" "*(tab+2)) + "Paso: " + @step.to_s(tab+4) + "\n"
		s << (" "*(tab+2)) + "Instrucciones: \n" + @inst.to_s(tab+4)
		s << (" "*(tab)) + "Fin del ciclo \n"
		return s
	end
end

class Iteracion_Det

	# == Atributos
	#
	# id: parametro sobre el cual se itera
	# start : punto de inicio para el ciclo
	# final: punto para finalizar el ciclo
	# intr: instruccion a realizar si se cumple la comdicion
	attr_accessor  :id,:start, :final, :inst

	def initialize(id,start, final, inst)
		@id = id
		@start = start
		@final = final 
		@inst = inst

		if @id.tipo != "variable"
			puts "\n El identificador debe ser una variable"
			exit
		end
		
		if @start.tipo != "entero" && @start.tipo != "variable" 
			puts "\n El comienzo del ciclo debe ser una expresion numerica"
			exit
		elsif @final.tipo != "entero" &&  @final.tipo != "variable"
			puts "\n El final del ciclo debe ser una expresion numerica"
			exit
		end

	end

	def to_s(tab)
		s = (" "*tab) + "Ciclo For:\n"
		s << (" "*(tab+2)) + "Iterador: " + @id.to_s() + "\n"
		s << (" "*(tab+2)) + "Inicio del ciclo: " + @start.to_s()+ "\n"
		s << (" "*(tab+2)) + "El ciclo termina en: " + @final.to_s()+ "\n"
		s << (" "*(tab+2)) + "Instrucciones: \n" + @inst.to_s(tab+4)
		s << (" "*(tab)) + "Fin del ciclo \n"
		return s
	end
end

class Programa

	# == Atributos
	#
	# Instrucciones: Secuencia de instrucciones definidas en el programa
	attr_accessor :instruccion

	def initialize(instruccion)
		@instruccion = instruccion
	end

	def to_s()
		s = ""
		if @instruccion != nil 
			s = "\n Programa: \n" 
			s << @instruccion.to_s(4)
		end
		return s
	end
end

class Iteracion_Indet

	# == Atributos
	#
	# condicional: regla para mantenerse iterando
	# intr: instruccion a realizar si se cumple la comdicion
	attr_accessor  :condicional, :inst

	def initialize(condicional, inst)
		@condicional= condicional 
		@inst = inst

		if @condicional.tipo != "booleano" && @condicional.tipo != "variable"
			puts "\n El condicional del while debe ser una expresion Booleana"
			exit
		end

	end

	def to_s(tab)
		s = (" "*tab) + "Ciclo While:\n"
		s << (" "*(tab+2)) + "Condicional: \n" + @condicional.to_s(tab+4)
		s << (" "*(tab+2)) + "Instrucciones: \n" + @inst.to_s(tab+4)
		s << (" "*(tab)) + "Fin del ciclo \n"
		return s
	end
end

class LDeclaracionS

	# == Atributos
	#
	# declaracion: referido a una declaracion de una sola variable
	attr_accessor  :declaracion

	def initialize(declaracion)
		@declaracion= declaracion

	end

	def to_s(tab)
		s = ""
		s << (" "*(tab+2)) + "Variable: \n" + @declaracion.to_s(tab+4)
		return s
	end
end

class LDeclaracionRec

	# == Atributos
	#
	# declaraciones: referido a declaraciones de conjuntos de distintos tipos de varible
	# declaracion: declaracion de tipo de variable
	attr_accessor  :declaraciones, :declaracion

	def initialize(declaraciones,declaracion)
		@declaracion= declaracion
		@declaraciones= declaraciones

	end

	def to_s(tab)
		s = ""
		s << (" "*(tab+2)) + "Variable\\s: \n" + @declaraciones.to_s(tab+4)
		s << (" "*(tab+2)) + "Siguiente Variable\\s: \n" + @declaracion.to_s(tab+4)
		return s
	end
end

class Declaracion

	# == Atributos
	#
	# argumentos: argumentos correspondiente a la declaracion, referente a la declaracion de un conjunto de variable del mismo tipo
	# tipo: tipo de la variable que se esta declarando
	attr_accessor  :argumentos, :tipo

	def initialize(argumentos, tipo)
		@argumentos = argumentos
		@tipo= tipo
	end

	def to_s(tab)
		s = ""
		s << (" "*(tab+2)) + "Argumentos: \n" + @argumentos.to_s(tab+4) + "\n"
		s <<  @tipo.to_s(8)
		return s
	end
end


class Argumento

	# == Atributos
	#
	# id: identificador del arreglo
	# exp: expresion que se le asignara a la nueva variable
	# arg: permite la definicion de los argumentos de varias variables
	attr_accessor  :id,:exp, :arg, :tipo, :valorR, :ini

	def initialize(id,exp, arg)
		@id = id
		@exp = exp
		@arg= arg	
		if exp != nil
			@tipo = @exp.tipo
			@ini = true
		else
			@ini = false
		end

		
	end

	def to_s(tab)
		s = ""
		if !(@id== nil && @exp==nil && @arg==nil)
			s << (" "*(tab+2)) + "Identificador: " + @id.to_s()
			if @exp!= nil
				s << "\n" +(" "*(tab+2)) + "Expresion a Asignar: " + @exp.to_s(tab+4)
			end
			if @arg!= nil
				s << "\n" + (" "*(18)) + "Siguiente declaracion: \n" + @arg.to_s(tab+4)
			end
		end
		return s
	end
end

class ArgumentoId

	# == Atributos
	#
	# id: identificador del arreglo
	# exp: expresion que se le asignara a la nueva variable
	# arg: permite la definicion de los argumentos de varias variables
	attr_accessor  :id,:exp, :arg, :ini

	def initialize(id,exp, arg)
		@id = id
		@exp = exp
		@arg= arg
		@ini = false
	end

	def to_s(tab)
		s = ""
		if !(@id== nil && @exp==nil && @arg==nil)
			s << (" "*(tab+2)) + "Identificador: " + @id.to_s()

			s << "\n" +(" "*(tab+2)) + "Siguiente Identificador: \n" + @exp.to_s(tab+4)
			
		end
		return s
	end
end

class ErrorContexto < RuntimeError 
end

# == Clase TipoError
#
# Clase que representa el nodo de un tipo error para una operacion de 2 operandos.
class Error2ope < ErrorContexto
	def initialize(token1,ope, token2)
		@token1 = token1
		@ope = ope
		@token2 = token2
	end

	def to_s()
		#"Inconsistencia de tipo entre los operandos'#{@token1.valor}' y '#{@token2.valor}'"
		"\n Inconsistencia de tipo para la operacion: #{@token1.valor} #{$simbolos[@ope]} #{@token2.valor}"
	end
end
# == Clase TipoError
#
# Clase que representa el nodo de un tipo error para una operacion con 1 operando a la derecha.
class Error1opeD < ErrorContexto
	def initialize(ope, token)
		@ope = ope
		@token = token
	end

	def to_s()
		#"Inconsistencia de tipo entre los operandos'#{@token1.valor}' y '#{@token2.valor}'"
		"\n Inconsistencia de tipo para la operacion:  #{$simbolos[@ope]} #{@token.valor}"
	end
end


class Tipo

	# == Atributos
	#
	# tipo 	: 	Tipo de dato (num o bool)
	attr_accessor :tipo

	def initialize( tipo )
		@tipo = tipo
	end

	def to_s(tab)
		return (" "*(tab+6))+ "Tipo: "  + @tipo.to_s() + "\n"
	end
end

# == Clase TipoNum
#
# Clase que representa el nodo de un tipo numérico. Hereda de Tipo.
class Int < Tipo
	def initialize()
		super("entero")
	end
end

# == Clase TipoBoolean
#
# Clase que representa el nodo de un tipo booleano. Hereda de Tipo.
class Bool < Tipo
	def initialize()
		super("booleano")
	end
end

class Char < Tipo
	def initialize()
		super("caracter")
	end
end

class Matriz < Tipo
	def initialize( tam, tipo)
		@tam = tam
		@tipo = tipo
	end
	def to_s(tab)
		return (" "*(tab+6))+ "Arreglo de tamaño: "  + @tam.to_s(tab)+ "\n"+ @tipo.to_s(tab)
	end
end

class Salida

	# == Atributos
	#
	# iteracion: recorre para poder imprimir todo lo que se le pase
	# salida: imprime la expresion o caracter correspondiente
	attr_accessor  :iteracion,:salida

	def initialize(iteracion,salida)
		@iteracion = iteracion
		@salida = salida
	end

	def to_s(tab)
		s = ""

  		s << @iteracion.to_s(tab+4) + "\n"
    	if @salida != nil
    		s << (" "*10) +"siguiente Impresion: " + @salida.to_s(10)
    	end
    	return s
	end
end

class ExpresionDosOper
	# op1 	: 	Operador izquierdo de la expresión
	# op2 	: 	Operador derecho de la expresión
	# oper 	: 	Operación correspondiente a la expresión
	# tipo :    tipo de la expresion
	attr_accessor :op1, :op2, :oper, :tipo, :valor, :valorR
	def initialize(op1, op2, oper)
		@op1 = op1
		@op2 = op2
		@oper = oper
		@valor = @op1.valor + $simbolos[@oper] + @op2.valor


		if @oper == "Concatenacion"
			if @op1.tipo == "caracter" && @op2.tipo == "caracter"
				@tipo = "caracter"
			elsif @op1.tipo == "variable" && @op2.tipo == "caracter" || @op1.tipo == "caracter" && @op2.tipo == "variable" || @op1.tipo == "variable" && @op2.tipo == "variable"
				@tipo = "variable"
			else  @tipo = "error"
			end

		elsif @oper == "Suma" ||  @oper == "Multiplicacion" || @oper == "Resta" || @oper == "Division" || @oper == "Modulo"
			if @op1.tipo == "entero" && @op2.tipo == "entero"
				@tipo = "entero"
			elsif @op1.tipo == "variable" && @op2.tipo == "entero" || @op1.tipo == "entero" && @op2.tipo == "variable" || @op1.tipo == "variable" && @op2.tipo == "variable"
				@tipo = "variable"
			else @tipo = "error"
			end
		elsif 
			if @oper == "Punto" && @op1.tipo == "variable"
				if @op2.tipo == "entero"
					@tipo = "variable"
				else
					puts "\n El operando '#{@op2.valor}'debe ser tipo entero "
					exit
				end                                                                                                            
			elsif  @oper == "Punto"
				puts "\n El identificador '#{@op1.valor}' debe ser una variable declarada"
				exit
			end
			
		else
			if @op1.tipo == "booleano" && @op2.tipo == "booleano" || @op1.tipo == "entero" && @op2.tipo == "entero"
				@tipo = "booleano"
			elsif @op1.tipo == "variable" && (@op2.tipo == "booleano" || @op2.tipo == "entero"  ) || (@op1.tipo == "booleano" || @op1.tipo == "entero"  ) && @op2.tipo == "variable" || @op1.tipo == "variable" && @op2.tipo == "variable"
				@tipo = "variable"
			else @tipo = "error"
			end
		end

		#puts @tipo
		#puts @op2.valor
		
		if @tipo == 'error'
			
			puts Error2ope.new(@op1,@oper,@op2).to_s()
			exit
		end
	end


	def to_s(tab)
		s = "\n" + (" "*(tab)) +"Operacion binaria: \n"

		s << (" "*(tab+3)) + "oper izquierdo: " + @op1.to_s(tab+6)
		s <<(" "*(tab+5)) + "operador: " + @oper + "\n" 

		s << (" "*(tab+3)) + "oper derecho: " + @op2.to_s(tab+6)
		
		return s
	end
end

class Punto < ExpresionDosOper
	def initialize(op1,op2)
        super(op1, op2,"Punto")
    end

end

class Modulo < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"Modulo")
        @valorR = @op1.valorR.to_i % @op2.valorR.to_i
    end
end


class Concatenacion < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"Concatenacion")
    end
end


class Multiplicacion < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"Multiplicacion")
        @valorR = @op1.valorR.to_i * @op2.valorR.to_i
    end
end


class Suma < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"Suma")
        @valorR = @op1.valorR.to_i + @op2.valorR.to_i
    end
end


class Resta < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"Resta")
        @valorR = @op1.valorR.to_i - @op2.valorR.to_i
    end
end


class Division < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"Division")
        if @op2.valorR != 0
        	@valorR = @op1.valorR.to_i / @op2.valorR.to_i
        else
        	puts "no puedes realizar divisiones entre 0 \n"
        	exit
        end
    end
end


class Desigualdad < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"Desigualdad")
    end
end


class Menor < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"Menor")
    end
end


class MenorIgual < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"MenorIgual")
    end
end


class Igual < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"Igual")
    end
end


class Mayor < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"Mayor")
    end
end


class MayorIgual < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"MayorIgual")
    end
end


class And < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"Conjuncion")
    end
end


class Or < ExpresionDosOper

    def initialize(op1,op2)
        super(op1, op2,"Disyuncion")
    end
end


class ExpresionUnOperDer
	# op 	: 	Recibe el operador que afecta la expresión.
	# oper 	: 	Recibe el operando que es afectado por el operador unario.
	attr_accessor :op, :oper,:valor, :tipo

	def initialize(op, oper)
		@op = op
		@oper = oper
		@valor = $simbolos[@oper] + @op.valor
		if @oper== "Not" && @op.tipo == "booleano"
				@tipo = "booleano"
		elsif @oper== "MenosUnario" && @op.tipo == "entero"
				@tipo = "entero"
		else
			if @op.tipo == "caracter"
				@tipo = "caracter"
			elsif @op.tipo == "variable"
				@tipo = "variable"
			else
				@tipo = "error"
			end
		end
		if @tipo == 'error'
			puts Error1opeD.new(@oper,@op).to_s()
			exit
		end	
			
	end

	def to_s(tab)
		return @oper + " \n" + (" "*(tab+2)) + "lado derecho: " + @op.to_s(tab+4)
	end
end


class Not < ExpresionUnOperDer

	def initialize(op)
        super(op,"Not")
    end
end


class Shift < ExpresionUnOperDer

	def initialize(op)
        super(op,"Shift")
    end
end


class MenosUnario < ExpresionUnOperDer

	def initialize(op)
        super(op,"MenosUnario")
    end
end


class ValorAscii < ExpresionUnOperDer

	def initialize(op)
        super(op,"ValorAscii")
    end
end

class ExpresionUnOperIzq
	# op 	: 	Recibe el operador que afecta la expresión.
	# oper 	: 	Recibe el operando que es afectado por el operador unario.
	attr_accessor :op, :oper, :valor , :tipo

	def initialize(op, oper)
		@op = op
		@oper = oper
		@valor = @op.valor 
		@tipo = "caracter"
	end

	def to_s(tab)
		return (" "*tab) + @oper + ": \n" + (" "*(tab+2)) + "lado izquierdo: \n" + @op.to_s(tab+4)
	end
end


class SiguienteCar < ExpresionUnOperIzq

	def initialize(op)
        super(op,"")
    end
    def to_s(tab)
		return (" "*tab) + "SiguienteCar de: " + @op.to_s() + "\n"
	end
end


class AnteriorCar < ExpresionUnOperIzq

    def initialize(op)
        super(op,"")
    end
    def to_s(tab)
		return (" "*tab) + "AnteriorCar de: " + @op.to_s()
	end
end




class Literal

	attr_accessor :valor, :tipo, :valorR

	def initialize(valor, tipoI, tipo)
		@valor = valor
		@tipoI = tipoI
		@tipo = tipo
		@valorR = valor
	end

	def to_s(tab)
		return "\n"+ (" "*tab) + @tipoI.to_s() + @valor.to_s() + "\n"
	end
end


class Entero < Literal

	def initialize(valor)
		#puts "soy #{valor}"
		super(valor, "valor numerico: ", "entero")
	end
	
end

class Letra < Literal
	def initialize(valor)
		super(valor, "valor del caracter: ","caracter")
	end
end



class True < Literal

    def initialize()
        valor = 'True'
		super(valor, "Valor booleano: ", "booleano")
	end
end

class False < Literal

    def initialize()
        valor = 'False'
		super(valor, "Valor booleano: ", "booleano")
	end
end


class Variable < Literal

	def initialize(valor)
		super(valor, "\n ", "variable")
	end

	def to_s(tab)
		return   @valor.to_s() + "\n"
	end
end
