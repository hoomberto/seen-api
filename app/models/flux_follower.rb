# class FluxFollower < ApplicationRecord
#   belongs_to :user
#   belongs_to :flux_friend, class_name: 'User'

#   def self.purge
#     delete_all
#   end

#   def self.distribute
#     users = User.all.order('RANDOM()')
#     increment = 0.2

#     users.each do |user|
#       if increment >= 1.0
#         return 0
#       else
#         increase = (users.count - (users.count * increment)).round
#         (increase).times do
#           fake_follower = User.find(User.pluck(:id).sample)
#           until user.flux_friends.include?(fake_follower) == false &&
#                      fake_follower.id != user.id &&
#                      user.friends.include?(fake_follower) == false do

#             fake_follower = User.find(User.pluck(:id).sample)
#           end
#           user.flux_friends << fake_follower
#         end
#         increment += 0.2
#       end
#     end
#   end
# end


class FluxFollower < ApplicationRecord
  belongs_to :user
  belongs_to :flux_friend, class_name: 'User'

  def self.purge
    delete_all
  end

  def self.distribute
    purge
    users = User.all.to_a.shuffle
    total_users = users.count

    users.each_with_index do |user, index|
      # 1. Compute target: scaled by the position in the shuffled list.
      target = total_users - (total_users * (index.to_f / total_users))
      
      # 2. Introduce randomness: +/- up to 20% of the target. Adjust this for more/less randomness.
      variability = [1, (target * 0.2).round].max
      flux_friends_count = [1, target + rand(-variability..variability)].max

      # 3. Get potential flux friends for this user
      potential_flux_friends = users - [user] - user.flux_friends.to_a

      # 4. Get the flux friends for this user and add them.
      flux_friends = potential_flux_friends.sample(flux_friends_count)
      user.flux_friends << flux_friends
    end
  end
end