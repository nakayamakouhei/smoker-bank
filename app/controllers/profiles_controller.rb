class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    # パスワード変更あり
    if user_params[:password].present?
      if @user.valid_password?(params[:user][:current_password])
        if @user.update(user_params)
          # パスワード更新後に再ログイン（セッション維持）
          bypass_sign_in(@user)
          redirect_to edit_profile_path, notice: "パスワードを変更しました。"
        else
          flash.now[:alert] = "パスワードの変更に失敗しました。"
          render :edit, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = "現在のパスワードが正しくありません。"
        render :edit, status: :unprocessable_entity
      end

    # パスワード以外の更新
    else
      if @user.update(user_params.except(:password, :password_confirmation))
        redirect_to edit_profile_path, notice: "プロフィールを更新しました。"
      else
        flash.now[:alert] = "入力内容に誤りがあります。"
        render :edit, status: :unprocessable_entity
      end
    end
  end


  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def password_blank?
    params[:user][:password].blank? || params[:user][:password_confirmation].blank?
  end

  def password_mismatch?
    params[:user][:password] != params[:user][:password_confirmation]
  end
end
