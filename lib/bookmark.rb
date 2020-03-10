require 'pg'
class Bookmark
  
  def self.all
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test')
    else
      connection = PG.connect(dbname: 'bookmarks_database')
    end

    result = connection.exec('SELECT * FROM bookmarks')
    result.map { |bookmarks| p bookmarks['url'] }
  end
end