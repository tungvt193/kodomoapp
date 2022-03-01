5.times do |i|
  admin = Admin.find_or_initialize_by(
    email: "admin_#{i}@gmail.com",
  )
  admin.password = "12345678"
  admin.password_confirmation = "12345678"
  admin.save
end
