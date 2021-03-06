# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  avatar                 :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  username               :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :notification_setting, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :followings, class_name: 'Relationship', foreign_key: 'following_id', dependent: :destroy
  has_many :followers, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :following_users, through: :followings, source: :followed
  has_many :activities, dependent: :destroy
  has_many :chatroom_users, dependent: :destroy
  has_many :chatrooms, through: :chatroom_users
  has_many :messages, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  validates :username, uniqueness: true, presence: true

  after_create :create_notification_setting

  scope :recent, ->(count) { order(created_at: :desc).limit(count) }

  def own?(object)
    id == object.user_id
  end

  def like?(post)
    like_posts.include?(post)
  end

  def like(post)
    like_posts << post
  end

  def unlike(post)
    like_posts.destroy(post)
  end

  def following?(user)
    following_users.include?(user)
  end

  def follow(user)
    following_users << user
  end

  def feed
    Post.where(user_id: following_user_ids << id)
  end
end
