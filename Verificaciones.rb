#	Irina Marcano 13-10805

require_relative 'AST_yo'
require_relative 'Parser'

#crearemos nuestra tabla de scopes
$scopes = []
$scopeImp =[]
$noIni = []
$tam = 0
$idFor = 0
$idF = ""
#verificamos si el id ya existe en la tabla de simbolos actuales
def existeYa(tabla, id)
	if tabla.empty?
		return false
	else
		return tabla.has_key?(id)
	end
end

def Encontrar(id)
	$scopes.each do |alcance|
		#puts alcance
		if existeYa(alcance,id)
			return true, alcance[id]
		end
	end

	return false, "error"
end

def verificarIni(id)
	g = 0
	$noIni.each do |ini|
		#puts alcance
		if ini == id
			return true, g
		end
		g += 1
	end

	return false, false
end
##############################################################
class ErrorYaExiste< ErrorContexto
	def initialize(token)
		@token = token
	end

	def to_s()
		"\n Error: Ya se encuentra declarada '#{@token}' en el mismo bloque "

	end
end

class ErrorNoCoincide< ErrorContexto
	def initialize(token,valor,tipo)
		@token = token
		@valor  = valor
		@tipo = tipo
	end

	def to_s()
		"\n Error: la expresion #{@valor} asignada a: #{@token} no es del tipo #{@tipo} "

	end
end

class ErrorNoDeclarado< ErrorContexto
	def initialize(token)
		@token = token
	end

	def to_s()
		"\nError: #{@token} no esta declarada "
	end
end

class Incompatibles <ErrorContexto
	def initialize(token1,token2)
		@token1 = token1
		@token2 = token2
	end

	def to_s()
		"\nError: #{@token1} no se puede operar con #{@token2} "
	end
end

class IncompatiblesSigno <ErrorContexto
	def initialize(token1,token2, oper)
		@token1 = token1
		@token2 = token2
		@oper = oper
	end

	def to_s()
		"\nError: #{@token1} #{$simbolos[@oper]} #{@token2} no se puede operar."
	end
end

class ErrorTipo< ErrorContexto
	def initialize(token, tipo)
		@token = token
		@tipo = tipo
	end

	def to_s()
		"\nError: la asignacion hecha a #{@token} no es de tipo #{@tipo} "
	end
end

########################################################################
class Programa
	def verificacion()
		if @instruccion != nil 
			 @instruccion.verificacion()
			 puts "\n##################################################"
			 puts "############## Tabla de Simbolos #################"
			 puts $scopeImp
			 puts "################################################## \n"

		end
	end
end

class WBloque

	def verificacion()

		tabla = Hash.new
		$tam += 1
		@declaraciones.verificacion(tabla)
		$scopes.unshift(tabla)
		$scopeImp << tabla
		#puts $scopes
		#puts $noIni
		@instrucciones.verificacion()
		$scopes.delete(tabla)
		$tam -= 1

	end
end

class LDeclaracionS

	def verificacion(tabla)
		@declaracion.verificacion(tabla)
	end
end

class LDeclaracionRec

	def verificacion(tabla)
		@declaraciones.verificacion(tabla)
		@declaracion.verificacion(tabla)

	end
end

class Declaracion

	def verificacion(tabla)
		@argumentos.verificacion(tabla, @tipo)
	end
end

class Argumento
	def verificacion(tabla, tipoP)
		if existeYa(tabla,@id)
			puts ErrorYaExiste.new(@id).to_s()
			exit
		else
			if @exp == nil 
				if tipoP.tipo == 'entero' ||tipoP.tipo == 'booleano' || tipoP.tipo == 'caracter'
					tabla[@id]= tipoP.tipo
				else 
					tabla[@id]= tipoP
				end
				$noIni.insert(0, @id)
			elsif tipoP.tipo == @tipo
				tabla[@id]= tipoP.tipo
			else
				puts ErrorNoCoincide.new(@id,@exp.valor,tipoP.tipo).to_s()
				exit
			end
		end
		if @arg != nil
			@arg.verificacion(tabla, tipoP)
		end
	end
end

class ArgumentoId
	def verificacion(tabla, tipoP)
		if existeYa(tabla,@id)
			puts ErrorYaExiste.new(@id).to_s()
			exit
		else	
			tabla[@id]= tipoP.tipo
			$noIni.insert(0, @id)
		end
		@exp.verificacion(tabla, tipoP)
	end
end

class Asignacion
	
	def verificacion()
		if $idFor == 1 && @id== $idF
			puts "\n No puedes realizar asignaciones sobre '#{@id}' dentro de este bloque"
			exit
		end

		esta, tipo = Encontrar(@id.valor)
		noInic, pos = verificarIni(@id.valor)
		#puts "soy #{@id.valor} #{tipo}"
		if esta
			if tipo != @tipo && @tipo != "variable"
				puts ErrorTipo.new(@id.valor,tipo).to_s()
				exit
			elsif tipo != @tipo && @tipo == "variable"
				#puts "entre"
				
				@expresion.verificacion()
				#puts @expresion.tipo
				@tipo = @expresion.tipo

				#puts "soy #{@tipo}"
				if noInic
					$noIni.delete_at(pos)
				end
				if  tipo != @tipo
					puts ErrorTipo.new(@id.valor,tipo).to_s()
					exit
				end
			end
		else
			puts ErrorNoDeclarado.new(@id.valor).to_s()
				exit
		end
	end
end

class Variable < Literal

	def verificacion()
		esta, tipo = Encontrar(@valor)
		@tipo = tipo
		#puts "#{@valor}"
		return @valor
	end
end


class ExpresionDosOper
	def decidir()
		if @oper == "Concatenacion" && @tipo == "caracter"
			@tipo = @tipo
			
		elsif (@oper == "Suma" ||  @oper == "Multiplicacion" || @oper == "Resta" || @oper == "Division" || @oper == "Punto" || @oper == "Modulo") && @op2.tipo== "entero"
			@tipo = "entero"
			#puts "aqui"
		else 
			if (@oper == "Desigualdad" ||  @oper == "Menor" || @oper == "MenorIgual" || @oper == "Igual" || @oper == "Mayor" || @oper == "MayorIgual" || @oper == "Conjuncion" || @oper == "Disyuncion")
				@tipo = "booleano"
				#puts @tipo
			else
				@tipo = "error"
			end
		end
		#puts @tipo
	end

	def verificacion()
		
		if @op1.tipo == "variable" && @op2.tipo == "variable"

			#verificamos si las variables que se van operan estan inicializadas
			#puts @op1.valor
			noInic1, pos1 = verificarIni(@op1.valor)
			
			if noInic1
				puts "\nPara operar con #{@op1.valor} debe inicializarla primero" 
				exit
			end
			#puts @op2.valor
			noInic2, pos2 = verificarIni(@op2.valor)
			if noInic2
				puts "\nPara operar con #{@op2.valor} debe inicializarla primero" 
				exit
			end

			@op2.verificacion()
			@op1.verificacion()

			#puts "entre"
			#puts @op2.tipo
			#puts @op1.tipo
			#puts @oper
			#puts "-------------------"
			
				if @op2.tipo != @op1.tipo
					puts Incompatibles.new(@op1.valor,@op2.valor).to_s()
					exit
				else

					decidir()
					#puts @tipo
				end
				if @tipo == "error"
					puts  IncompatiblesSigno.new(@op1.valor,@op2.valor,@oper).to_s()
					exit
				end
			

		elsif @op2.tipo == "variable"
			
			noInic2, pos2 = verificarIni(@op2.valor)
			
			if noInic2
				puts "\n Para operar con #{@op2.valor} debe inicializarla primero" 
				exit
			end
			esta, @tipo1 = Encontrar(@op2.verificacion())
			#puts "entre"
			#puts "------"
			if esta
				if @tipo1 != @op1.tipo
					puts Incompatibles.new(@op1.valor,@op2.valor).to_s()
					exit
				else
					decidir()
					
				end
			else
				puts ErrorNoDeclarado.new(@op2.valor).to_s()
					exit
			end

		elsif @op1.tipo == "variable"
			#puts @op1.valor
			noInic1, pos1 = verificarIni(@op1.valor)
			
			if noInic1
				puts "\n Para operar con #{@op1.valor} debe inicializarla primero" 
				exit
			end
			esta, @tipo1 = Encontrar(@op1.verificacion())
			#puts @tipo1
			#puts @op2.tipo
			#puts "------"
			if esta
				if @tipo1 != @op2.tipo
					puts Incompatibles.new(@op1.valor,@op2.valor).to_s()
					exit
				else
					decidir()
					#puts @tipo
				end
			else

				puts ErrorNoDeclarado.new(@op1.valor).to_s()
				exit
			end
		elsif  @op1.tipo != "variable" && @op2.tipo != "variable"
			#puts "entrw"
			#puts  @op1.valor
			#puts @op2.valor
			#puts "------"
			if @op1.tipo != @op2.tipo
				puts  IncompatiblesSigno.new(@op1.valor,@op2.valor,$simbolos[@oper]).to_s()
				exit
			else
				@tipo = @op1.tipo
				if (@tipo == "entero" || @tipo == "booleano") &&  (@oper == "Desigualdad" ||  @oper == "Menor" || @oper == "MenorIgual" || @oper == "Igual" || @oper == "Mayor" || @oper == "MayorIgual" || @oper == "And" || @oper == "Or")
						@tipo = "booleano"
						return @tipo
					else
						return @tipo
					#puts @tipo
					end
				#puts @tipo
			end
		end
	end
end

class Literal
	def verificacion()
		return @valor
	end
end

class ExpresionUnOperIzq
	
	def verificacion()
		noInic, pos = verificarIni(@op.valor)
		if noInic
				puts "Para operar con #{@op1.valor} debe inicializarla primero" 
				exit
		end
	end
end

class ExpresionUnOperDer
	def decidir()
		if @oper== "Not" && @tipo2 == "booleano"
				@tipo = "booleano"
		elsif @oper== "MenosUnario" && @tipo2 == "entero"
				@tipo = "entero"
		else
			if @tipo2 == "caracter"
				@tipo = "caracter"
			else
				@tipo = "error"
			end
		end
	end

	def verificacion()
		noInic, pos = verificarIni(@op.valor)
		if noInic
				puts "Para operar con #{@op1.valor} debe inicializarla primero" 
				exit
		end
		if @op1.tipo == "variable"
			esta, @tipo2 = Encontrar(@op1.verificacion())
			if esta
				decidir()
				if @tipo =="error"
					puts ErrorTipo.new(@op1.valor,tipo).to_s()
					exit
				else
					return @tipo
				end
			else
				puts ErrorNoDeclarado.new(@op1.valor).to_s()
				exit
			end
					
		end
	end
end

class Iteracion_DetStep
	def verificacion()
		esta, tipo = Encontrar(@id)
		$idFor = 1
		$idF = @id
		if esta
			tabla1 = Hash.new
			tabla1[@id] = "entero"
			$tam += 1
			$scopes.unshift(tabla1)
			$scopeImp << tabla1
			@inst.verificacion()
			$scopes.delete(tabla1)
			$tam -= 1
		else
			@inst.verificacion()
		end
		$idFor = 0
		$idF = ""
	end
end

class Iteracion_Det
	def verificacion()
		esta, tipo = Encontrar(@id)
		$idFor = 1
		$idF = @id
		if esta
			tabla = Hash.new
			tabla[@id] = "entero"
			$tam += 1
			$scopes.unshift(tabla)
			$scopeImp << tabla
			@inst.verificacion()
			$scopes.delete(tabla)
			$tam -= 1
		else
			@inst.verificacion()
		end
		$idFor = 0
		$idF = ""
	end
end

class Read
	def verificacion()
		noInic, pos = verificarIni(@id.valor)
			
			if noInic
				puts "\n Para poder leer #{@id.valor} debe inicializarla primero" 
				exit
			end
		esta, tipo = Encontrar(@id.valor)

		if esta
			if tipo != "entero" && tipo != "booleano" && tipo != "caracter"
				puts "\n El identificador #{id} de archivo, no tiene un tipo permitido"
				exit
			end
		else
			puts ErrorNoDeclarado.new(@id.valor).to_s()
			exit
		end
	end
end

class Print
	def verificacion()
		if salida.tipo == 'variable'
			noInic2, pos2 = verificarIni(@salida.valor)
			
			if noInic2
				puts "\n Para operar con #{@salida.valor} debe inicializarla primero" 
				exit
			end
		end
		@salida.verificacion()
	end
end

class Iteracion_Indet
	def verificacion()
		@condicional.verificacion()
		if @condicional.tipo != 'booleano'
			puts "\n El condicional del while debe ser una expresion Booleana"
			exit
		end
		
		@inst.verificacion()
	end
end

class IfOtherEnd
	def verificacion()
		@guardia.verificacion()
		if @guardia.tipo != 'booleano'
			puts "\n El condicional del while debe ser una expresion Booleana"
			exit
		end
		@intr.verificacion()
		@intr2.verificacion()
	end
end

class IfEnd
	def verificacion()
		@guardia.verificacion()
		if @guardia.tipo != 'booleano'
			puts "\n El condicional del while debe ser una expresion Booleana"
			exit
		end
		@intr.verificacion()
	end
end

class Bloque
	def verificacion()
		@instrucciones.verificacion()
	end
end

class Instrucciones
	def verificacion()
		@instrucciones.verificacion()
		@accion.verificacion()
	end
end