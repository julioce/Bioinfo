require 'sinatra'

get '/' do

	# Loads the view
	erb :'index'

end

post '/' do
	
	# Gets de DN value
	@dna = params[:dna]

	# Loads the result view
	erb :'result'

end

error do
	erb :'error'
end
