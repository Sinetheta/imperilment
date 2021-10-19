admin = User.new(email: 'admin@example.com', password: 'test123')
admin.save!(validate: false)
admin.add_role(:admin)