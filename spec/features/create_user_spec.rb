require 'rails_helper'

RSpec.describe "Creating an user", type: :feature, js: true do
  before { visit new_user_path }
  scenario 'valid inputs' do
    fill_in 'user_name', with: 'Teste name'
    fill_in 'user_twitterUrl', with: 'https://twitter.com/chimaka_waka'
    click_on 'Salvar'
    expect(page).to have_content('Usuario criado com sucesso')
  end
  scenario 'invalid url' do
    fill_in 'user_name', with: 'Teste name'
    fill_in 'user_twitterUrl', with: 'aaaaa'
    click_on 'Salvar'
    expect(page).to have_content('Usuario não encontrado')
  end
  scenario 'url is not a twitter' do
    fill_in 'user_name', with: 'Teste name'
    fill_in 'user_twitterUrl', with: 'https://guides.rubyonrails.org/testing.html'
    click_on 'Salvar'
    expect(page).to have_content('Usuario não encontrado')
  end
  scenario 'url is not a valid twitter user' do
    fill_in 'user_name', with: 'Teste name'
    fill_in 'user_twitterUrl', with: 'https://twitter.com/chimaka_wakaaaa'
    click_on 'Salvar'
    expect(page).to have_content('Usuario não encontrado')
  end
end
