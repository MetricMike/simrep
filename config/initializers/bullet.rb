if defined? Bullet
  Bullet.enable = true
  Bullet.add_footer = true
  Bullet.stacktrace_includes = [ 'activeadmin' ]
end

if defined? ActiveRecordQueryTrace
  # ActiveRecordQueryTrace.enabled = true
end
