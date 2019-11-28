class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @gift = Gift.find(params[:gift_id])
  end

  def create
    @gift = Gift.find(params[:gift_id])
    # Token is created using Stripe Checkout or Elements!
    # Get the payment token ID submitted by the form:
    token = params[:stripe_token]

    charge = Stripe::Charge.create({
        amount: (@gift.amount * 100).to_i,
        currency: 'cad',
        description: "Charge for gift #{@gift.id} by #{current_user.full_name} (#{current_user.id})",
        source: token,
    });
    @gift.update(txn_id: charge.id)
    redirect_to @gift.receiver, notice: 'Thanks for completing the payment'
    rescue => e
      puts "Error #{e.message}"
      flash.now[:alert] = 'Problem handling the payment, please try again.'
      render :new
  end
end
