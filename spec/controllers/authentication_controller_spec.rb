require_relative "../rails_helper"

RSpec.describe AuthenticationController do
  describe "#authenticate" do
    let!(:user) { create(:user, name: "Piet Mondrian") }

    context "correct user credentials" do
      before do
        post(
          :authenticate,
          params: { email: user.email, password: user.password },
          as: :json
        )
      end

      it "returns 200" do
        expect(response.status).to eq(200)
      end

      it "generates the token for the user" do
        expect(response_body.key?("token")).to be_truthy
        expect(response_body.key?("expires_at")).to be_truthy
      end
    end

    context "incorrect user credentials" do
      before do
        post(:authenticate, params: { email: user.email }, as: :json)
      end

      it "returns 401" do
        expect(response.status).to eq(401)
      end

      it "returns 'invalid credentials' error" do
        expect(response_body).to eq(
          "error" => { "user_authentication" => ["Invalid credentials"] }
        )
      end
    end
  end
end
