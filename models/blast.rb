class BLAST
	
	def initialize protein
		@protein = protein
	end

	def get_rID
		# Assemble a PUT query for NCBI with the protein
		query_url = "http://www.ncbi.nlm.nih.gov/blast/Blast.cgi?QUERY=" + @protein + "&DATABASE=nr&PROGRAM=blastp&CMD=Put"

		# Read the response page from NCBI
		blast_page = open(query_url).read

		# Get the rID from the BLAST query
		return /value="(.*)" id="rid"/.match(blast_page).to_s[7, 11]
	end

	def get_file rID
		# Assemble the GET result query for BLAST
		get_url = "http://www.ncbi.nlm.nih.gov/blast/Blast.cgi?RESULTS_FILE=on&RID=" + rID + "&FORMAT_TYPE=Text&FORMAT_OBJECT=Alignment&CMD=Get"

		# Read the response page from NCBI
		result_page = open(get_url).read

		# The result may not be avaliable, waiting to run
		while /class="WAITING"/.match(result_page).to_s.size > 0
			# Waiting 2secs to try again
			puts "Waiting more 5 secs..."
			sleep 5
			# New Try
			result_page = open(get_url).read
		end

		return result_page
	end

	def check_if_no_result result_page
		# Check if it's not a empty result page
		if /No significant similarity found/.match(result_page).to_s.size > 0
			return true
		else
			return false
		end
	end

end