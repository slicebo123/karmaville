class User < ActiveRecord::Base
  has_many :karma_points

  attr_accessible :first_name, :last_name, :email, :username, :karma_sum

  validates :first_name, :presence => true
  validates :last_name, :presence => true

  validates :username,
  :presence => true,
  :length => {:minimum => 2, :maximum => 32},
  :format => {:with => /^\w+$/},
  :uniqueness => {:case_sensitive => false}

  validates :email,
  :presence => true,
  :format => {:with => /^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/i},
  :uniqueness => {:case_sensitive => false}

  def self.by_karma
    # joins(:karma_points).group('users.id').order('SUM(karma_points.value) DESC')
    order('karma_sum DESC')
  end

  def self.page(page = 1)
    by_karma.limit(50).offset(50 * page)
  end


  def total_karma
    self.karma_sum
  end

  def find_karma_sum
    self.karma_points.sum(:value)
  end

  def self.max_page(page)
    if count % page == 0
      (count / page) - 1
    else
      (count / page)
    end
  end


  def full_name
    "#{first_name} #{last_name}"
  end

end
