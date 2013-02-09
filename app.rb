require 'sinatra'

get '/' do

	# Loads the view file
	erb :'index'

end

post '/' do
	
	# Loads the view file
	erb :'index'

end

error do
	erb :'error'
end
