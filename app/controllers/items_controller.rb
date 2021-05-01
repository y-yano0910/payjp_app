class ItemsController < ApplicationController
  before_action :find_item, only: :order

  def index
    @items = Item.all
  end

  def order
    redirect_to new_card_path and return unless current_user.card.present?

    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    customer_token = current_user.card.customer_token
    Payjp::Charge.create(
      amount: @item.price,
      customer: customer_token,
      currency: 'jpy'
    )
    # 支払い機能を利用するための環境変数の読み込み
    # カード情報の受取のためのPAYJPサイドに送るトークン定義
    # 支払い情報の生成

    ItemOrder.create(item_id: params[:id])
    # 商品のid情報を「item_id」として保存する

    redirect_to root_path
  end

  private

  def find_item
    @item = Item.find(params[:id])
  end
end
