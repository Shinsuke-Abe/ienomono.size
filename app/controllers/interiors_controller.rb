# coding: utf-8

class InteriorsController < ApplicationController
  before_filter :authenticate_user!

  # GET /interiors
  def index
    @interiors = current_user.interiors
  end

  # GET /interiors/1
  def show(id)
    @interior = current_user.interiors.find(id)
  end

  # GET /interiors/new
  def new
    @interior = current_user.interiors.build
  end

  # GET /interiors/1/edit
  def edit(id)
    @interior = current_user.interiors.find(id)
  end

  # POST /interiors
  def create(interior)
    @interior = current_user.interiors.build(interior)

    if @interior.save
      redirect_to @interior, notice: 'Interior was successfully created.'
    else
      render action: 'new'
    end
  end

  # PUT /interiors/1
  def update(id, interior)
    @interior = current_user.interiors.find(id)

    if @interior.update_attributes(interior)
      redirect_to @interior, notice: 'Interior was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /interiors/1
  def destroy(id)
    @interior = current_user.interiors.find(id)
    @interior.destroy

    redirect_to interiors_url
  end
end
