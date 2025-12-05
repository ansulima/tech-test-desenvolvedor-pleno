

puts "🌱 Seeding database..."

email_files = Dir.glob(Rails.root.join('emails', '*.eml'))

puts "📧 Processing #{email_files.count} example email files..."

email_files.each do |file_path|
  filename = File.basename(file_path)
  content = File.read(file_path).force_encoding('UTF-8')
  
  next if EmailFile.exists?(filename: filename)
  
  puts "  Processing #{filename}..."
  
  email_file = EmailFile.create!(
    filename: filename,
    content: content,
    content_type: 'message/rfc822',
    file_size: content.bytesize
  )
  
  processor = EmailProcessorService.new(email_file.content, email_file.filename)
  result = processor.process
  
  if result[:success]
    puts "    ✅ Successfully created customer: #{result[:customer].name}"
  else
    puts "    ❌ Failed: #{result[:error]}"
  end
end

puts "\n📊 Database Statistics:"
puts "  Customers: #{Customer.count}"
puts "  Processing Logs: #{ProcessingLog.count}"
puts "    - Successful: #{ProcessingLog.successful.count}"
puts "    - Failed: #{ProcessingLog.failed.count}"
puts "  Email Files: #{EmailFile.count}"

puts "\n✅ Seeding completed!"
