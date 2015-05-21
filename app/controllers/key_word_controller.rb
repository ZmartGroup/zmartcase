class KeyWordController < ApplicationController
  def edit
  end

  def delete
  end

  def create
  end

  def update
  	@key_word = KeyWord.find(params[:id])
    @key_word.update_attributes(params[:word, :point])

    if @key_word.save
      redirect_to root_path, notice:  'Key word uppdated'
    else
      render action: 'edit'
    end
  end

end
