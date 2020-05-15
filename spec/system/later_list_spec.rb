require 'rails_helper'

RSpec.describe 'later_list', type: :system, js: true, vcr: { cassette_name: 'apis' }, focus: true do
  let(:user) { create(:user) }

  before do
    30.times do |n|
      user.later_lists.create!(word: "word#{n}")
    end
    actual_sign_in_as user
  end

  it 'can add and delte a word and lead to new learn page' do
    # later list has a pagination
    find('.fa.fa-bookmark').click
    expect(page).to have_selector('#later_list_word:focus')
    expect(page).to have_content 'あとで学習する'
    expect(page).to have_selector('a', text: 'word0')
    expect(page).to have_selector('.page', text: '2')

    # later word can be added
    find('#later_list_word').fill_in with: 'lead'
    click_button '登録'
    expect(page).to have_selector('a', text: 'lead')

    # later word can be deleted
    paginate_and_wait 1
    expect(page).to have_selector('a', text: 'word0')
    find('.later-list-container__word-delete', match: :first).click
    expect(page).to_not have_selector('a', text: 'word0')

    # link to new_learn
    paginate_and_wait 2
    click_link 'lead'

    expect(current_path).to eq new_learn_path
    expect(page).to have_selector('.consulted-word.active-word', text: 'lead')
    expect(page).to have_selector('.dictionary-heading__word', text: 'lead')
    expect(page).to have_selector('#pixabay-link', text: 'lead')
    expect(page).to have_select('Main word', selected: 'lead')
  end
end
