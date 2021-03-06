class User < ApplicationRecord
  before_save {self.email.downcase!}
  #{すべて小文字に変換　！は自分自身}
  validates :name, presence: true, length: {maximum: 50} 
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
                    #{大文字小文字の区別なし}
  has_secure_password
  #暗号化のためbcypt Gemが必要
  #migrationファイルにpassword_digestのカラムも用意
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: "Relationship", foreign_key: "follow_id"
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :favorites
  has_many :like_microposts, through: :favorites, source: :micropost
  

  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
 
  #すでにフォローしているか
  def following?(other_user)
    self.followings.include?(other_user)
  end
  #たとえばuser1.following?(user.2)


  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
   def like(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
   end

  def unlike(micropost)
    like = self.favorites.find_by(micropost_id: micropost.id)
    like.destroy if like
  end

  #likeしているmicropostを取得、include?()によって特定の？()が含まれていないかを確認
  def like?(micropost)
    self.like_microposts.include?(micropost)
  end

end


