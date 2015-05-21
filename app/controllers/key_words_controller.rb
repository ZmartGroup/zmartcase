class KeyWordsController < ApplicationController
  def edit
  	@key_word = KeyWord.find(params[:id])
  end

  def delete
  end

  def create
  	@key_word = KeyWord.new(params[:key_word])
    @key_word.save

    redirect_to(:back)

  end

  def update
  	@key_word = KeyWord.find(params[:id])
    @key_word.update_attributes(params[:key_word])

    if @key_word.save
      redirect_to(:back)
    else
      render action: 'edit'
    end
  end

  def destroy
    @key_word = KeyWord.find(params[:id])
    @key_word.destroy
    #redirect_to root_path
    redirect_to(:back)
  end

end
