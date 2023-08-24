# desc 'purge FluxFollower table'
# task :purge_followers => :environment do
#   FluxFollower.purge
#   puts 'Flux Followers purged'
# end

desc 'distribute FluxFollowers'
task :distribute_flux => :environment do
  FluxFollower.distribute
  puts 'Flux Followers distributed'
end