activity org.ruboto.test_app.StackActivity

setup do |activity|
  start = Time.now
  loop do
    @text_view = activity.findViewById(42)
    break if @text_view || (Time.now - start > 60)
    sleep 1
  end
  assert @text_view
end

# ANDROID: 10, PLATFORM: 0.5.3,      JRuby: 1.7.3    '[28, 33, 46, 63]' expected, but got '[43, 48, 45, 62]'
# ANDROID: 10, PLATFORM: 0.5.4,      JRuby: 1.7.3    '[28, 33, 45, 62]' expected, but got '[28, 33, 44, 61]'
# ANDROID: 15, PLATFORM: STANDALONE, JRuby: 1.7.0    '[28, 33, 51, 68]' expected, but got '[28, 33, 47, 64]'
# ANDROID: 16, PLATFORM: 0.5.6,      JRuby: 1.7.3    '[28, 33, 45, 62]' expected, but got '[28, 33, 44, 61]'
# ANDROID: 16, PLATFORM: 0.6.0,      JRuby: 9000.dev '[28, 33, 45, 62]' expected, but got '[28, 33, 45, 63]'
# ANDROID: 19, PLATFORM: STANDALONE, JRuby: 1.7.20   '[28, 33, 43, 60]' expected, but got '[28, 33, 44, 61]'
# ANDROID: 20, PLATFORM: 1.0.2,      JRuby: 1.7.12   '[28, 33, 44, 61]' expected, but got '[28, 33, 43, 60]'
# ANDROID: 21, PLATFORM: 1.0.2,      JRuby: 1.7.12   '[28, 33, 44, 61]' expected, but got '[28, 33, 43, 60]'
# ANDROID: 22, PLATFORM: STANDALONE, JRuby: 1.7.20   '[28, 33, 44, 61]' expected, but got '[28, 33, 43, 60]'
# ANDROID: 23, PLATFORM: STANDALONE, JRuby: 1.7.19   '[28, 33, 43, 60]' expected, but got '[26, 31, 40, 57]'
test('stack depth') do |activity|
  os_offset =
      case android.os.Build::VERSION::SDK_INT
      when 13 then [1, 1, 1, 1]
      when (15..19) then [0, 0, 1, 1]
      when 23 then [-2, -2, -3, -3]
      else [0, 0, 0, 0]
      end
  jruby_offset =
      case org.jruby.runtime.Constants::VERSION
      when /^1\.7/ then [0, 0, 0, -1]
      else [0, 0, 0, 0]
      end
  version_message ="ANDROID: #{android.os.Build::VERSION::SDK_INT}, PLATFORM: #{org.ruboto.JRubyAdapter.uses_platform_apk ? org.ruboto.JRubyAdapter.platform_version_name : 'STANDALONE'}, JRuby: #{org.jruby.runtime.Constants::VERSION}"
  assert_equal [28 + os_offset[0] + jruby_offset[0],
                33 + os_offset[1] + jruby_offset[1],
                43 + os_offset[2] + jruby_offset[2],
                61 + os_offset[3] + jruby_offset[3]], [
                   activity.find_view_by_id(42).text.to_i,
                   activity.find_view_by_id(43).text.to_i,
                   activity.find_view_by_id(44).text.to_i,
                   activity.find_view_by_id(45).text.to_i], version_message
end
