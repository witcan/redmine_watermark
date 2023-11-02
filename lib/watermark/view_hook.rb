module Watermark
  class ViewHook < Redmine::Hook::ViewListener
    def view_layouts_base_body_bottom(context={})
      path = Redmine::CodesetUtil.replace_invalid_utf8(context[:request].path_info);

      html = "\n<!-- [watermark plugin] path:#{path} -->\n"
      html << stylesheet_link_tag("watermark", plugin: "redmine_watermark")


      return html if Setting.plugin_redmine_watermark['watermark_enable'] != 'on'

      count = 0
      tmp_arr = []
      if Setting.plugin_redmine_watermark['watermark_enable_username'] == 'on'
        count += 1
        tmp_arr << User.current.name
      end
      if Setting.plugin_redmine_watermark['watermark_enable_timestamp'] == 'on'
        count += 1
        tmp_arr << format_date(Time.current)
      end
      if Setting.plugin_redmine_watermark['watermark_custom_text'].present?
        count += 1
        tmp_arr << Setting.plugin_redmine_watermark['watermark_custom_text']
      end

      count.times do |i|
        html << "\n
          <div class='watermark watermark#{i+1}'></div>
        \n"
        html << "
          <script type=\"text/javascript\">\n
            $(function(){
              const generateWatermark = (name) => {
                return `<svg xmlns='http://www.w3.org/2000/svg' version='1.1' height='300px' width='300px'><text transform='translate(100, 300) rotate(-30)' fill='rgba(45,45,45,0.1)' font-size='18'>${encodeURIComponent(name)}</text></svg>`;
              };
              var watermark#{i+1} = '#{tmp_arr[i]}';
              const finalContent#{i+1} = decodeURIComponent(generateWatermark(watermark#{i+1}));
              $('.watermark#{i+1}').css('background-image', `url(\"data:image/svg+xml;charset=utf-8,${finalContent#{i+1}}\")`);
              $('.watermark#{i+1}').css('height', $('#wrapper').height() + 'px');
            })
          "
        html << "\n</script>\n"
      end
      html << "
          <script type=\"text/javascript\">\n
          $(window).resize(function() {
            $('.watermark').css('height', $('#wrapper').height() + 'px');
          });
      "
      html << "\n</script>\n"
      return html
    end
  end
end
