# encoding: utf-8
require 'sinatra'

# Loads all models in models directory
Dir['./models/*.rb'].each {|file| require_relative file }

NOT_MOD_3 = "Seu DNA não possui o número correto de códons, múltiplo de 3 bases."
NOT_VALID_DNA = "Seu DNA parece não ser feito somente das bases A, C, G e T."
DNA_EMPTY = "Você precisa analisar pelo menos 1 códon."
ERROR = "Houve um erro no sistema.<br/>O administrador será notificado."

# Loads the start page
get '/' do
	# Loads the view
	erb :'index'
end

# Process DNA and loads results
post '/' do
	# Creates DNA object
	@dna = DNA.new params[:dna]
	
	# Gets de DNA value, make upper case and remove space and new lines
	@dna.treat_dna_string

	# Verifies if it's not empty DNA
	if @dna.check_not_empty
		@error_message = DNA_EMPTY
		erb :'error'
	# Verifies if it's mod 3 correct codon
	elsif @dna.check_not_mod_3
		@error_message = NOT_MOD_3
		erb :'error'
	# Verifies a valid DNA
	elsif @dna.check_invalid_letters
		@error_message = NOT_VALID_DNA
		erb :'error'
	else
		@protein = @dna.create_protein_string

		# Loads the result view
		erb :'result'
	end
end

error do
	@error_message = ERROR
	erb :'error'
end
