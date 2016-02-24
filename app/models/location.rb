class Location < ActiveRecord::Base
	enum neighborhoods: [ :Brickell, :Wynwood, :Overtown ]
end
