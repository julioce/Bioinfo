class DNA

	# Default values from http://www.cbs.dtu.dk/courses/27619/codon.html
	CODON_TO_AMIOACID_HASH = {	"TTT" => "F", "TTC" => "F", "TTA" => "L", "TTG" => "L",
								"TCT" => "S", "TCC" => "S", "TCA" => "S", "TCG" => "S", 
								"TAT" => "Y", "TAC" => "Y", "TGT" => "C", "TGC" => "C", 
								"TGG" => "W", "CTT" => "L", "CTC" => "L", "CTA" => "L", 
								"CTG" => "L", "CCT" => "P", "CCC" => "P", "CCA" => "P", 
								"CCG" => "P", "CAT" => "H", "CAC" => "H", "CAA" => "Q", 
								"CAG" => "Q", "CGT" => "R", "CGC" => "R", "CGA" => "R", 
								"CGG" => "R", "ATT" => "I", "ATC" => "I", "ATA" => "I", 
								"ATG" => "M", "ACT" => "T", "ACC" => "T", "ACA" => "T", 
								"ACG" => "T", "AAT" => "N", "AAC" => "N", "AAA" => "K", 
								"AAG" => "K", "AGT" => "S", "AGC" => "S", "AGA" => "R", 
								"AGG" => "R", "GTT" => "V", "GTC" => "V", "GTA" => "V", 
								"GTG" => "V", "GCT" => "A", "GCC" => "A", "GCA" => "A", 
								"GCG" => "A", "GAT" => "D", "GAC" => "D", "GAA" => "E", 
								"GAG" => "E", "GGT" => "G", "GGC" => "G", "GGA" => "G", 
								"GGG" => "G", "TAA" => "*", "TAG" => "*", "TGA" => "*"}

	LETTER_TO_AMINOACID_NAME = {"I" => "Isoleucine", "L" => "Leucine", "V" => "Valine", "F" => "Phenylalanine", 
								"M" => "Methionine", "C" => "Cysteine", "A" => "Alanine", "G" => "Glycine", 
								"P" => "Proline", "T" => "Threonine", "S" => "Serine", "Y" => "Tyrosine", 
								"W" => "Tryptophan", "Q" => "Glutamine", "N" => "Asparagine", "H" => "Histidine", 
								"E" => "Glutamic acid", "D" => "Aspartic acid", "K" => "Lysine", "R" => "Arginine", 
							"*" => "Stop codons"}

	def initialize string
		@string = string
	end

	def to_s
		@string
	end

	def treat_dna_string
		@string = @string.upcase.gsub(/[\s\r\n]+/, "")
	end

	def check_not_empty
		if @string.size == 0
			return true
		else
			return false
		end
	end

	def check_not_mod_3
		if (@string.size % 3) != 0
			return true
		else
			return false
		end
	end

	def check_invalid_letters
		if @string.scan(/[^ACGT]/).size > 0
			return true
		else
			return false
		end
	end

	def create_protein_string
		# Variable to store the result protein
		protein = Array.new

		# Associates de codon with the respective aminoacid
		(@string.size/3).times do |index|
			# Gets the next 3 letters from offset index*3
			codon = @string[index*3, 3]
			
			# Check if it's known aminoacid
			if CODON_TO_AMIOACID_HASH.has_key?(codon)
				# Creates an Array with [condon, aminoacid_letter, aminoacid_name] like ["CAG", "Q", "Glutamine"]
				protein.push [codon, CODON_TO_AMIOACID_HASH[codon] , LETTER_TO_AMINOACID_NAME[CODON_TO_AMIOACID_HASH[codon]]]
			end
		end

		return protein
	end

	def protein_to_s protein
		string = ''
		protein.each do |aminoacid|
			string += aminoacid[1]
		end

		return string
	end

	def distribution sequence
		lenght = sequence.length.to_f
		
		dist = {}

		sequence.composition.each do |nuc, count|
			dist[nuc] = count/lenght.to_f
		end
		return dist
	end

end