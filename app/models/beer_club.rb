class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  has_many :confirmed_memberships, -> { where(confirmed: true) },
           class_name: "Membership"

  has_many :confirmed_members, through: :confirmed_memberships, source: :user

  has_many :applied_memberships, -> { where(confirmed: [nil, false]) },
           class_name: "Membership"

  has_many :applied_members, through: :applied_memberships, source: :user
end
