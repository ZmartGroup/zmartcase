require 'spec_helper'

describe 'signup and login' do

  it 'accepts new user' do
    visit '/login'
    click_link 'Sign up'
    sign_up_and_log_in_with "kalle", "Karlsson", "Kalle@mail.se", "kalle123"
    expect(page).to have_content('Log out')
  end

end

def sign_up_and_log_in_with(first_name, last_name, email, password)
  sign_up_with first_name, last_name, email, password
  log_in_with first_name, last_name, email, password
end

def sign_up_with(first_name, last_name, email, password)
  fill_in 'First name', with: first_name
  fill_in 'Last name', with: last_name
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  fill_in 'Password confirmation', with: password
  click_button 'Create user'
end

def log_in_with(first_name, last_name, email, password)
  fill_in 'Email', with: email
  fill_in 'password', with: password
  click_button 'Log in'
end