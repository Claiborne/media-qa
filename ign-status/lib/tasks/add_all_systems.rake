namespace :db do
  desc "add IGN systems to the database"
  task :addsystems => :environment do
    ['IGN.com', 'Article CMS', 'Video CMS', 'Slotter CMS', 'Image CMS', 'Object CMS'].each do |name|
      Status.create :system => name
    end
  end
end