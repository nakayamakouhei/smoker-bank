# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SelectionGuard", type: :request do
  let(:user) { create(:user) }
  let!(:cigarette) { create(:cigarette) }

  describe "POST /smokes without selection" do
    it "銘柄未選択なら選択画面へリダイレクト" do
      sign_in user
      post smokes_path, params: { smoke: { packs: 1 } }

      expect(response).to redirect_to(select_cigarettes_path)
      expect(flash[:alert]).to include("銘柄を選択してください")
    end
  end

  describe "POST /custom_cigarette_logs without selection" do
    it "カスタム銘柄未選択なら選択画面へリダイレクト" do
      sign_in user
      post custom_cigarette_logs_path, params: { custom_cigarette_log: { packs: 1 } }

      expect(response).to redirect_to(select_cigarettes_path)
      expect(flash[:alert]).to include("銘柄を選択してください")
    end
  end
end
