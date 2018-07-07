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
end
