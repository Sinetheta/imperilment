require 'spec_helper'

feature 'Question page' do
  let(:answer) { create :answer }
  before do
    answer.update(answer: "_answer_")
    sign_in
  end

  scenario 'answer with markdown' do
    visit "/games/#{answer.game.id}/answers/#{answer.id}/questions/new"
    expect(page).to have_selector('em', text: 'answer')
  end
end
