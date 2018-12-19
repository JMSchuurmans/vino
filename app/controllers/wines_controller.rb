class WinesController < ApplicationController
  before_action :log_in_check, only: [:create, :edit, :destroy]
  before_action :correct_user_check, only: [:edit, :destroy]

  def new
    @wine = Wine.new
    render :layout => 'alternate'
  end

  def create
    @user = current_user
    @wine = current_user.wines.build(wine_params)
    if @wine.save
      flash[:success] = "Success!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @wine = Wine.find(params[:id])
    render :layout => 'alternate'
  end

  def update
    @user = current_user
    @wine = Wine.find(params[:id])
    if @wine.update_attributes(wine_params)
      flash[:success] = "Wine successfully updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = current_user
    @wine.destroy
    flash[:success] = "Wine deleted"
    redirect_back(fallback_location: root_url)
  end

  private

    def wine_params
      params.require(:wine).permit(:name, :winery, :vintage, :origin, :price, :rating, :tasting_notes)
    end

    def correct_user_check
      @wine = current_user.wines.find_by(id: params[:id])
      redirect__back(fallback_location: root_url) if @wine.nil?
    end
end
