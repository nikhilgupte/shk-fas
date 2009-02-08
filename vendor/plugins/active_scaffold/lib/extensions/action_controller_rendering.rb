# wrap the action rendering for ActiveScaffold controllers
module ActionController #:nodoc:
  class Base
    def render_with_active_scaffold(*args, &block)
      # ACC I'm never seeing this params[:adapter] value being passed in, only args[0][:action]
      if self.class.uses_active_scaffold? and ( params[:adapter] || args[0][:action] ) and @rendering_adapter.nil?
        @rendering_adapter = true # recursion control
        # if we need an adapter, then we render the actual stuff to a string and insert it into the adapter template
        path_val = params[:adapter] || args[0][:action]
        show_layout = args[0][:layout].nil? ? true : args[0][:layout]
        render :file => rewrite_template_path_for_active_scaffold(path_val),
               :locals => {:payload => render_to_string(args.first, &block)},
               :use_full_path => false,
               :layout => show_layout
        @rendering_adapter = nil # recursion control
      else
        render_without_active_scaffold(*args, &block)
      end
    end
    alias_method :render_without_active_scaffold, :render
    alias_method :render, :render_with_active_scaffold

    # Rails 1.2.x
    if method_defined? :render_action
      def render_action_with_active_scaffold(action_name, status = nil, with_layout = true) #:nodoc:
        if self.class.uses_active_scaffold?
          path = rewrite_template_path_for_active_scaffold(action_name)
          return render(:template => path, :layout => with_layout, :status => status) if path != action_name
        end
        return render_action_without_active_scaffold(action_name, status, with_layout)
      end
      alias_method :render_action_without_active_scaffold, :render_action
      alias_method :render_action, :render_action_with_active_scaffold
    end
    # Rails 2.x implementation is post-initialization on :active_scaffold method

    private

    def rewrite_template_path_for_active_scaffold(path)
      base = File.join RAILS_ROOT, 'app', 'views'
      # check the ActiveScaffold-specific directories
      active_scaffold_config.template_search_path.each do |template_path|
        search_dir = File.join base, template_path
        next unless File.exists?(search_dir)
        # ACC I'm using this regex directory search because I don't know how to hook into the
        # rails code that would do this for me. I am assuming here that path is a non-nested
        # partial, so my regex is fragile, and will only work in that case. 
        template_file = Dir.entries(search_dir).find {|f| f =~ /^#{path}/ }
        # ACC pick_template and template_exists? are the same method (aliased), using both versions
        # to express intent.
        return File.join(search_dir, template_file) if !template_file.nil? && template_exists?(template_file)
      end
      return path
    end
  end
end
