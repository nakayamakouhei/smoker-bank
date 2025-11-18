# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CustomCigaretteLogs", type: :request do
  let(:user) { create(:user) }
  let!(:custom_cigarette) { create(:custom_cigarette, user:) }

  before do
    user.update!(current_custom_cigarette: custom_cigarette)
    sign_in user
  end

  describe "POST /custom_cigarette_logs" do
    it "カスタム銘柄のログを作成する" do
      expect {
        post custom_cigarette_logs_path, params: { custom_cigarette_log: { packs: 3 } }
      }.to change { user.custom_cigarette_logs.count }.by(1)

      expect(response).to redirect_to(authenticated_root_path)
      log = user.custom_cigarette_logs.last
      expect(log.packs).to eq(3)
      expect(log.custom_cigarette).to eq(custom_cigarette)
    end
  end

  describe "DELETE /custom_cigarette_logs/:id" do
    let!(:log) { create(:custom_cigarette_log, user:, custom_cigarette:) }

    it "カスタム銘柄のログを削除する" do
      expect {
        delete custom_cigarette_log_path(log)
      }.to change { user.custom_cigarette_logs.count }.by(-1)

      expect(response).to redirect_to(histories_path)
    end
  end
end
