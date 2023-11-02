require File.expand_path('../lib/watermark/view_hook', __FILE__)

Redmine::Plugin.register :redmine_watermark do
  name 'Redmine Watermark plugin'
  author 'AiYuHang'
  description 'This is a plugin for Redmine'
  version '1.0.1'
  url 'https://redminecn.com'
  author_url 'https://redminecn.com'
  settings default: {}, partial: 'settings/watermark_config'
end
