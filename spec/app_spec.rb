# spec/app_spec.rb
require File.expand_path '../spec_helper.rb', __FILE__

describe 'The Irontwit' do

	context "homepage" do
		before(:each) { get("/")}
		it "renders the homepage" do
	#		binding.pry
			expect(last_response).to be_ok
		end
		it "has form" do
			expect(last_response.body).to include("form")
		end
	end

	context "register" do
		it "post" do
			post("/register", username: "manolete", password: "12345")
			expect(session).to be_truthy
		end

		it "adds a user" do
			size = @@users.size
			post("/register")
			expect(@@users.size).to eq(size + 1)
		end
	end

	context "login" do
		it "post valid user" do
			@@users.push(User.new("manolete","12345"))
			post("login", username: "manolete", password: "12345")
			expect(session[:logged_in]).to be_truthy
		end

		it "post invalid user" do
			post("login", username: "", password: "")
			expect(session[:logged_in]).to be_falsey
		end
	end

	context "profile" do
		it "no logged in" do
			get("/profile")
			expect(last_response).not_to be_ok
		end
		it "logged user" do
			post("/register", username: "manolete", password: "12345")
			get("/profile")
			expect(last_response).to be_ok
		end
	end
	# it "profile" do
	# 	get("/profile")
	# 	session[:logged_in] = true
	# 	binding.pry
	# 	expect(last_response.body).to include("logout")

	# end

	it "/timeline" do
		get("/timeline")
		expect(last_response).to be_ok
	end

	context "logout" do
		before(:each) {get("/logout") }

		it "should set the session as logget out" do
			expect(session[:logged_in]).to be_falsey
		end
	end
  	pending "/crear_twit"
end