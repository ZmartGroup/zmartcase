require 'spec_helper'

describe 'signup and login' do

  it 'should accept new user' do

    # included module from /support/login_helper.rb
    sign_up_and_log_in_with "kalle", "Karlsson", "Kalle@mail.se", "kalle123"
    expect(page).to have_content('Log out')

  end

end

