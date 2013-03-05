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

  def build_interior_with_history(interior_data)
    new_interior_data = interior_data.dup

    new_history = new_interior_data.delete(:interior_history)

    interior = interiors.build(new_interior_data)
    if new_history and
       (new_history[:width].present? or new_history[:height].present? or new_history[:depth].present?)
      new_history[:start_date] = Date.today
      interior.interior_histories.build(new_history)
    end

    interior
  end
end
