Dir[File.join(Root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end
