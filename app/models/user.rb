class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :location, :phone, :language, :experience, :qualification, :price, :achievements, :description, :token

  before_create :create_token

  belongs_to :sport
  belongs_to :location

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :sport, presence: true

  validate :presence_of_coach_or_player_attr


  def self.create_user(params)
  	user = if params[:is_coach]
  		coach_params params
  	else
  		player_params params
  	end

  	user
  end




  private

  	def create_token
      self.token ||= SecureRandom.urlsafe_base64
    end

    def self.coach_params(params)
    	location = Location.create(location: params[:location], latitude: params[:latitude], longitude: params[:longitude])
    	user = User.new(
    		email: params[:email],
    		password: params[:password],
    		password_confirmation: params[:password],
    		first_name: params[:first_name],
    		last_name: params[:last_name],
    		sport: Sport.find_by_name(params[:sport].strip),
    		location: location,
    		phone: params[:phone],
  			language: params[:language],
  			experience: params[:experience],
  			qualification: params[:qualification],
  			price: params[:price],
  			achievements: params[:achievements],
  			description: params[:description],
  			is_coach: true
    		)
    end

    def self.player_params(params)
    	user = User.new(
    		email: params[:email],
    		password: params[:password],
    		password_confirmation: params[:password],
    		first_name: params[:first_name],
    		last_name: params[:last_name],
    		sport: Sport.find_by_name(params[:sport].strip),
    		is_coach: false
    		)
    end


    def presence_of_coach_or_player_attr
    	if self.is_coach?
    		attributes = ["location", "phone", "language", "experience", "qualification", "price", "achievements", "description"]
    		attributes.each { |attr| self.errors.add(attr.to_sym, "can't be blank") if self.send(attr).nil? }
 			
    	end
    end

end
