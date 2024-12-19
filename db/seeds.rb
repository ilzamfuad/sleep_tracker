Dir[File.join(Rails.root.to_s, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end
