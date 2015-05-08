require 'spec_helper'

describe 'new category' do

  it 'should be able to create new category' do

    sign_up_and_log_in_with "kalle", "Karlsson", "Kalle@mail.se", "kalle123"

    # I know expecting something and the clicking it is redundent, but it is nice to have confirmed reason if failing
    expect(page).to have_link('Categories')
    click_link 'Categories'

    expect(page).to have_link('New category')
    click_link 'New category'

    expect(page).to have_content('New Category')
    fill_in 'Name', with: 'Feedback'

    expect(page).to have_button('Create')
    click_button 'Create'

    expect(page).to have_link('New category')

    visit '/'
    expect(page).to have_content('Feedback')

  end

end