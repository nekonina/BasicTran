#!/usr/bin/env ruby

# = Main.rb
#
#	Irina Marcano 13-10805
#	Fernando Gonzalez 08-10464 
#
#

require_relative 'Lexer'
require_relative 'Parser'
require_relative 'Verificaciones'
require_relative 'Valores'

def main
    if ARGV.length != 1
    puts "Solo admite un parametro, el nombre del archivo."
    exit;
    end
    archivo = File::read(ARGV[0])

    begin
        #creamos un Lexer que analice la entrada
        lexer = Lexer::new archivo
        lexer.leer()
        #puts lexer.tokens
        #puts "mis errores son: #{lexer.errores}"
        if !(lexer.errores.empty?)
            lexer.errores.each do |imp|
                imp.imprimir()
            end
        else
            begin
                
                pars = Parser.new(lexer.listaTokens)
                ast =  pars.parse
                ast.verificacion()
                ast.valores()
                puts ast.to_s()
                rescue ErrorSintactico => e
                    puts e
                return

            end
        end
    end
end

main