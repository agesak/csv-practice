require 'csv'

def get_all_olympic_athletes(filename)

  all_athletes = CSV.read(filename, headers: true).map{|row| row.to_h}
  athlete_array = []
  all_athletes.each do |hash|
    athlete_array.push(hash.select{|k, v| REQUIRED_OLYMPIAN_FIELDS.include?(k)})
  end

  return athlete_array
end


def replace_medal(data)
  data.each do |row|
    if row["Medal"] == "NA"
      row["Medal"] = 0
    else
      row["Medal"] = 1
    end
  end
end

def total_medals_per_team2(athlete_array_of_hashes)
  medal_count = Hash.new(0)
  athlete_array_of_hashes.each do |athlete_hash|
    if athlete_hash["Medal"] != "NA"
      medal_count[athlete_hash["Team"]] += 1
    end
    return medal_count
  end

def total_medals_per_team(olympic_data)
  teams = []
  olympic_data.each do |hash|
    if hash["Medal"] != "NA"
      teams.push(hash["Team"])
    end
  end

  teams = teams.uniq
  team_hash = Hash[teams.zip Array.new(teams.length) {0}]
  teams.each do |team|
    sum = 0
    data = olympic_data.select{|hash| hash["Team"]==team}
    data = replace_medal(data)
    sum += data.map{|row| row["Medal"]}.reduce(:+)
    team_hash[team] = sum
  end

    return team_hash
end

def get_all_gold_medalists(olympic_data)
  return olympic_data.filter{|hash| hash["Medal"] == "Gold"}
end
