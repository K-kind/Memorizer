require 'rails_helper'

RSpec.describe 'Always dictionary', type: :system, js: true, vcr: { cassette_name: 'apis' }, retry: 3 do
  let(:user) { create(:user) }

  before do
    actual_sign_in_as user
  end

  it 'can be consulted on dashboard and lead to new learn or bookmark' do
    # open and close
    find('.fa.fa-search').click
    expect(page).to have_selector('#word:focus')
    expect(page).to have_selector('#overlay')
    find('.login-form__closer').click
    expect(page).to_not have_selector('#word')
    find('.fa.fa-search').click

    # consult a word
    find('#word').fill_in with: 'lead'
    find('#consult-submit').click
    expect(page).to have_selector('.consulted-word.active-word', text: 'lead')
    expect(page).to have_selector('.dictionary-heading__word', text: 'lead')
    expect(page).to_not have_selector('#pixabay-link', text: 'lead')
    expect(page).to_not have_select('Main word', selected: 'lead')

    # bookmark
    find('.bookmark-default', text: 'あとで学習').click
    expect(page).to have_selector('.later-list-container__list', text: 'lead')
    expect(page).to have_content 'あとで学習する'
    expect(page).to have_selector('#later-overlay')

    # close only later_list
    find('.later-modal-closer').click
    wait_for_ajax
    expect(page).to have_selector('#overlay')
    expect(page).to_not have_content 'あとで学習する'
    expect(page).to have_selector('#word')

    # consult another word
    find('#word').fill_in with: 'star'
    find('#consult-submit').click
    expect(page).to have_selector('.consulted-word.active-word', text: 'star')
    expect(page).to have_selector('.dictionary-heading__word', text: 'star')
    find('.btn-with-default.fa-edit', text: 'star').click

    # new learn page
    expect(current_path).to eq new_learn_path
    expect(page).to have_selector('.consulted-word.active-word', text: 'star')
    expect(page).to have_selector('.dictionary-heading__word', text: 'star')
    expect(page).to have_selector('#pixabay-link', text: 'star')
    expect(page).to have_select('Main word', selected: 'star')
  end
end
