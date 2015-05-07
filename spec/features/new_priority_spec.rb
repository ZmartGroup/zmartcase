require 'spec_helper'

describe 'new priority' do

  it 'should be able to create new priority' do

    sign_up_and_log_in_with "kalle", "Karlsson", "Kalle@mail.se", "kalle123"

    # I know expecting something and the clicking it is redundent, but it is nice to have confirmed reason if failing
    expect(page).to have_link('Priorities')
    click_link 'Priorities'

    expect(page).to have_link('New priority')
    click_link 'New priority'

    expect(page).to have_content('New Priority')
    fill_in 'Name', with: 'Asa viktig'

    expect(page).to have_button('Create')
    click_button 'Create'

    expect(page).to have_link('New priority')

  end

end