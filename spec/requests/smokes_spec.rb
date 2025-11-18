# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Smokes", type: :request do
  let(:user) { create(:user) }
  let!(:cigarette) { create(:cigarette) }

  before do
    user.update!(current_cigarette: cigarette)
    sign_in user
  end

  describe "POST /smokes" do
    it "smoke を作成し合計を再計算する" do
      expect {
        post smokes_path, params: { smoke: { packs: 2 } }
      }.to change { user.smokes.count }.by(1)

      expect(response).to redirect_to(authenticated_root_path)
      created = user.smokes.last
      expect(created.packs).to eq(2)
      expect(created.cigarette).to eq(cigarette)
    end
  end

  describe "DELETE /smokes/:id" do
    let!(:smoke) { create(:smoke, user:, cigarette:, packs: 1) }

    it "自分の smoke を削除する" do
      expect {
        delete smoke_path(smoke)
      }.to change { user.smokes.count }.by(-1)

      expect(response).to redirect_to(histories_path)
    end
  end
end
