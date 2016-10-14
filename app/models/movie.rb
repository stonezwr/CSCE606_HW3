class Movie < ActiveRecord::Base
    def self.all_ratings
        ar= Array.new
        self.select("rating").uniq.each {|x| ar.push(x.rating)}
        ar.sort.uniq
    end
end
