class Movie < ActiveRecord::Base
  def self.all_ratings
    rating_list = Array.new

    self.select("rating").uniq.each do |x|
      rating_list << x.rating
    end

    return rating_list.sort.uniq
  end
end
