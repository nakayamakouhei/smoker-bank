# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cigarettes", type: :request do
  let(:user) { create(:user) }
  let!(:cigarette) { create(:cigarette) }

  describe "GET /cigarettes/select" do
    it "未ログインならサインインへリダイレクト" do
      get select_cigarettes_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "ログイン済みなら成功" do
      sign_in user
      get select_cigarettes_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /cigarettes/update_selection" do
    before { sign_in user }

    it "銘柄未選択なら警告で戻す" do
      patch update_selection_cigarettes_path, params: { current_cigarette_id: "" }
      expect(response).to redirect_to(select_cigarettes_path)
      expect(flash[:alert]).to include("銘柄を選択してください")
    end

    it "銘柄を選択するとホームへ" do
      patch update_selection_cigarettes_path, params: { current_cigarette_id: cigarette.id }
      expect(response).to redirect_to(authenticated_root_path)
      expect(user.reload.current_cigarette).to eq(cigarette)
    end
  end
end
