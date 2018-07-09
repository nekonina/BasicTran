#	Irina Marcano 13-10805
#	Fernando Gonzalez 08-10464 
#
#


#clase denominada ElementoTexto, que reprecenta cada elemento en una posicion determinada
#de un texto, de ella se desprenderan la clase Token y la clase Error
class ElementoTexto
	attr_accessor :linea, :columna, :contenido
end



#la clase Token es una instancia de de la clase ElementoTexto, el cual contiene un contexto y una 
#RegExp que permitira la identificacion del token dentro del texto. 
#Como la mayoria de las clases tienen un contenido vacio, pondremos en la clase Token contenido vacio,
#mas adelante modificaremos el contenido a aquellas que lo requieran
class Token < ElementoTexto
	class << self
		attr_accessor :basicTran
	end
	attr_accessor :linea, :columna

end

#la clase Error tabien es una instancia de la clase Elementotexto la cual se encarga de almacenar
#los elementos @mal estructurados del texto, indicanco la posicion en la que se encuentra y
#el fragmento de texto del cual esta conformado
class Error < ElementoTexto
	def initialize(linea, columna, contenido)
    	@linea   = linea
    	@columna = columna
    	@contenido   = contenido
	  end
	
	#este metodo se encarga de imprimir por pantalla el error en el formato requerido por el enunciado
   	def imprimir()
   		puts "Error: caracter inesperado \"#{@contenido}\" en línea #{@linea}, columna #{@columna}."
	  end
	  
end



#A continuacion se procede a definir el diccionario que se encarga de asociar las RegExp con los
#Tokens y palabras reservadas señaladas en el enunciado
dicTokens = {
	'Punto' => /\A\./,				'Num' => /^[0-9]*$/,
	'Caracter' => /^"'"."'"$/,		'Id' => /^[a-z][a-zA-Z0-9_]*/,
	'Coma' => /\A,/,				'DosPuntos' => /\A:/,
	'ParAbre' => /\A\(/,			'ParCierra' => /\A\)/,
	'CorcheteAbre' => /\A\[/,		'CorcheteCierre' => /\A\]/,		
	'Resta' =>/\A-(?!>)$/,			'Hacer' =>/\A->(?!>)/,
	'Asignacion' => /\A<-(?!-)/,	'Suma' => /\A\+/,
	'Desigualdad' => /\A\/=/,		'PuntoYComa' => /\A;/,
	'Mult' => /\A\*/,				'Div' => /\A\/(?!=)/,
	'Mod' => /\A%(?!=)/,			'Conjuncion' => /\A\/\\/,
	'Disyuncion' => /\A\\\//,		'Negacion' => /\Anot/,
	'Menor' => /\A<$/,				'MenorIgual' => /\A<=/,
	'Mayor' => /\A>$/,				'MayorIgual' => /\A>=/,
	'Igual' => /\A=/,				'SiguienteCar' => /\A\+\+/,
	'AnteriorCar' => /\A--/,		'ValorAscii' => /\A#/,
	'Concatenacion' => /\A::/,		'Shift' => /\A\$/,
}

$caracteres = /=|>|<|\+|-|\*|%|;|,|\(|\)|\.|\[|:|\$|#|\/|\]|\)|[a-zA-Z0-9]/

$simDobles= /--|::|->|<-|\/\\|\\\/|<=|>=|\+\+|\/=| /

#Escribimos las palabras reservadas del lenguaje
palabras_reservadas = %w(with true false var begin end int while if otherwise bool char array read of print for step from to)

#Procedemos a meter dentro de nuestro diccionario de tokens, los
#tokens relacionados a nuestras palabras reservadas.
palabras_reservadas.each do |palabra|
	dicTokens[palabra.capitalize] = /\A#{palabra}\b/
end

#Creamos las clases para cada tipo de token que poseemos en nuestro diccionario de tokens,
#(las cuales pertenecen a la clase Token) , las mismas se inicializan para tener el contexto
#del token esto incluye: linea y columna donde es encontrado el texto y el posible contenido
#que tenga el token, luego procedemos a renombrar cada clase como TK + nombre del token
dicTokens.each do |tok_nombre, basicTran|
	nuevaClase = Class::new(Token) do
		@basicTran = basicTran

		def initialize(linea, columna, contenido)
			@linea = linea
			@columna = columna
			@contenido = contenido
		end

	end

	Object::const_set "Tk#{tok_nombre}", nuevaClase
end
$dicTokens = []
ObjectSpace.each_object(Class) do |objeto|
	$dicTokens << objeto if objeto.ancestors.include? Token  and objeto!=Token
end

#en la clase token agregamos un metodo de impresion segun el formato necesitado en el cual
#algunos tokens tendran un string vacio por contenido ya que carecen de argumentos.
class Token
	def cont
		''
	end
	def imprimir
		puts "#{self.class.name} #{cont} #{@linea},#{@columna}"
	end
end

#Las TkNum, TkId, TkCaracter deben almacenar algun tipo de contenido en un formato
#determinado, por ende son modificadas de igual forma
class TkNum
	#debe devolver el numero para poder imprimirlo por pantalla
	def cont
		@contenido.inspect
	end
	def imprimir
		puts "#{self.class.name} (#{cont}) #{@linea},#{@columna}"
	end
end

class TkId
	#debe devolver el identificador de la variable que corresponde al acompañante de un var
	def cont
		@contenido.inspect
	end
	def imprimir
		puts "#{self.class.name} (#{cont}) #{@linea},#{@columna}"
	end
end

class TkCaracter
	#debe devolver el string que se encuentra entre comillas simples o dobles
	def cont
		a = @contenido.inspect
		real = a[1..-3] + '\''
		return real
	end
	def imprimir
		puts "#{self.class.name} #{cont} #{@linea},#{@columna}"
	end

end

#clase lexer que se encargara de llevar la data de la salida mientras
#es recorrida la entrada de texto, se inicializa con listas vacias de
#tokens y errores para ser almacenados alli, ademas de los indices de
#filas y columnas quienes posteriormente daran la situacion de los dos
#elementos de texto definidos (tokens o errores)
class Lexer
	attr_reader :tokens, :errores , :listaTokens

	def initialize(archivo)
		@errores = []
		@tokens = []
		@listaTokens = []
		@linea = 1
		@columna = 1
		@archivo = archivo
	end

	def next_token()
		if not (listaTokens.empty?)
    		tok = @listaTokens.shift
    	else
    		tok = [false,false]
    	end
    	return tok
  	end
	#metodo que se encarga de revisar la entrada y clasificarlo en error
	#o token y los agrega a su respectiva lista del lexer con su situacion
	#indicada por la fila y la columna.
	def buscar(p)
		
			$dicTokens.each do |t|
				if p =~ t.basicTran
						nuevo1 = t.new(@linea,@colInicio,p)
						@tokens << nuevo1
						#mostrarResultado()
						return
				end
			end

				#puts "NO hizo match #{p}"
				error = Error.new(@linea,@colInicio,p)
				@errores << error
				if @mal == 1
					@mal = 0
				end
				return
	end
	def buscarCar(p)
		if p.length == 3
			nuevo = p[1]		
			if nuevo =~ $caracteres
					#puts "hizo match #{t}"
						nuevo = TkCaracter.new(@linea,@colInicio,p)
						@tokens << nuevo
						return
			end
		elsif p.length == 4
			#puts "hizo match: #{p}"
			p1 = p[1,2]
			#puts "evaluamos: #{p1}"

			if p1 =~ /\\[n,t] || \\''' || \\\\ / 
				nuevo = TkCaracter.new(@linea,@colInicio,p)
						@tokens << nuevo
						return
			end

		end
			error = Error.new(@linea,@colInicio,p)
			@errores << error
			return
			

	end
	#metodo de la clase lexer que se encarga de llamar a la impresion
	#de la salida según sea el caso requerido, (errores o tokens)
	def mostrarResultado()
		if @errores.empty?
			return @tokens
		else
			@errores.each do |imp|
				imp.imprimir()
			end
		end
	end

	def leer()
		p = ''
		@var = []
		str = 0 	#semaforo para detectar los caracteres
		num = 0 	#semaforo para detectar numeros pegados a otras cosas
		sim = 0 	#semaforo para detectar simbolos pegados a otras cosas
		ltr = 0  	#semaforo para detectar los TkId
		@mal = 0 	#semaforo para detectar los TkId que inician con mayusculas
		@colInicio= @columna
		return nil if @archivo.empty?
		@archivo.each_char do |simbolo|
			if ((simbolo == " ") or (simbolo == "\t"))
				if str ==1 || str==2
					#puts "soy #{p}"
					str = 0
					buscarCar(p)
				
				elsif @mal == 1
					#puts "entre"
					error = Error.new(@linea,@colInicio,p)
					@errores << error
					@mal = 0
				#	puts "soy/era #{p} #{@mal}"

				elsif p!= ''
				#	puts "soy: #{p}"
					buscar(p)
					num = 0
					sim = 0
					ltr=0


				
				end
				@columna += 1
				@colInicio= @columna
				p = ''
				#puts "soy espacio"
			elsif (simbolo =="\n")
				if str==1 || str == 2
					error = Error.new(@linea,@colInicio,p)
					@errores << error
					str = 0
					p = ''
				elsif p!= ''
					buscar(p)
					@linea += 1
					@columna = 1
					@colInicio= @columna
					p = ''
					num = 0
					sim = 0
					ltr=0
				
				else
					@linea += 1
					@columna = 1
				end
			elsif simbolo=~ TkNum.basicTran && p==''												#Detecta numeros empezando en el vacio
					@columna += 1
					num = 1
					p = p + simbolo
										
			elsif simbolo=~ TkNum.basicTran && sim ==1 											#detecta numeros despues de tener tener un simbolo
					buscar(p)
					num = 1
					sim = 0
					ltr=0
					p =''
					@columna += 1
					@colInicio= @columna
					p = p + simbolo
					#puts simbolo
					
			elsif simbolo=~ TkNum.basicTran && num == 1                          #detecta numeros despues de ya tener numeros
					@columna += 1
					p = p + simbolo
										
			elsif !(simbolo=~ TkNum.basicTran) && num == 1 						#tienes numeros pero lo siguiente no lo es
										
					num = 0
					buscar(p)
					
					@colInicio= @columna
					@columna += 1
					p = ''
					if simbolo=~ TkId.basicTran
						p = p + simbolo
						ltr = 1
					elsif simbolo == "-"|| simbolo=="+"|| simbolo=="*"|| simbolo == "<" || simbolo =="=" || simbolo =="."|| simbolo ==","|| simbolo ==";"|| simbolo ==":" || simbolo ==">" || simbolo =="/" || simbolo =="\\" || simbolo =="]" || simbolo =="[" || simbolo =="(" || simbolo ==")"
						sim = 1
						p =p +simbolo
						#puts "#{simbolo}"
					end
			elsif simbolo=~ TkId.basicTran && sim == 1 				#el anterior es un simbolo mientras que el actual es un ID

					sim = 0
					buscar(p)
					@columna += 1
					@colInicio= @columna
					p=''
					p =p +simbolo
				
					ltr = 1

			elsif not(simbolo=~ TkId.basicTran) && sim ==1 		#anterior es un simbolo mientras que el actual es otro simbolo
					
					p1 = p
					p = p +simbolo
					#puts "entre aqui y soy: #{p}"

					#puts "P1 ES: #{p1} "
					if p=~ $simDobles
						buscar(p)
						sim = 0
						p = ''
					else
						buscar(p1)
						@columna += 1
						@colInicio= @columna
						p = simbolo
						sim = 1
						@columna += 1
						@colInicio= @columna
						#puts "AHORA SOY EL simbolo: #{p} "
					end

					
					p1= ''
			elsif simbolo=~ TkId.basicTran && str == 0
					#puts "entre en un ID #{simbolo}"
					p =p +simbolo
					@columna += 1
					ltr = 1
					
			elsif (simbolo=~ TkNum.basicTran || simbolo=~ /[a-zA-Z0-9_]/ ) && ltr == 1
					p =p +simbolo
					#puts "entre ID: #{p}"
					@columna += 1

			elsif !(simbolo=~ TkId.basicTran) && ltr == 1
					#puts "entre aca #{p} #{simbolo}"

				buscar(p)
				ltr =0
				p=''
				sim = 1
				p =p +simbolo
				@colInicio= @columna
				@columna += 1
				#puts "entre: soy #{p}"
			elsif (simbolo == "\'") && str == 0
				#puts "primera comita"
				str += 1
				p = p + simbolo
				@columna += 1
			elsif (simbolo == "\'") && str == 1
				#puts "obtuve #{simbolo}"
				p = p + simbolo
				if p.length== 4
					str = 0
				  buscarCar(p)
				  @columna += 1
				  @colInicio= @columna
				  p = ''
				else
					str = 2
					@columna += 1
				end

			elsif (simbolo == "\'") && str == 2							#caso que detecta la comilla simple

				p = p + simbolo
				str = 0
				buscarCar(p)
				@columna += 1
				@colInicio= @columna
				p = ''

			elsif !(simbolo == "\'") && str == 2							#caso que detecta la comilla simple
				buscarCar(p)
				#puts "listo llegue"
				@columna += 1
				@colInicio= @columna
				p = ''
				p = p + simbolo
				str = 0
				if simbolo=~ TkId.basicTran
					p = p + simbolo
					ltr = 1
				elsif simbolo=~ TkNum.basicTran
					p = p + simbolo
					num = 1
				elsif simbolo == "-"|| simbolo=="+"|| simbolo == "<" || simbolo =="=" || simbolo =="."|| simbolo ==","|| simbolo ==";"|| simbolo ==":" || simbolo ==">" || simbolo =="/" || simbolo =="\\"
					sim = 1
					p =p +simbolo
				end
			elsif !(simbolo=~ TkId.basicTran) && str == 0
				if simbolo.downcase =~ TkId.basicTran
					@mal = 1
				else
					sim = 1
					#puts "hizo match #{simbolo}"
				end
				p =p +simbolo
				@columna += 1
			else
				p = p + simbolo
				@columna += 1
				#puts "hizo match #{p}"

										#puts "default: soy #{p}"
			end

		end
		for i in @tokens
				@listaTokens << [i.class,i]
			end
		#return @tokens, @errores
		mostrarResultado()
	end
end