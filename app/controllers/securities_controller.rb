class SecuritiesController < ApplicationController
  # GET /securities
  # GET /securities.json
  def index
    @securities = Security.where("user_id = ?", current_user.id)
  end

  # GET /securities/1
  # GET /securities/1.json
  def show
    @security = Security.find(params[:id])
  end

  # GET /securities/new
  # GET /securities/new.json
  def new
    @security = Security.new
  end

  # GET /securities/1/edit
  def edit
    @security = Security.find(params[:id])
  end

  # POST /securities
  # POST /securities.json
  def create
    @security = Security.new(params[:security])
    @security.user_id = current_user.id
    respond_to do |format|
      if @security.save
        format.html { redirect_to @security, notice: 'Security was successfully created.' }
        format.json { render json: @security, status: :created, location: @security }
      else
        format.html { render action: "new" }
        format.json { render json: @security.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /securities/1
  # PUT /securities/1.json
  def update
    @security = Security.find(params[:id])

    respond_to do |format|
      if @security.update_attributes(params[:security])
        format.html { redirect_to @security, notice: 'Security was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @security.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /securities/1
  # DELETE /securities/1.json
  def destroy
    @security = Security.find(params[:id])
    @security.destroy

    respond_to do |format|
      format.html { redirect_to securities_url }
      format.json { head :no_content }
    end
  end
end
