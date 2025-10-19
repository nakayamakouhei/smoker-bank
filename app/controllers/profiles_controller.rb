class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    # モデル側の update_with_optional_password に全ロジックを任せる
    if @user.update_with_optional_password(user_params)
      bypass_sign_in(@user)  # 更新後もログイン維持
      redirect_to edit_profile_path, notice: "プロフィールを更新しました。"
    else
      flash.now[:alert] = @user.errors.full_messages.join("、")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end
