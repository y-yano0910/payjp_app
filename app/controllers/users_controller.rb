class UsersController < ApplicationController
  
  def show
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    card = Card.find_by(user_id: current_user.id)

    redirect_to new_card_path and return unless card.present?
    # unless card.present?
      # redirect_to new_card_path and return
    # end と同義
    
    customer = Payjp::Customer.retrieve(card.customer_token)
    # 先程のカード情報を元に、顧客情報を取得
    @card = customer.cards.first
    # 顧客が複数カード登録している場合、その内の「最初のカード（first）情報を取得する」
  end

  def updeta
    if current_user.update(user_params)
      redirect_to root_path
    else
      redirect_to action: "show"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
