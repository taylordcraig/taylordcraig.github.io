require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do

    it 'will have a title' do
      p = Post.new(body: 'thisbody')
      p.valid?
      expect(p.errors).to have_key(:title)
    end

    it 'will have a title length of 7' do
      p = Post.new(title: 'not', body: 'anotherbody')
      p.valid?
      expect(p.errors).to have_key(:title)
    end

    it 'will have a body' do
      p = Post.new(title: 'validttitle')
      p.valid?
      expect(p.errors).to have_key(:body)
    end

  describe 'body_snippet' do
    it 'will put out 100 characters followed by ...' do
      p = Post.new(title: 'Post1', body: 'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
      hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
      hhhhhhhhhhjjjjj')
      result = p.body_snippet
      expect(result.length).to be < 104
    end
   end
  end
 end
