# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user, password: "Password123!", password_confirmation: "Password123!") }

  describe "GET /profile/edit" do
    it "ログインしていないとリダイレクト" do
      get edit_profile_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "ログイン時に成功する" do
      sign_in user
      user.update!(current_cigarette: create(:cigarette))
      get edit_profile_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /profile" do
    before do
      sign_in user
      user.update!(current_cigarette: create(:cigarette))
    end

    it "名前だけ更新できる" do
      patch profile_path, params: { user: { name: "New Name" } }
      expect(response).to redirect_to(edit_profile_path)
      expect(flash[:notice]).to include("プロフィールを更新しました")
      expect(user.reload.name).to eq("New Name")
    end

    it "バリデーションエラーの場合は422で再表示" do
      patch profile_path, params: { user: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(user.reload.name).not_to eq("")
    end
  end
end
