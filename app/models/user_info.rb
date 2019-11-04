class UserInfo < ApplicationRecord
    mount_uploader :profile_image,ProfileImageUploader
end
