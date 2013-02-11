# encoding: utf-8
require 'sinatra'

# Default values
CODON_TO_AMIOACID_HASH = {"TTT" => "F", "TTC" => "F", "TTA" => "L", "TTG" => "L", "TCT" => "S", "TCC" => "S", "TCA" => "S", "TCG" => "S", "TAT" => "Y", "TAC" => "Y", "TGT" => "C", "TGC" => "C", "TGG" => "W", "CTT" => "L", "CTC" => "L", "CTA" => "L", "CTG" => "L", "CCT" => "P", "CCC" => "P", "CCA" => "P", "CCG" => "P", "CAT" => "H", "CAC" => "H", "CAA" => "Q", "CAG" => "Q", "CGT" => "R", "CGC" => "R", "CGA" => "R", "CGG" => "R", "ATT" => "I", "ATC" => "I", "ATA" => "I", "ATG" => "M", "ACT" => "T", "ACC" => "T", "ACA" => "T", "ACG" => "T", "AAT" => "N", "AAC" => "N", "AAA" => "K", "AAG" => "K", "AGT" => "S", "AGC" => "S", "AGA" => "R", "AGG" => "R", "GTT" => "V", "GTC" => "V", "GTA" => "V", "GTG" => "V", "GCT" => "A", "GCC" => "A", "GCA" => "A", "GCG" => "A", "GAT" => "D", "GAC" => "D", "GAA" => "E", "GAG" => "E", "GGT" => "G", "GGC" => "G", "GGA" => "G", "GGG" => "G", "TAA" => "*", "TAG" => "*", "TGA" => "*"}
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
	# Gets de DNA value, make upper case and remove space and new lines
	@dna = params[:dna].upcase.gsub(/[\s\r\n]+/, "")

	# Verifies if it's not empty DNA
	if @dna.size == 0
		@error_message = DNA_EMPTY
		erb :'error'
	# Verifies if it's mod 3 correct codon
	elsif (@dna.size % 3) != 0
		@error_message = NOT_MOD_3
		erb :'error'
	# Verifies a valid DNA
	elsif @dna.scan(/[^ACGT]/).size > 0
		@error_message = NOT_VALID_DNA
		erb :'error'
	else
		# Variable to store the result protein
		@protein = ""

		# Associates de codon with the respective aminoacid
		(@dna.size/3).times do |index|
			# Gets the next 3 letters from offset index*3
			codon = @dna[index*3, 3]
			
			# Concatenates new aminoacid
			unless CODON_TO_AMIOACID_HASH[codon].nil?
				@protein = @protein + CODON_TO_AMIOACID_HASH[codon]
			end
		end

		# Loads the result view
		erb :'result'
	end
end

error do
	@error_message = ERROR
	erb :'error'
end
