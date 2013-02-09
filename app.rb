# encoding: utf-8

require 'sinatra'

get '/' do

	# Loads the view
	erb :'index'

end

post '/' do

	# Gets de DNA value
	@dna = params[:dna].upcase

	#Verifies if it's mod 3 correct codon
	if (@dna.size % 3) != 0
		@error_message = "Seu DNA não possui o número correto de códons, múltiplo de 3."
		erb :'error'
	else
		# Associates de codon with the respective aminoacid 
		@codon_to_amioacid_hash ={:ATG=> "M", :TCG=> "S", :GTA=> "V", :GAA=> "E", :GAC=> "D", :ATT=> "I", :TTT=> "F", :AAA=> "K", :ACT=> "T", :ATG=> "M", :TAT=> "Y", :GAA=> "E", :TCC=> "S", :GTA=> "V", :CCG=> "P", :GAA=> "E", :CCC=> "P", :AAG=> "K", :AAG=> "K", :AAT=> "K", :TGC=> "N"}
		

		# Loads the result view
		erb :'result'
	end

end

error do
	@error_message = "O administrador do sistema será notificado."
	erb :'error'
end
