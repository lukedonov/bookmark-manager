# frozen_string_literal: true

require 'bookmark'

describe Bookmark do
  describe '.all' do
    it 'returns all bookmarks' do
      connection = PG.connect(dbname: 'bookmark_manager_test')

      bookmark = Bookmark.create(url: "http://www.makersacademy.com", title: "Makers Academy")
      Bookmark.create(url: "http://www.destroyallsoftware.com", title: "Destroy All Software")
      Bookmark.create(url: "http://www.google.com", title: "Google")
      
      bookmarks = Bookmark.all

      expect(bookmarks.length).to eq 3
      expect(bookmarks.first).to be_a Bookmark
      expect(bookmarks.first.id).to eq bookmark.id
      expect(bookmarks.first.title).to eq 'Makers Academy'
      expect(bookmarks.first.url).to eq 'http://www.makersacademy.com'
    end
  end

  describe '.create' do
    it 'does not create a new bookmark if the URL is not valid' do
      Bookmark.create(url: 'not a real bookmark', title: 'not a real bookmark')
      expect(Bookmark.all).to be_empty
    end
    
    it 'creates a new bookmark' do 
      bookmark = Bookmark.create(url: 'http://www.facebook.com', title: 'Facebook')
      persisted_data = PG.connect(dbname: "bookmark_manager_test").query("SELECT * FROM bookmarks WHERE id = #{bookmark.id};")

      expect(bookmark).to be_a Bookmark
      expect(bookmark.id).to eq persisted_data.first['id']
      expect(bookmark.title).to eq 'Facebook'
      expect(bookmark.url).to eq 'http://www.facebook.com'
    end
  end

  describe '.delete' do
    it "deletes the given bookmark" do
      bookmark = Bookmark.create(url: 'http://www.facebook.com', title: 'Facebook')

      Bookmark.delete(id: bookmark.id)

      expect(Bookmark.all.length).to eq 0
    end
  end

  describe '.update' do
    it "edits existing bookmarks" do
      bookmark = Bookmark.create(url: 'http://www.facebook.com', title: 'Facebook')
      updated_bookmark = Bookmark.update(id: bookmark.id, url: 'http://www.twitter.com', title: 'Twitter')

      expect(updated_bookmark).to be_a Bookmark
      expect(updated_bookmark.id).to eq bookmark.id
      expect(updated_bookmark.title).to eq 'Twitter'
      expect(updated_bookmark.url).to eq 'http://www.twitter.com'
    end
  end

  describe ".find" do 
    it 'returns the requested bookmark object' do
      bookmark = Bookmark.create(title: 'Facebook', url: 'http://www.facebook.com')

      result = Bookmark.find(id: bookmark.id)

      expect(result).to be_a Bookmark
      expect(result.id).to eq bookmark.id
      expect(result.title).to eq 'Facebook'
      expect(result.url).to eq 'http://www.facebook.com'
    end
  end
end
