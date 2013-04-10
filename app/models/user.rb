class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_name, :login
  # attr_accessible :title, :body
  attr_accessor :login

  has_many :interiors
  has_many :category_tags

  # ログインの条件を「ユーザ名 or メールアドレス」にする
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    # カラム名loginで検索しにいかないようにする
    login = conditions.delete(:login)
    where(conditions).where(["lower(user_name) = :value OR lower(email) = :value",{:value => login.downcase}]).first
  end

  def welcome_name
    if user_name.present?
      user_name
    else
      email
    end
  end

  def create_tagging_list(tag_list)
    tagging_list = []

    tag_list.split(",").each do |tag|
      if category_tag = CategoryTag.find_tag(tag, self)
        tagging_list << category_tag
      else
        tagging_list << self.category_tags.build(name: tag)
      end
    end

    tagging_list
  end
end
