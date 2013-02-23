# encoding: utf-8
require 'sinatra'
require 'bio'
require 'open-uri'

# Loads all models in models directory
Dir['./models/*.rb'].each {|file| require_relative file }

NOT_MOD_3 = "Seu DNA não possui o número correto de códons, múltiplo de 3 bases."
NOT_VALID_DNA = "Seu DNA parece não ser feito somente das bases A, C, G e T."
DNA_EMPTY = "Você precisa analisar pelo menos 1 códon."
ERROR = "Houve um erro no sistema.<br/>O administrador será notificado."
BLAST_ERROR = "O NCBI BLAST não encontrou nenhum resultado.<br />Por favor tente outra sequência."

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
		sequence = Bio::Sequence::NA.new(@dna.to_s.downcase)

		# Calculates composition and DNA distributions
		@composition = sequence.composition
		@distribution = @dna.distribution sequence
		
		# Loads the result view
		erb :'result'
	end
end

post '/fasta' do
	# Creates BioRuby object as sequence
	sequence = Bio::Sequence::NA.new(params[:protein])

	# Code the sequence to a valid FAST file
	sequence.to_fasta("protein", 60)
end

# http://www.ncbi.nlm.nih.gov/staff/tao/URLAPI/new/node4.html
post '/blast' do
	# Creates a BLAST object
	blast = BLAST.new params[:protein]

	# Send the requeste to NCBI server and get de rID of the search
	rID = blast.get_rID

	# Gets the result file on text format
	result_page = blast.get_file rID

	# Check if it's not a empty result page
	if blast.check_if_no_result result_page
		# Creates DNA object
		@dna = DNA.new params[:dna]
		
		# Gets de DNA value, make upper case and remove space and new lines
		@dna.treat_dna_string
		@error_message = BLAST_ERROR
		erb :'error'
	else
		# Format file to browser view
		"<pre>" + result_page + "</pre>"
	end

end

error do
	@error_message = ERROR
	erb :'error'
end
