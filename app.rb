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

post '/blast' do
	# Assemble a PUT query for NCBI with the protein
	QUERY_URL = "http://www.ncbi.nlm.nih.gov/blast/Blast.cgi?QUERY=" + params[:protein] + "&DATABASE=nr&PROGRAM=blastp&CMD=Put"

	# Read the response page from NCBI
	blast_page = open(QUERY_URL).read

	# Get the rID from the BLAST query
	rID = /value="(.*)" id="rid"/.match(blast_page).to_s[7, 11]

	# Assemble the GET result query for BLAST
	GET_URL = "http://www.ncbi.nlm.nih.gov/blast/Blast.cgi?RESULTS_FILE=on&RID=" + rID + "&FORMAT_TYPE=Text&FORMAT_OBJECT=Alignment&CMD=Get"

	# Read the response page from NCBI
	result_page = open(GET_URL).read

	# The result may not be avaliable, waiting to run
	while /class="WAITING"/.match(result_page).to_s.size > 0
		# Waiting 2secs to try again
		puts "Waiting more 5secs..."
		sleep 5
		# New Try
		result_page = open(GET_URL).read
	end

	# Format to browser view
	"<pre>" + result_page + "</pre>"
end

error do
	@error_message = ERROR
	erb :'error'
end
