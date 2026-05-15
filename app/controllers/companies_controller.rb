class CompaniesController < ApplicationController
  before_action :set_company, only: %i[ show edit update ]

  def show
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      current_user.update!(company_id: @company.id)
      redirect_to edit_company_url(@company), status: :see_other, notice: "自社情報を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to company_url(@company), status: :see_other, notice: "自社情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :postal_code, :address, :phone, :fax)
  end
end
