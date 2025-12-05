# frozen_string_literal: true

class CustomersController < ApplicationController
  def index
    @customers = Customer.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @customer = Customer.find(params[:id])
  end
end
