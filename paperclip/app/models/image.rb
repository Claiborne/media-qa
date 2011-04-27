class Image < ActiveRecord::Base
  has_attached_file :image,
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/config.yml",
    :path => ":attachment/:id/:style/:basename.:extension",
    :bucket => 'dd-paperclip'
    #:styles => { :medium => "300x300>", :thumb => "100x100>" }
end
