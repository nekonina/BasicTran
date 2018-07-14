#	Irina Marcano 13-10805

require_relative 'AST_yo'
require_relative 'Parser'
require_relative 'Verificaciones'



class Programa
	def valores()
		if @instruccion != nil
			puts "\n"
			puts "Ejecutamos el programa\n \n"
			@instruccion.valores()
			puts "Termino la ejecucion del programa \n\n"
			puts "########################################################## \n"
		end
	end
end

class Iteracion_Det
	def valores()
		puts "Ejecutamos un ciclo for\n"
		puts " con identificador: #{@id.valor}\n"
		puts " comienza en: #{@start.valores()}\n"
		puts " termina en: #{@final.valores()}\n"
		p1 = @start.valores()
		i = 1
		puts "ejecutamos las instrucciones internas\n"
		while p1 <= @final.valores()
			puts "iteracion numero: #{i-1}"
			@inst.valores()
			p1 += 1
			i += 1
		end
		puts " terminamos la ejecucion del ciclo For\n"

	end
end
class Iteracion_DetStep
	def valores()
		puts "Ejecutamos un ciclo for\n"
		puts " con identificador: #{@id.valor}\n"
		puts " comienza en: #{@start.valores()}\n"
		puts " termina en: #{@final.valores()}\n"
		puts " y avanza con un paso de: #{@step.valores()}\n"
		p1 = @start.valores()
		p = @step.valores()
		i = 1
		final = @final.valores()
		
		puts "ejecutamos las instrucciones internas\n"
		while p1 < final
			puts "iteracion numero: #{i-1}"
			#puts p1
			@inst.valores()
			p1 += p
			i += 1
		end
		if p1 != final
			puts "su valor de step: #{@step.valor} llega mas alla de #{@final.valor}"
			exit
		end
		puts " terminamos la ejecucion del ciclo For\n"

	end
end

class Instrucciones
	
	def valores()
		
		@instrucciones.valores()
		puts "Ejecutamos la siguiente instruccion: \n"
		@accion.valores()
		puts "Terminamos la ejecucion de este bloque de instrucciones. \n\n"
	end

end

class Bloque

	def valores()
		puts "ejecutamos la siguiente instruccion \n"
		@instrucciones.valores()
		puts "terminamos la ejecucion de instrucciones \n"
	end
end

class Print

	def valores()
		puts "la instruccion Print saca como resultado: "
		@salida.valores()
	end
end
class Read

	def valores()
		puts " Se esta leyendo: #{@id.valor()} \n"
	end
end

class IfOtherEnd

	def valores()
		puts "Se realiza una instruccion IfOtherEnd\n"
		if @guardia.valores()
			puts "Se cumplio la guardia y ejecutamos la siguiente instruccion: \n"
			@intr.valores()
		else
			puts "No se cumplio la guardia, ejecutamos las instrucciones del Otrewise: \n"
			@intr2.valores()
		end
	end
end

class IfEnd

	def valores()
		puts "se realiza una instruccion If\n"
		if @guardia.valores()
			puts "Se cumplio la guardia y ejecutamos la siguiente instruccion: \n"
			@intr.valores()
		else
			puts "Se  pasa a la siguiente instruccion porque no se cumple la guardia del If \n"
		end
		
	end
end

class WBloque

	def valores()
		$tabla = Hash.new
		$tam += 1
		@declaraciones.valores()
		$valores.unshift()
		#puts $scopes
		#puts $noIni

		@instrucciones.valores()
		$valores.delete_at(0)
		$tam -= 1
	end
end

class Iteracion_Indet
	def valores()
		puts "Estamos en un while: \n"
		#puts $tabla
		i = 0;
		while @condicional.valores() && i<1050
			#puts "entre"
			puts " estamos en la iteracion #{i}: "
			@inst.valores()
			i +=1
			#puts $tabla
		end
		puts "Termino de ejecutar el while \n"
		if i == 1050
			puts "Su recursion es infinita \n"
			exit
		end
	end
end

class LDeclaracionS

	def valores()
		
		@declaracion.valores()
	end
end

class LDeclaracionRec

	def valores()
		
		@declaraciones.valores()
		@declaracion.valores()
	end
end

class Declaracion

	def valores()
		if @argumentos
		end
		@argumentos.valores()
	end
end

class Argumento

	def valores()
		if @exp == nil
			if @tipoR.length == 2
				if @tam.length == 2
					$tabla[@id] = Array.new(@tam[0]) { Array.new(@tam[1]) }
					puts $tabla
				elsif @tam.length == 1
					$tabla[@id] = Array.new(@tam[0])
					puts $tabla
				elsif @tam.length > 2
				end
			else
				$tabla[@id]= nil
			end
			puts $tabla
		else
				
			$tabla[@id]= @exp.valores()
			
		end
		if @arg != nil
			@arg.valores()
		end
	end
end

class ArgumentoId

	def valores()

		if @tipoR.length == 2
				if @tam.length == 2
					$tabla[@id] = Array.new(@tam[0]) { Array.new(@tam[1]) }
				elsif @tam.length == 1
					$tabla[@id] = Array.new(@tam[0])
					
				elsif @tam.length > 2
				end
						puts $tabla
		else
			$tabla[@id]= nil
			@exp.valores()
		end

	end
end

class ValorArreglo
	def valores()
		if @tamA[0].to_i > $tabla[@valor].length
				puts "El indice #{@elemento.valor.to_i} es mas grande que la longitud de #{@id.valor}"
				exit
		end
		#puts "soy #{@tamA}"
		arr = $tabla[@valor]
		e = arr[@tamA[0].to_i]
		if @tamA.length == 2
			if @tamA[1].to_i > e.length
				puts "El indice #{@elemento2.valor.to_i} es mas grande que las columnas que tiene: #{@id.valor}"
				exit
			end
			e1 = e[@tamA[1].to_i]
			if e1 != nil
				puts "El valor de #{@valor}[#{@tamA[0]}][#{@tamA[1]}] es #{e1}"
			else
				puts "El valor de #{@valor}[#{@tamA[0]}][#{@tamA[1]}] es nil"
			end

			return e[@tamA[1].to_i]
		else

			if e != nil
				puts "El valor de #{@valor}[#{@elemento.valor}] es #{e}"
			else
				puts "El valor de #{@valor}[#{@elemento.valor}] es nil"
			end
			return e
		end
	end
end

class ValorMatriz
	def valores()
		#puts "entre"
		if @elemento.valor.to_i > $tabla[@valor].length
				puts "El indice #{@elemento.valor.to_i} es mas grande que las filas que tiene: #{@id.valor}"
				exit
		end
		arr = $tabla[@valor]

		e = arr[@elemento.valor.to_i-1]
		if @elemento2.valor.to_i > e.length
			puts "El indice #{@elemento2.valor.to_i} es mas grande que las columnas que tiene: #{@id.valor}"
			exit
		end
		e1 = e[@elemento2.valor.to_i]
		if e1 != nil
			puts "El valor de #{@valor}[#{@elemento2.valor}][#{@elemento2.valor}] es #{e1}"
		else
			puts "El valor de #{@valor}[#{@elemento2.valor}][#{@elemento2.valor}] es nil"
		end
		return
	end
end

class Asignacion
	
	def valores()
		if @id.tipo == "variable"
			e = @expresion.valores()
			#puts e
			puts "Realizamos la	asignacion de: #{e} a #{@id.valor} \n"
			$tabla[@id.valor] = e
			#puts $tabla
		else
			@id.valores()
			puts @id.tamA
			arr = $tabla[@id.valor]
			e = arr[@id.tamA[0].to_i]
		
			if @id.tamA.length == 2
				e[@id.tamA[1].to_i]= @expresion.valores()
				
				arr[@id.tamA[0].to_i] = e
				puts "Realizamos la	asignacion de: #{@expresion.valores()} a #{@id.valor}[#{@id.tamA[0]}][#{@id.tamA[1]}] \n"
			else
				puts "ess #{e}"
				arr[@id.tamA[0].to_i] = @expresion.valores()
				puts "Realizamos la	asignacion de: #{@expresion.valores()} a #{@id.valor}[#{@id.elemento.valor}] \n"
			end
			$tabla[@id.valor] = arr
			#puts $tabla
		end
	end
end

class Literal
	def valores()
		return @valor
	end
end

class Variable #--------------------------------------------------------------------------------------------------------------
	def valores()
		#puts "#{$tabla[@valor]} de #{@valor}"
		return $tabla[@valor]
	end
end

class Entero
	def valores()
		return @valor.to_i
	end	
end

class Modulo
    def valores()
        @valorR = @op1.valores().to_i % @op2.valores().to_i
        return @valorR
    end
end

class Multiplicacion

    def valores()
        @valorR = @op1.valores().to_i * @op2.valores().to_i
        return @valorR
    end
end

class Suma

    def valores()
    	#puts @op1.valor()
        @valorR = @op1.valores().to_i + @op2.valores().to_i
        return @valorR
    end
end

class Resta

    def valores()
        @valorR = @op1.valores().to_i - @op2.valores().to_i
        return @valorR
    end
end

class Division 

    def valores()
        if @op2.valores() != 0
        	@valorR = @op1.valores().to_i / @op2.valores().to_i
        	return @valorR
        else
        	puts "No puedes realizar divisiones entre 0 \n"
        	exit
        end
    end
end


class Concatenacion 		#--------------------------------------------------------------------------------------------------------------

    def valores()
       $tabla[@op1.valor] = $tabla[@op1.valor].concat($tabla[@op2.valor])
       puts $tabla
    end
end

class Punto 	
    def valores()
        $tabla[@op1.valor] =  $tabla[@op1.valor].to_i - @op2.valores().to_i
    end
end

class Desigualdad 

    def valores()
    	if @op1.valores() != @op2.valores()
    		return true
        else
        	return false
        end
    end
end

class Menor

    def valores()
    	if @op1.valores().to_i < @op2.valores().to_i
    		return true
        else
        	return false
        end
    end
end

class MenorIgual

    def valores()
    	if @op1.valores().to_i <= @op2.valores().to_i
    		return true
        else
        	return false
        end
    end
end

class Mayor

    def valores()
    	if @op1.valores().to_i > @op2.valores().to_i
    		return true
        else
        	return false
        end
    end
end

class MayorIgual

    def valores()
    	if @op1.valores().to_i >= @op2.valores().to_i
    		return true
        else
        	return false
        end
    end
end

class Igual

    def valores()
    	if @op1.valores() == @op2.valores()
    		return true
        elsif  @op1.valores().to_i == @op2.valores().to_i
        	return true
        else
        	return false
        end
    end
end

class And

    def valores()
    	if @op1.valores() == true && @op2.valores() == true
    		return true
    	else
    		return false
    	end
    end
end

class Or
    def valores()
    	if @op1.valores() == false && @op2.valores() == false
    		return false
    	else
    		return true
    	end
    end
end

class Not 

	def valores()
        if @op.valores() == true
        	return false
        else
        	return true
        end
    end
end

class Shift 	#----------------------------------------------------------------------------------------------------------------

	def valores()
        
    end
end

class MenosUnario

	def valores()
        return  -@op.valores()
    end
end

class ValorAscii
	def valores()
		return @op.valores().to_a
	end
end

class SiguienteCar #----------------------------------------------------------------------------------------------------------------

	def valores()
		e = @op.valores().to_a + 1
		return e.chr
	end
end


class AnteriorCar 

    def valores()
    	e = @op.valores().to_a - 1
		return e.chr
	end
end

