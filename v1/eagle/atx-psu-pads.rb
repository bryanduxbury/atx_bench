puts "change drill 1.4;"
puts "change diameter auto;"

for x in [-1, 1]
  for y in (0..11)
    puts "pad (#{x * 2.75} #{((5.5 * 4.2 - y * 4.2) * 10).to_i / 10.0});"
  end
end